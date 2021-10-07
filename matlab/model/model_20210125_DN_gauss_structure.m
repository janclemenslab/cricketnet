stim = NodeStim(inputStim);
% --- AN1 -----------------------------------------------------------------
%     - almost no adaptation and hence weak inh lobe
%     - no strong smoothing/integration - hence rel. short pos. lobe
%     - FIXED MINIMAL DELAY TO 0ms
p.an1_filter = [zeros(round(5+p.an1_filter_delay),1);...
                gausswin(p.an1_filter_exc_dur, p.an1_filter_exc_sigma);...
               -gausswin(p.an1_filter_inh_dur, p.an1_filter_inh_sigma)*p.an1_filter_inh_gain];
% p.an1_filter = [zeros(round(p.an1_filter_delay),1);...
%                 triang(round(p.an1_filter_exc_dur));...
%                -gausswin(p.an1_filter_inh_dur, p.an1_filter_inh_sigma)*p.an1_filter_inh_gain];
% p.an1_filter = [zeros(round(p.an1_filter_delay),1);...
%                 gausswin(p.an1_filter_exc_dur, p.an1_filter_exc_sigma)];

an1_NLparam = [p.an1_nonlinearity_slope, p.an1_nonlinearity_shift, p.an1_nonlinearity_gain, p.an1_nonlinearity_baseline];
p.an1_ln2_nonlinearity = @(x)NL.relu(NL.sigmoidal(x, an1_NLparam));
% p.an1_ln2_nonlinearity = @(x)NL.relu(x);

% an1 = NodeLN(p.an1_filter , @(x)p.an1_ln2_nonlinearity(x));
% an1.input = stim.output;
an1_sub = NodeLN(p.an1_filter, @(x)p.an1_ln2_nonlinearity(x));
an1_sub.input = stim.output;

an1 = NodeDivNorm(kernel.exponential(2000, p.an1_ada_filter_tau),...
                  @(x)NL.relu(x) * p.an1_output_gain,...
                  p.an1_ada_strength);

an1.input = an1_sub.output;


% --- LN2 -----------------------------------------------------------------
% --  FILTER & NONLINEARITY:
%     - stronger adaptation across pulses in a train - hence longer and stronger neg. lobe
%     - no strong smoothing/integration - hence very short pos. lobe
%     - nonlinearity thresholds to get rid of neg. resp. components from neg. filter lobe
POS = gausswin(p.ln2_filter_exc_dur, p.ln2_filter_exc_sigma)*p.ln2_filter_exc_gain;
NEG = -flipud(kernel.exponential(1000,p.ln2_filter_inh_tau)');
ln2 = NodeLN(flipud([NEG; POS(3:end)]), @(x)NL.relu(x)*p.ln2_nonlinearity_gain);

an1_ln2 = NodeSynapse(p.an1_ln2_delay, p.an1_ln2_gain);
an1_ln2.input = an1.output;
ln2.input = an1_ln2.output;
% ln2.input = an1.output;


% --- LN5 -----------------------------------------------------------------
% --  LN2-LN5 SYNAPSE - DELAY
%     - synaptic delay
ln2_ln5 = NodeSynapse(p.ln2_ln5_delay, p.ln2_ln5_gain);
ln2_ln5.input = ln2.output;

% --  LN5 INPUT strong adaptation via differentiating filter
%     - inh. decreases during long pulses - this reduces PIR for long pulses
p.ln5_ada_filter = diff(gausswin(p.ln5_ada_filter_dur, 3.5));
p.ln5_ada_filter(ceil(p.ln5_ada_filter_dur/2):end) = p.ln5_ada_filter(ceil(p.ln5_ada_filter_dur/2):end)*p.ln5_ada_filter_exc_gain;  
ln5_ada = NodeLN(p.ln5_ada_filter , @(x)limit(x,-inf,0));
ln5_ada.input = ln2_ln5.output;

% --  FILTER:
%     - inverted biphasic filter to produce post-inhibitory rebound
%     - reproduces timing and time coues of rebound
%     - fits resposnes to LONG pause stimuli very well
%     - does not match pause and duration tuning of PIR amplitude
%     - maybe this is fixed with adapatation and long inh lobe that integrates PIR across pulses

% !!!!! REMOVE  p.ln5_filter_inh_gain or p.ln5_filter_exc_gain ? maybe not. !!!!! 
p.ln5_filter = conv([ kernel.exponential(p.ln5_filter_exc_dur, p.ln5_filter_exc_tau)'*p.ln5_filter_exc_gain; ...
                     -kernel.exponential(500, p.ln5_filter_inh_tau)'*p.ln5_filter_inh_gain ...
                    ], gausswin(6));  % !!!!! REMOVE p.ln5_filter_gain !!!!! 
ln5 = NodeLN(p.ln5_filter, @(x)x * p.ln5_nonlinearity_gain);%p.ln5_nonlinearity_gain);
ln5.input = ln5_ada.output;


% --- LN3 -----------------------------------------------------------------
% --  AN1-LN3 synapse
%     - delay is a little long!! <- may just be there to compensate for
%       overall delays introduced by the various filters upstream of LN3
an1_ln3 = NodeSynapse(p.an1_ln3_delay, p.an1_ln3_gain);
an1_ln3.input = ln2.output;

% --  LN5-LN3 synapse
%     - no delay
ln5_ln3 = NodeSynapse(p.ln5_ln3_delay, p.ln5_ln3_gain);
ln5_ln3.input = NL.relu(ln5.output, 0);

% --  SUBTHRESHOLD - coincidence detector
%     - responds only if AN1 is active (to first pulse but not to last
%       rebound
%     - LN5 mainly modulates response
%     - summation - not multiplications, since AN1 is sufficient to elicit spikes

% !!!!! REMOVE   p.ln3_sub_nonlinearity_gain???   !!!!!!!!!!!!!!
ln3_sub = NodeSummate( @(x)NL.relu(x, p.ln3_sub_nonlinearity_thres)*p.ln3_sub_nonlinearity_gain);% smaller subtract adds output offset
% ln3_sub = NodeSummate( @(x)NL.relu(x, p.ln3_sub_nonlinearity_thres));% smaller subtract adds output offset
ln3_sub.input{1} = ln5_ln3.output;
ln3_sub.input{2} = an1_ln3.output;

% --  SPIKING ADAPTATION
%     - adaptation reduces spiking for long chirps
%     - this is not apparent in the subthreshold responses so must be SFA
%     - hence ln3_sub has threshold NL to  mimic driving current on which the divNorm node acts
ln3 = NodeDivNorm(kernel.exponential(1000, p.ln3_ada_filter_tau), @(x)NL.relu(x, p.ln3_nonlinearity_thres)*p.ln3_nonlinearity_gain, p.ln3_ada_strength);
ln3.input = ln3_sub.output;


% --- LN4 -----------------------------------------------------------------
% --  LN2-LN4 synapse
ln2_ln4 = NodeSynapse(p.ln2_ln4_delay, p.ln2_ln4_gain);
ln2_ln4.input = ln2.output;

% --  LN3-LN4 synapse
ln3_ln4 = NodeSynapse(p.ln3_ln4_delay, p.ln3_ln4_gain);
ln3_ln4.input = ln3.output;


% --  LN4 is feature detector
ln4 = NodeSummate( @(x)NL.relu(x, p.ln4_nonlinearity_thres)*p.ln4_nonlinearity_gain );
ln4.input{1} = ln3_ln4.output;
ln4.input{2} = ln2_ln4.output;
