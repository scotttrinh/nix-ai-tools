{
  lib,
  stdenv,
  fetchurl,
  unzip,
  autoPatchelfHook,
}:

let
  version = "0.3.6";

  sources = {
    x86_64-linux = {
      url = "https://cli.coderabbit.ai/releases/${version}/coderabbit-linux-x64.zip";
      hash = "sha256-X87wVqXBjaZaPz/ER/ExyV5EqZqE7IudlRF2cOFL04A=";
    };
    aarch64-linux = {
      url = "https://cli.coderabbit.ai/releases/${version}/coderabbit-linux-arm64.zip";
      hash = "sha256-XDmdcQHoEBqq1Z6OGrRa96/oXRNpCnPr4P0pa40wPEo=";
    };
    x86_64-darwin = {
      url = "https://cli.coderabbit.ai/releases/${version}/coderabbit-darwin-x64.zip";
      hash = "sha256-daJTcCypYbZGqQa2Z3BshaeoxrdtMxTJSUXgDbILu/4=";
    };
    aarch64-darwin = {
      url = "https://cli.coderabbit.ai/releases/${version}/coderabbit-darwin-arm64.zip";
      hash = "sha256-s5A/FDmEQ28kGyQniV5entMAdjeLIR+/oC/DiJocw6k=";
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
