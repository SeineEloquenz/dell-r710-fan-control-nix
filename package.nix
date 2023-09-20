{ lib
, stdenv
, fetchFromGitHub
, python311
, makeWrapper
, ... }:

let

  src = fetchFromGitHub {
    repo = "r710-fan-controller";
    owner = "nmaggioni";
    rev = "d2d2a03e160ff6051de98a69864da55be9ed2645";
    hash = "sha256-zL4axUn74hUav2zYL6USklq4lKIaSQlLJtWGr/GTYeo=";
  };

in stdenv.mkDerivation {

  pname = "dell-fan-control";
  version = "git";

  inherit src;

  propagatedBuildInputs = [
    (python311.withPackages (pythonPackages: with pythonPackages; [
      pysensors
      pyyaml
    ]))
  ];

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 $src/fan_control.py $out/bin/dell-fan-control
    sed -i 's,/opt/fan_control/fan_control.yaml,/etc/fan_control.yaml,' $out/bin/dell-fan-control
  '';

}
