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
      url = "https://github.com/antinomyhq/forge/releases/download/v1.20.0/forge-x86_64-unknown-linux-gnu";
      hash = "sha256-xuG7QM0JnDpgwtU5XYozW1x1JqS6nMGYcbT1mKEdhbI=";
    };
    aarch64-linux = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.20.0/forge-aarch64-unknown-linux-gnu";
      hash = "sha256-M1QyDqhJgfrLxxq5qj+FZ5FRVw1X087J3Mhq6+iHzzY=";
    };
    x86_64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.20.0/forge-x86_64-apple-darwin";
      hash = "sha256-5a2dNrf81C5QoYP3I4/hJWhcOfpVFn5F5egvsfbuPA0=";
    };
    aarch64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.20.0/forge-aarch64-apple-darwin";
      hash = "sha256-ERnTP2Gp5GUAwJ+1iq2s3Foon+G4mQ8vZ57x59Ear4U=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "forge";
  version = "1.20.0";

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
