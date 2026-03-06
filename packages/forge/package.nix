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
      url = "https://github.com/antinomyhq/forge/releases/download/v1.31.0/forge-x86_64-unknown-linux-gnu";
      hash = "sha256-TkSm5nPnL4HL0TbKHmS1Dg5YqF6LL2uE+2FQJbzn5oQ=";
    };
    aarch64-linux = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.31.0/forge-aarch64-unknown-linux-gnu";
      hash = "sha256-XMIEUGNe1av7zomFGKWhrcKWBfL2JMOLo6WrP9IDHEc=";
    };
    x86_64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.31.0/forge-x86_64-apple-darwin";
      hash = "sha256-3ayfzxg9Rz1MlmwDE7kCNwNHaQ+riL+rmjoWPbPeQXQ=";
    };
    aarch64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.31.0/forge-aarch64-apple-darwin";
      hash = "sha256-jM5TkXRjbYU+IGJfgqLq48F+H/P8zcysU/Uja5kMQxs=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "forge";
  version = "1.31.0";

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
