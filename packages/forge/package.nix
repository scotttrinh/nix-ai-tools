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
      url = "https://github.com/antinomyhq/forge/releases/download/v1.28.0/forge-x86_64-unknown-linux-gnu";
      hash = "sha256-POiBAWbpIwYfoYLUU7myIk8Ta/4BdPllH4SVqtElCrs=";
    };
    aarch64-linux = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.28.0/forge-aarch64-unknown-linux-gnu";
      hash = "sha256-0fV8h2yDpYVPHtBPOL0WR2932YobDraYicH9dT2Dakk=";
    };
    x86_64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.28.0/forge-x86_64-apple-darwin";
      hash = "sha256-Yfpr9GOtFovd1TikDgSLT35E1WCcBp3lr1QVOax73BM=";
    };
    aarch64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.28.0/forge-aarch64-apple-darwin";
      hash = "sha256-vINjXcCfayUlmDJCwz1LuCY4tLaArfi5BOHkqWlxBqw=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "forge";
  version = "1.28.0";

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
