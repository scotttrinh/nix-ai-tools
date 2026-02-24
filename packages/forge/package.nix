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
      url = "https://github.com/antinomyhq/forge/releases/download/v1.29.1/forge-x86_64-unknown-linux-gnu";
      hash = "sha256-WVd8Rpv/vTqiOTQ1GwQmxUjxeBm77HjKppISSflUvJU=";
    };
    aarch64-linux = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.29.1/forge-aarch64-unknown-linux-gnu";
      hash = "sha256-NNRHT51T9x3uO0ebWHPKyBOdQKBoXu/s7guM7FBp7yQ=";
    };
    x86_64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.29.1/forge-x86_64-apple-darwin";
      hash = "sha256-DkYhWlbxuQgBzIYepKo9rOb3YDwyDnY/UyNtD9EJDMk=";
    };
    aarch64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.29.1/forge-aarch64-apple-darwin";
      hash = "sha256-XQTPwmCGFUF75ymmjHNzD6bUM2GD3voGbd+RdA7aYo0=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "forge";
  version = "1.29.1";

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
