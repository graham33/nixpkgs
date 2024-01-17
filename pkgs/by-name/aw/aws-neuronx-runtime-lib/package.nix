{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, dpkg
}:

stdenv.mkDerivation rec {
  pname = "aws-neuronx-runtime-lib";
  version = "2.19.5.0";
  version-suffix = "97e2d271b";

  # See https://apt.repos.neuron.amazonaws.com/dists/jammy/main/binary-amd64/Packages
  src = fetchurl {
    url = "https://apt.repos.neuron.amazonaws.com/pool/main/a/aws-neuronx-runtime-lib/aws-neuronx-runtime-lib_${version}-${version-suffix}_amd64.deb";
    hash = "sha256-FHpTXGlN1v3IwrONmycgNALWjfcGklDo7xt2MGbYfXE=";
  };

  unpackCmd = ''
    mkdir -p root
    dpkg-deb -x $curSrc root
  '';

  nativeBuildInputs  = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    # For autoPatchelfHook
    stdenv.cc.cc.lib
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r opt/aws/neuron/include $out/
    cp -r opt/aws/neuron/lib $out/
    cp -r usr/share $out/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Neuron Runtime consists of a kernel mode driver and C/C++ libraries which provides APIs to access Neuron Devices";
    homepage = "https://awsdocs-neuron.readthedocs-hosted.com/en/latest/release-notes/runtime/aws-neuronx-runtime-lib/index.html";
    license = licenses.unfree;
    maintainers = [ maintainers.graham33 ];
  };
}
