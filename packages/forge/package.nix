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
      url = "https://github.com/antinomyhq/forge/releases/download/v1.14.0/forge-x86_64-unknown-linux-gnu";
      hash = "sha256-U7VlpSDZOEFp1BpEmzZro35DvYnbWChThiOGAuY89oI=";
    };
    aarch64-linux = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.14.0/forge-aarch64-unknown-linux-gnu";
      hash = "sha256-eoh6RDouEa2D1cHE75jQj7J/j03IgTEroJHM/ipUAy8=";
    };
    x86_64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.14.0/forge-x86_64-apple-darwin";
      hash = "sha256-a5k+5gL1XK+MjWtsUYKHb1sCfUT1t+kXB1K9mdk+FcU=";
    };
    aarch64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.14.0/forge-aarch64-apple-darwin";
      hash = "sha256-oLDm1F+Gh8JN+egrH1Kjaq2p17NW6s2aZQNsfgygg/4=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "forge";
  version = "1.14.0";

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
