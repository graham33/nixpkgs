{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
  httpx,
  cryptography,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "libdyson-rest";
  version = "0.12.1";
  pyproject = true;

  src = fetchPypi {
    pname = "libdyson_rest";
    inherit version;
    hash = "sha256-JDiTClRpT+c3+UqvSUdHE6mhyNaR7xg6t5P0JemPh3U=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    requests
    httpx
    cryptography
    typing-extensions
  ];

  pythonImportsCheck = [
    "libdyson_rest"
  ];

  # Tests require actual Dyson account
  doCheck = false;

  meta = {
    description = "Python library for interacting with Dyson devices through their official REST API";
    homepage = "https://github.com/cmgrayb/libdyson-rest";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ graham33 ];
  };
}
