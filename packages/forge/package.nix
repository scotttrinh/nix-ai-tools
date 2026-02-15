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
      url = "https://github.com/antinomyhq/forge/releases/download/v1.27.0/forge-x86_64-unknown-linux-gnu";
      hash = "sha256-XhcJKOoBDidWy36L3JKrGgHYmU/GEPc5mnjh8YYs/ds=";
    };
    aarch64-linux = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.27.0/forge-aarch64-unknown-linux-gnu";
      hash = "sha256-Xvn+jjfk4DSZW5Jmj2bCNBuU8WbnTv0T4LIWFf0YH9E=";
    };
    x86_64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.27.0/forge-x86_64-apple-darwin";
      hash = "sha256-d4zIJEQVm3QboIcCIzp3k6T3Rrs5JD7+pEH7PQE223Q=";
    };
    aarch64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.27.0/forge-aarch64-apple-darwin";
      hash = "sha256-T3WTGNLcGaMCs1c2yxLYr3oDjI5AvF6tAYyGIePRJ8Y=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "forge";
  version = "1.27.0";

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
