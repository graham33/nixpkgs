{ lib
, buildPythonPackage
, fetchurl
, autoPatchelfHook
, libneuronxla
, pytestCheckHook
, pythonOlder
, packaging
, torch
, torch-xla
}:

buildPythonPackage rec {
  pname = "torch-neuronx";
  version = "2.1.1.2.0.0b0";
  format = "wheel";

  disabled = pythonOlder "3.7";

  src = let
    abi = "none";
    platform = "any";
    python = "py3";
    repoUrl = "https://pip.repos.neuron.amazonaws.com";
  in fetchurl {
    url = "${repoUrl}/${pname}/${builtins.replaceStrings ["-"] ["_"] pname}-${version}-${python}-${abi}-${platform}.whl";
    sha256 = "sha256-03vtiV3ZjrgxEUSIIhU3Tf+m0b/xqp4bv8ItWWbuyY4=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  propagatedBuildInputs = [
    libneuronxla
    torch
    torch-xla
  ];

  checkInputs = [
    packaging
  ];

  # Use CPU for tests
  PJRT_DEVICE = "CPU";

  nativeCheckInputs = [
    # So ${libneuronxla}/bin is on PATH for libneuronpjrt-path
    libneuronxla
  ];

  pythonImportsCheck = [
    "torch_neuronx"
  ];

  meta = with lib; {
    description = "AWS Neuron is the SDK used to run deep learning workloads on AWS Inferentia and AWS Trainium based instances";
    homepage = "https://awsdocs-neuron.readthedocs-hosted.com";
    license = licenses.unfree;
    maintainers = [ maintainers.graham33 ];
  };
}
