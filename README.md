# dell-r710-fan-control-nix

This flake packages the [r710-fan-controller](https://github.com/nmaggioni/r710-fan-controller).
The configuration file for the controller should be put under `/etc/fan_control.yaml`.
This flake doesn't provide configuration options as secrets have to be put into this yaml file.
