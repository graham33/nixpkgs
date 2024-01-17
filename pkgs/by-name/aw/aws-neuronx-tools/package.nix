{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, dpkg
, aws-neuronx-runtime-lib
}:

stdenv.mkDerivation rec {
  pname = "aws-neuronx-tools";
  version = "2.16.1.0";

  # See https://apt.repos.neuron.amazonaws.com/dists/jammy/main/binary-amd64/Packages
  src = fetchurl {
    url = "https://apt.repos.neuron.amazonaws.com/pool/main/a/aws-neuronx-tools/aws-neuronx-tools_2.16.1.0_amd64.deb";
    hash = "sha256-1iU/vU2ZqydgekIHjq7VW2E1aZUSbNkKLFmQJuIt3tA=";
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
    # For autoPatchelfHook
    stdenv.cc.cc.lib
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r opt/aws/neuron/bin $out/
    cp -r opt/aws/neuron/lib $out/
    cp -r usr/share $out/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tools for AWS Neuronx";
    homepage = "https://awsdocs-neuron.readthedocs-hosted.com/en/latest/tools/index.html";
    license = licenses.unfree;
    maintainers = [ maintainers.graham33 ];
  };
}
