{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  paho-mqtt,
  cryptography,
  requests,
  zeroconf,
  attrs,
}:

buildPythonPackage rec {
  pname = "libdyson-neon";
  version = "1.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-V9U1FQRz3IzavRMejwo06E1sJ0/AhgUxWTP0bt/brSA=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    paho-mqtt
    cryptography
    requests
    zeroconf
    attrs
  ];

  pythonImportsCheck = [
    "libdyson"
  ];

  # Tests require actual Dyson devices
  doCheck = false;

  meta = {
    description = "A Python library for Dyson devices";
    homepage = "https://github.com/libdyson-wg/libdyson-neon";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ graham33 ];
  };
}
