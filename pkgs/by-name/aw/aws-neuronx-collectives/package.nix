{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, dpkg
, aws-neuronx-runtime-lib
, libfabric
}:

stdenv.mkDerivation rec {
  pname = "aws-neuronx-collectives";
  version = "2.19.7.0";

  # See https://apt.repos.neuron.amazonaws.com/dists/jammy/main/binary-amd64/Packages
  src = fetchurl {
    url = "https://apt.repos.neuron.amazonaws.com/pool/main/a/aws-neuronx-collectives/aws-neuronx-collectives_${version}-530fb3064_amd64.deb";
    hash = "sha256-XUXH7v/3YNq/YeSLrqj/YqTBnIYpqHALTK3VdzD5kiE=";
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
    aws-neuronx-runtime-lib
    libfabric
    # For autoPatchelfHook
    stdenv.cc.cc.lib
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r opt/aws/neuron/lib $out/
    cp -r usr/share $out/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Neuron Collectives refers to a set of libraries used to support collective compute operations within the Neuron SDK";
    homepage = "https://awsdocs-neuron.readthedocs-hosted.com/en/latest/release-notes/runtime/aws-neuronx-collectives/index.html";
    license = licenses.unfree;
    maintainers = [ maintainers.graham33 ];
  };
}
