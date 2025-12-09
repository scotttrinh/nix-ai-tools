{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  autoPatchelfHook,
  gcc-unwrapped,
}:

let
  inherit (stdenv.hostPlatform) system;

  sources = {
    x86_64-linux = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.10.0/forge-x86_64-unknown-linux-gnu";
      hash = "sha256-ePFLUlmsiPoedZQbYZSatWxLawMnfQ5S0nF531lUtss=";
    };
    aarch64-linux = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.10.0/forge-aarch64-unknown-linux-gnu";
      hash = "sha256-BgGzNnXe62z+UhYNFbbhfZfrYpRLfgf7b9gcWt4dlGM=";
    };
    x86_64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.10.0/forge-x86_64-apple-darwin";
      hash = "sha256-xJ5PLmhlp3JasW+NFt1o+rR+kRgqagBbi0F8qO9eeFU=";
    };
    aarch64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.10.0/forge-aarch64-apple-darwin";
      hash = "sha256-UYKPBhcxp6SNStUyyWBJ5c7FRacOoxyk6rmKJq3TB5c=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "forge";
  version = "1.10.0";

  src = fetchurl sources.${system};

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    gcc-unwrapped.lib
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 $src $out/bin/forge

    runHook postInstall
  '';

  meta = with lib; {
    description = "AI-Enhanced Terminal Development Environment - A comprehensive coding agent that integrates AI capabilities with your development environment";
    homepage = "https://github.com/antinomyhq/forge";
    changelog = "https://github.com/antinomyhq/forge/releases/tag/v${version}";
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ ];
    mainProgram = "forge";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
