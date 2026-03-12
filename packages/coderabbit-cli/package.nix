{
  lib,
  stdenv,
  fetchurl,
  unzip,
  autoPatchelfHook,
}:

let
  version = "0.3.8";

  sources = {
    x86_64-linux = {
      url = "https://cli.coderabbit.ai/releases/${version}/coderabbit-linux-x64.zip";
      hash = "sha256-NrU661y7NhUNcLHJYIEKsavCO2Rv3Pz+COVVMYn9zec=";
    };
    aarch64-linux = {
      url = "https://cli.coderabbit.ai/releases/${version}/coderabbit-linux-arm64.zip";
      hash = "sha256-Fo5/pe8o5B8PpXGeo6+slTr/+r3pAQDx9ZlvN8V7yTk=";
    };
    x86_64-darwin = {
      url = "https://cli.coderabbit.ai/releases/${version}/coderabbit-darwin-x64.zip";
      hash = "sha256-4bWOErxc6FN508lhiEUyS5ky8lo/Z+HQB4kGwoe55PI=";
    };
    aarch64-darwin = {
      url = "https://cli.coderabbit.ai/releases/${version}/coderabbit-darwin-arm64.zip";
      hash = "sha256-qLFkfq0TN3UtBN05KpUyr8mzsAoYA0jrkeaaInsmax8=";
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
