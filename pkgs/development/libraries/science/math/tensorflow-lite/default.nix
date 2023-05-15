{ stdenv
, bash
, abseil-cpp
, cmake
, eigen
, fetchFromGitHub
, fetchFromGitLab
, fetchpatch
, fetchurl
, fetchzip
, flatbuffers
, lib
, zlib
}:
let
  cpuinfo-src = fetchFromGitHub {
    owner = "pytorch";
    repo = "cpuinfo";
    rev = "5e63739504f0f8e18e941bd63b2d6d42536c7d90";
    sha256 = "sha256-5no9LkQIIOIidvhera5lIbnOUkcZQtW4nIUqXSLnWHA=";
  };

  farmhash-src = fetchFromGitHub {
    owner = "google";
    repo = "farmhash";
    rev = "816a4ae622e964763ca0862d9dbd19324a1eaf45";
    sha256 = "sha256-5n58VEUxa/K//jAfZqG4cXyfxrp50ogWDNYcgiXVHdc=";
  };

  fft2d-src = fetchzip {
    url = "https://storage.googleapis.com/mirror.tensorflow.org/github.com/petewarden/OouraFFT/archive/v1.0.tar.gz";
    sha256 = "sha256-mkG6jWuMVzCB433qk2wW/HPA9vp/LivPTDa2c0hFir4=";
  };

  gemmlowp-src = fetchFromGitHub {
    owner = "google";
    repo = "gemmlowp";
    rev = "fda83bdc38b118cc6b56753bd540caa49e570745";
    sha256 = "sha256-tE+w72sfudZXWyMxG6CGMqXYswve57/cpvwrketEd+k=";
  };

  neon2sse-src = fetchzip {
    url = "https://storage.googleapis.com/mirror.tensorflow.org/github.com/intel/ARM_NEON_2_x86_SSE/archive/a15b489e1222b2087007546b4912e21293ea86ff.tar.gz";
    sha256 = "sha256-299ZptvdTmCnIuVVBkrpf5ZTxKPwgcGUob81tEI91F0=";
  };

  psimd-src = fetchFromGitHub {
    owner = "Maratyszcza";
    repo = "psimd";
    rev = "072586a71b55b7f8c584153d223e95687148a900";
    sha256 = "sha256-lV+VZi2b4SQlRYrhKx9Dxc6HlDEFz3newvcBjTekupo=";
  };

  ruy-src = fetchFromGitHub {
    owner = "google";
    repo = "ruy";
    rev = "841ea4172ba904fe3536789497f9565f2ef64129";
    sha256 = "sha256-KtduRl9HUxUhNdgm+M8nU55zwbt1P+QRRLoePFRwh9g=";
  };

  # https://github.com/tensorflow/tensorflow/issues/57658
in
stdenv.mkDerivation rec {
  pname = "tensorflow-lite";
  version = "2.11.1";

  src = fetchFromGitHub {
    owner = "tensorflow";
    repo = "tensorflow";
    rev = "v${version}";
    sha256 = "sha256-q59cUW6613byHk4LGl+sefO5czLSWxOrSyLbJ1pkNEY=";
  };

  preConfigure = ''
    cd tensorflow/lite
  '';

  patches = [
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [ zlib flatbuffers ];

  cmakeFlags = [
    "-DTFLITE_ENABLE_INSTALL=ON"
    "-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON"
    "-Dabsl_DIR=${abseil-cpp}/lib/cmake/absl"
    "-DEigen3_DIR=${eigen}/share/eigen3/cmake"
    "-DFlatbuffers_DIR=${flatbuffers}/lib/cmake/flatbuffers"
    "-DFETCHCONTENT_SOURCE_DIR_CPUINFO=${cpuinfo-src}"
    "-DFETCHCONTENT_SOURCE_DIR_FARMHASH=${farmhash-src}"
    "-DFETCHCONTENT_SOURCE_DIR_FFT2D=${fft2d-src}"
    "-DFETCHCONTENT_SOURCE_DIR_FP16_HEADERS=${fp16_headers-src}"
    "-DFETCHCONTENT_SOURCE_DIR_GEMMLOWP=${gemmlowp-src}"
    "-DFETCHCONTENT_SOURCE_DIR_NEON2SSE=${neon2sse-src}"
    "-DFETCHCONTENT_SOURCE_DIR_RUY=${ruy-src}"
    "-DCLOG_SOURCE_DIR=${cpuinfo-src}/deps/clog"
    "-DPTHREADPOOL_SOURCE_DIR=${pthreadpool-src}"
    "-DPSIMD_SOURCE_DIR=${psimd-src}"
  ];

  #dontConfigure = true;

  # postPatch = ''
  #   substituteInPlace ./tensorflow/lite/tools/make/Makefile \
  #     --replace /bin/bash ${bash}/bin/bash \
  #     --replace /bin/sh ${bash}/bin/sh
  # '';

  #makefile = "tensorflow/lite/tools/make/Makefile";

  meta = with lib; {
    description = "An open source deep learning framework for on-device inference.";
    homepage = "https://www.tensorflow.org/lite";
    license = licenses.asl20;
    maintainers = with maintainers; [ cpcloud ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
