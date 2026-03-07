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
      url = "https://github.com/antinomyhq/forge/releases/download/v1.31.1/forge-x86_64-unknown-linux-gnu";
      hash = "sha256-Eyl1GdlkqTqVgD6bEGouWVkJLYyykgKs+PoO50fmh1U=";
    };
    aarch64-linux = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.31.1/forge-aarch64-unknown-linux-gnu";
      hash = "sha256-59bpB1tsw3CE193Ish8MoiiK49Frj7HHHo1X+4k6IWk=";
    };
    x86_64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.31.1/forge-x86_64-apple-darwin";
      hash = "sha256-LspCRY9BYxV43T67cSc8VOWkaKPv1aWHhrxFypOcC8w=";
    };
    aarch64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.31.1/forge-aarch64-apple-darwin";
      hash = "sha256-YfP7k5Dr67rJoBHHYnNaXaL0BQN2+H7ezLmUKg6I/fI=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "forge";
  version = "1.31.1";

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
