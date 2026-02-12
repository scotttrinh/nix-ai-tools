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
      url = "https://github.com/antinomyhq/forge/releases/download/v1.26.0/forge-x86_64-unknown-linux-gnu";
      hash = "sha256-8QfaZrJ28zcBrZSOxbF21GGUdB1VoUkZcbhhNJLwaxs=";
    };
    aarch64-linux = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.26.0/forge-aarch64-unknown-linux-gnu";
      hash = "sha256-6ow+CeYw7J7fxFay60h4aV2ObdbYt5vm5wU1i8tBVJM=";
    };
    x86_64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.26.0/forge-x86_64-apple-darwin";
      hash = "sha256-K7SLrTNoEo07o9b8tfjUiN3O0Elsi8BU3oMjAaVFvgE=";
    };
    aarch64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.26.0/forge-aarch64-apple-darwin";
      hash = "sha256-DExbbHBl1Oiw7avJ8Xejec5Xi2XPw+Q/cECMva0XKBs=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "forge";
  version = "1.26.0";

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
