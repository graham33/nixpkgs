{ lib
, buildPythonPackage
, fetchurl
, aws-neuronx-runtime-discovery
, neuronx-cc
, pytestCheckHook
, pythonOlder
, aws-neuronx-runtime-lib
, boto3
}:

buildPythonPackage rec {
  pname = "libneuronxla";
  version = "2.0.498";
  format = "wheel";

  disabled = pythonOlder "3.7";

  src = let
    abi = "none";
    platform = "linux_x86_64";
    python = "py3";
    repoUrl = "https://pip.repos.neuron.amazonaws.com";
  in fetchurl {
    url = "${repoUrl}/${pname}/${pname}-${version}-${python}-${abi}-${platform}.whl";
    sha256 = "sha256-Q1Bsq+zWRXNeD4UnRelRHk8cq7lyO3OYqqLmiAIZxUk=";
  };

  propagatedBuildInputs = [
    aws-neuronx-runtime-discovery
    boto3
    neuronx-cc
  ];

  postInstall = ''
    find $out/lib -name "*.py" -print0 | xargs -0 sed -i "s|/opt/aws/neuron|${aws-neuronx-runtime-lib}|g"
  '';

  pythonImportsCheck = [
    "libneuronxla"
  ];

  meta = with lib; {
    description = "libneuronxla";
    homepage = "https://awsdocs-neuron.readthedocs-hosted.com";
    license = licenses.unfree;
    maintainers = [ maintainers.graham33 ];
  };
}
