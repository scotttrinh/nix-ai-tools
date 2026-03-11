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
      url = "https://github.com/antinomyhq/forge/releases/download/v1.32.0/forge-x86_64-unknown-linux-gnu";
      hash = "sha256-w2H0bawYurJPnZFVUx58CkVKkd9KQpRT7Tr0x7oNPuY=";
    };
    aarch64-linux = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.32.0/forge-aarch64-unknown-linux-gnu";
      hash = "sha256-bufAeyjWsnwc1q204OYaUCXtACdA6u38EmcdfKn7to0=";
    };
    x86_64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.32.0/forge-x86_64-apple-darwin";
      hash = "sha256-pjrhJMsMVLa0i+B9NmFhBUUj+JdSNlRqu3hcahe8sug=";
    };
    aarch64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.32.0/forge-aarch64-apple-darwin";
      hash = "sha256-N0z5JlD0IwSvsmq+Nau8dHYH7Kz9CNlMiUkwu/oLSkw=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "forge";
  version = "1.32.0";

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
