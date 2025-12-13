{
  lib,
  stdenv,
  fetchurl,
  unzip,
  autoPatchelfHook,
}:

let
  version = "0.3.5";

  sources = {
    x86_64-linux = {
      url = "https://cli.coderabbit.ai/releases/${version}/coderabbit-linux-x64.zip";
      hash = "sha256-2j4wR6QJ36GsnN7yrBgvCWWb6l7DS29v4Sl4T16H7po=";
    };
    aarch64-linux = {
      url = "https://cli.coderabbit.ai/releases/${version}/coderabbit-linux-arm64.zip";
      hash = "sha256-LTrYcu2eYalLOSD+Su8sJ8hwiIQtHshnHWyL2MjvOFU=";
    };
    x86_64-darwin = {
      url = "https://cli.coderabbit.ai/releases/${version}/coderabbit-darwin-x64.zip";
      hash = "sha256-+AgQeptoac3Cg4A3Ssmui2ABqedIubYuB7lRp/B3WZ8=";
    };
    aarch64-darwin = {
      url = "https://cli.coderabbit.ai/releases/${version}/coderabbit-darwin-arm64.zip";
      hash = "sha256-w0PLGaKvsOYlHMWJW48fJUekEXSWdcECambWju8LdIE=";
    };
  };

  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation rec {
  pname = "coderabbit-cli";
  inherit version;

  src = fetchurl {
    inherit (source) url hash;
  };

  nativeBuildInputs = [ unzip ] ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  unpackPhase = ''
    unzip $src
  '';

  dontStrip = true; # to no mess with the bun runtime

  installPhase = ''
    runHook preInstall

    install -Dm755 coderabbit $out/bin/coderabbit
    ln -s $out/bin/coderabbit $out/bin/cr

    runHook postInstall
  '';

  meta = with lib; {
    description = "AI-powered code review CLI tool";
    homepage = "https://coderabbit.ai";
    license = licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "coderabbit";
  };
}
