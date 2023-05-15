{ stdenv
, lib
, cmake
, fetchFromGitHub
, gbenchmark
, gtest
}:
let
in
stdenv.mkDerivation rec {
  pname = "cpuinfo";
  version = "unknown";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "cpuinfo";
    rev = "3dc310302210c1891ffcfb12ae67b11a3ad3a150";
    sha256 = "sha256-HfkPQI9T7n3R1PzmZKUgpOVFe9dUMTZ+xxwY69EwHmo=";
  };

  patches = [
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
  ];

  # TODO: any way to avoid vendored gmock/gtest?
  cmakeFlags = [
    "-DGOOGLEBENCHMARK_SOURCE_DIR=${gbenchmark.src}"
    "-DGOOGLETEST_SOURCE_DIR=${gtest.src}"
  ];

  meta = with lib; {
    description = "A library to detect essential for performance optimization information about host CPU.";
    homepage = "https://github.com/pytorch/cpuinfo";
    license = licenses.bsd2;
    maintainers = with maintainers; [ graham33 ];
  };
}
