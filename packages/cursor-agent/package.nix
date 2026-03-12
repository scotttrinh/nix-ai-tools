{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  autoPatchelfHook,
}:

let
  pname = "cursor-agent";
  version = "2026.03.11-6dfa30c";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/${version}/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-pstWHWv8lCWRGucRB9+KPe8XX4c99VComNDbPzCLxn8=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/${version}/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-EnDPfMcvRDNvtBzO3HIwaPJ7T7GlNQOdOWkrxrpWKoY=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/${version}/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-6duYFdg4P6Y8ic3rnP6+3xBjMJpqW7eurFcC0QopChU=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/${version}/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-CQqdvBPZkJkfVGzt5KaD1dogzKyeIN00A0jk90WHUY8=";
    };
  };

  src =
    srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation rec {
  inherit pname version src;

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    stdenv.cc.cc.lib
  ];

  unpackPhase = ''
    runHook preUnpack
    tar -xzf $src
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    # Copy the dist-package contents
    mkdir -p $out
    cp -r dist-package/* $out/

    # Ensure binaries are executable
    chmod +x $out/cursor-agent
    chmod +x $out/node
    chmod +x $out/rg

    # Create a wrapper in bin directory
    mkdir -p $out/bin
    makeWrapper $out/cursor-agent $out/bin/cursor-agent \
      --prefix PATH : $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "Cursor Agent - CLI tool for Cursor AI code editor";
    homepage = "https://cursor.com/";
    license = licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "cursor-agent";
  };
}
