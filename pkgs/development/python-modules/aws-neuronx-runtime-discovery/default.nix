{ lib
, buildPythonPackage
, fetchurl
, aws-neuronx-runtime-lib
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aws-neuronx-runtime-discovery";
  version = "2.9";

  disabled = pythonOlder "3.7";

  src = fetchurl {
    url = "https://pip.repos.neuron.amazonaws.com/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-JOCwnaK6NskD0856JqIStAE9Hp1pw/XqzRUmlkk35jA=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "libnrt_installation_path = '/opt/aws/neuron/lib'" "libnrt_installation_path = '${aws-neuronx-runtime-lib}/lib'"
  '';

  propagatedBuildInputs = [
    aws-neuronx-runtime-lib
  ];

  pythonImportsCheck = [
    "aws_neuronx_runtime_discovery.version"
  ];

  meta = with lib; {
    description = "aws-neuronx-runtime-discovery";
    homepage = "https://awsdocs-neuron.readthedocs-hosted.com";
    license = licenses.unfree;
    maintainers = [ maintainers.graham33 ];
  };
}
