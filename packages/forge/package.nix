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
      url = "https://github.com/antinomyhq/forge/releases/download/v1.18.0/forge-x86_64-unknown-linux-gnu";
      hash = "sha256-RZR+xCU5ZoajV2pljG3JAXkiX2IsENUZYEvjuvGtk3Y=";
    };
    aarch64-linux = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.18.0/forge-aarch64-unknown-linux-gnu";
      hash = "sha256-xIqTzdtoR6A/iyqidjWCwGZa5+XWl+O2m0uCjyWz3zI=";
    };
    x86_64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.18.0/forge-x86_64-apple-darwin";
      hash = "sha256-V/Yi9zhW6yk9pUoOMEzd5v3L+M7R72XXInPUH8cZaXA=";
    };
    aarch64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.18.0/forge-aarch64-apple-darwin";
      hash = "sha256-GyqhYNXPvKOe8LQPGNWMkzm6ZHg9BvhuQ1UF3uEKU2c=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "forge";
  version = "1.18.0";

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
