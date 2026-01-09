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
      url = "https://github.com/antinomyhq/forge/releases/download/v1.17.0/forge-x86_64-unknown-linux-gnu";
      hash = "sha256-HQSCNSol1SsmXZJugbm5WW64CpvWRivWHx52G3dsMw0=";
    };
    aarch64-linux = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.17.0/forge-aarch64-unknown-linux-gnu";
      hash = "sha256-6gYmq1TIUuPIgsG0M3pwAe1buq0/ulvdHJ0aL8RTprE=";
    };
    x86_64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.17.0/forge-x86_64-apple-darwin";
      hash = "sha256-T8c7Wp5FoUOPv5K6MCqf0jHWhL2O79CKno2Pm8eLDMM=";
    };
    aarch64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.17.0/forge-aarch64-apple-darwin";
      hash = "sha256-LLFCCHaMAujafLeh4xIMTa9SZyJfkhOFPPEWqVCSO+A=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "forge";
  version = "1.17.0";

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
