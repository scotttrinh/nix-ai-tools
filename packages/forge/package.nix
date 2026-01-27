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
      url = "https://github.com/antinomyhq/forge/releases/download/v1.22.0/forge-x86_64-unknown-linux-gnu";
      hash = "sha256-gcoHmXgV7a1wivzX4ezfiBRdLNEr2da3W8TFHOOkrEk=";
    };
    aarch64-linux = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.22.0/forge-aarch64-unknown-linux-gnu";
      hash = "sha256-6e8DRXMLHxtvol+i+k7qEQxmqUiUQV5S2Aql2I5ai5A=";
    };
    x86_64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.22.0/forge-x86_64-apple-darwin";
      hash = "sha256-AG3egA95mdi+NeE4cIQb3UoJQ/LnZU0z3ekY50AmkHQ=";
    };
    aarch64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.22.0/forge-aarch64-apple-darwin";
      hash = "sha256-nPG+ZuB8BWqlRjd6q3jITDZH8nkkVEUyVG2CVMvd6uA=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "forge";
  version = "1.22.0";

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
