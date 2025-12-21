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
      url = "https://github.com/antinomyhq/forge/releases/download/v1.13.0/forge-x86_64-unknown-linux-gnu";
      hash = "sha256-E3sCmypoDfEps9HYOSJXPF7NrbcIQHpZfxe2xA86JQ0=";
    };
    aarch64-linux = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.13.0/forge-aarch64-unknown-linux-gnu";
      hash = "sha256-4sYFOx30+OI/Mfzjx8vqjXP1u68axovVm+lhSS/aK00=";
    };
    x86_64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.13.0/forge-x86_64-apple-darwin";
      hash = "sha256-xv91y0Xv++Aoib4M6tgfnuo02P0BKwnGVhQ0u+x3M9Y=";
    };
    aarch64-darwin = {
      url = "https://github.com/antinomyhq/forge/releases/download/v1.13.0/forge-aarch64-apple-darwin";
      hash = "sha256-QfJ0JhVZ/pWJS5Zy2APkO5izvAb6Vy8PXY9/tA2lnks=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "forge";
  version = "1.13.0";

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
