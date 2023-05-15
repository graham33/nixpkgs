{ stdenv
, lib
, cmake
, fetchFromGitHub
, fetchurl
, fetchzip
, cpuinfo
, gbenchmark
, gtest
}:
let
  pthreadpool-src = fetchzip {
    url = "https://github.com/Maratyszcza/pthreadpool/archive/43edadc654d6283b4b6e45ba09a853181ae8e850.zip";
    sha256 = "sha256-4SZHLW92DvNVLozonK60HQwP0xzH9OWYN6eZ2ADlZl8=";
  };

  fp16_headers-src = fetchFromGitHub {
    owner = "Maratyszcza";
    repo = "FP16";
    rev = "0a92994d729ff76a58f692d3028ca1b64b145d91";
    sha256 = "sha256-m2d9bqZoGWzuUPGkd29MsrdscnJRtuIkLIMp3fMmtRY=";
  };

  fxdiv-src = fetchzip {
    url = "https://github.com/Maratyszcza/FXdiv/archive/b408327ac2a15ec3e43352421954f5b1967701d1.zip";
    sha256 = "sha256-BEjscsejYVhRxDAmah5DT3+bglp8G5wUTTYL7+HjWds=";
  };
in
stdenv.mkDerivation rec {
  pname = "xnnpack";
  version = "unknown";

  src = fetchFromGitHub {
    owner = "google";
    repo = "XNNPACK";
    rev = "659147817805d17c7be2d60bd7bbca7e780f9c82";
    sha256 = "sha256-+CqA/erqsg3b4xtBYU1QwDRQeuVjbkUDJuYvwUpQXYo=";
  };

  patches = [
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    cpuinfo
  ];

  cmakeFlags = [
    "-Dcpuinfo_DIR=${cpuinfo}/lib/cmake/absl"
    "-DCPUINFO_SOURCE_DIR=/does-not-exist"
    "-DFP16_SOURCE_DIR=${fp16_headers-src}"
    "-DFXDIV_SOURCE_DIR=${fxdiv-src}"
    "-DPTHREADPOOL_SOURCE_DIR=${pthreadpool-src}"
    "-DGOOGLEBENCHMARK_SOURCE_DIR=${gbenchmark.src}"
    "-DGOOGLETEST_SOURCE_DIR=${gtest.src}"
  ];

  meta = with lib; {
    description = "High-efficiency floating-point neural network inference operators for mobile, server, and Web";
    homepage = "https://github.com/google/XNNPACK";
    license = licenses.bsd3;
    maintainers = with maintainers; [ graham33 ];
  };
}
