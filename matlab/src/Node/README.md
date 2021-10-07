# Network models
- everything implements `Node`
  - 'lazy' evaluation - `Node.output` is calculated on demand and only updated when inputs or the node's parameters change
  - each implementation defines a `Node.transform` function that returns (and sets) `Node.output` from `Node.input`
  - everything is vectorized such that inputs are T x Nstim
- `NodeSynapse`: for now delays and weights it's input
- `NodeLN`: filter and NL (see `+NL` for a bunch of pre-defined nonlinearities)
- `NodeMultiply`, `NodeSummate`: Nodes combine multiple inputs. Inputs are cell arrays `NodeCorrelate.input{1}*NodeCorrelate.input{2}`
- `NodeStim`: exists mainly for consistence (e.g to use `Node.plot()`)
- `+NL` contains standard nonlinearities

# TODO
- define spiking nodes: `NodePoisson`, `NodeLIF`, ...
- define `Network` as a container that organizes and standardizes connectivity and takes care of fitting, timestamps etc?
- define `Transform` classes instead of implementing them the IO function as an abstract function?
- define `+filters` to implement standard filter forms as for `+NL`?
