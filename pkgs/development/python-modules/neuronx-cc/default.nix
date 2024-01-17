{ lib
, buildPythonPackage
, fetchurl
, pythonOlder
}:

buildPythonPackage rec {
  pname = "neuronx-cc";
  version = "2.12.54.0";
  version-suffix= "f631c2365";
  format = "wheel";

  disabled = pythonOlder "3.7";

  src = let
    abi = "cp311";
    platform = "linux_x86_64";
    python = "cp311";
    repoUrl = "https://pip.repos.neuron.amazonaws.com";
  in fetchurl {
    url = "${repoUrl}/${pname}/${builtins.replaceStrings ["-"] ["_"] pname}-${version}%2B${version-suffix}-${python}-${abi}-${platform}.whl";
    sha256 = "sha256-9Vj2SzzDn7LdtJP9koe/x9aVBUCwR+fNbtAEP7kTohw=";
  };

  propagatedBuildInputs = [
  ];

  pythonImportsCheck = [
    "neuronxcc"
  ];

  meta = with lib; {
    description = "The Neuron Compiler accepts Machine Learning models in various formats (TensorFlow, MXNet, PyTorch, XLA HLO) and optimizes them to run on Neuron devices";
    homepage = "https://awsdocs-neuron.readthedocs-hosted.com/en/latest/compiler/index.html";
    license = licenses.unfree;
    maintainers = [ maintainers.graham33 ];
  };
}
