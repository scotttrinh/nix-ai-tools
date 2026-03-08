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
      url = "https://github.com/antinomyhq/forge/releases/download/v1.31.2/forge-x86_64-unknown-linux-gnu";
      hash = "sha256-ac6m5oyc5bB+QRcqxzSMBV7EnusHFtsjhKWaWxM2rSY=";
    };
    aarch64-linux = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.31.2/forge-aarch64-unknown-linux-gnu";
      hash = "sha256-KnvSRdfHTd9p5TZvTiyR55LY2TRA3w9Noc+SpmhEQLA=";
    };
    x86_64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.31.2/forge-x86_64-apple-darwin";
      hash = "sha256-MzwZROEpGVlJ3a9V/GukXU+uCopJKJ30zPL5NnwrLOg=";
    };
    aarch64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.31.2/forge-aarch64-apple-darwin";
      hash = "sha256-vxL9YX9boZyeGms7GNw3QK28T3/17Y3pP/wl3rXxNHE=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "forge";
  version = "1.31.2";

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
