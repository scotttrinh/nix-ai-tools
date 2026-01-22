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
      url = "https://github.com/antinomyhq/forge/releases/download/v1.19.0/forge-x86_64-unknown-linux-gnu";
      hash = "sha256-yxD4j2RITpD5wZGYEJu2IH+7Ywc6prYZ8Muk3jcRoZs=";
    };
    aarch64-linux = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.19.0/forge-aarch64-unknown-linux-gnu";
      hash = "sha256-XOx9O4vUKlvjPY6ynykcrxGfeol1Rwp7fmK7EuaKEbA=";
    };
    x86_64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.19.0/forge-x86_64-apple-darwin";
      hash = "sha256-lw+OGEK9ZzoW6TJ8/j9Md4sjIS9pV9iIu56y6cGaCnI=";
    };
    aarch64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.19.0/forge-aarch64-apple-darwin";
      hash = "sha256-Xzyz2S6bEVIQhBU7y1VqgtpnzCrRuTcjSm2s4BsvYRk=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "forge";
  version = "1.19.0";

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
