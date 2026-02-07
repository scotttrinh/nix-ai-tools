{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  autoPatchelfHook,
  gcc-unwrapped,
}:

let
  version = "0.57.8";

  # Map platforms to Factory AI download URLs
  sources = {
    x86_64-linux = {
      url = "https://downloads.factory.ai/factory-cli/releases/${version}/linux/x64/droid";
      hash = "sha256-1bmsR2zAgIwseTJegE4cOngPV52XE2ZzHp6RC7YQZAY=";
    };
    aarch64-linux = {
      url = "https://downloads.factory.ai/factory-cli/releases/${version}/linux/arm64/droid";
      hash = "sha256-2E49zNvZyvUZDmMwUerWRmUPTsPR/gx++X695Jy7bsE=";
    };
    aarch64-darwin = {
      url = "https://downloads.factory.ai/factory-cli/releases/${version}/darwin/arm64/droid";
      hash = "sha256-hxN8ym8VkChQyiWwFucpA13oIo+gOr2Yl5O3ecpQEIE=";
    };
  };

  # Ripgrep is bundled with droid for code search functionality
  rgSources = {
    x86_64-linux = {
      url = "https://downloads.factory.ai/ripgrep/linux/x64/rg";
      hash = "sha256-viR2yXY0K5IWYRtKhMG8LsZIjsXHkeoBmhMnJ2RO8Zw=";
    };
    aarch64-linux = {
      url = "https://downloads.factory.ai/ripgrep/linux/arm64/rg";
      hash = "sha256-Js5szrF6xxDuclPEnqglxhjU+eSaE11StO3OM2xA9iA=";
    };
    aarch64-darwin = {
      url = "https://downloads.factory.ai/ripgrep/darwin/arm64/rg";
      hash = "sha256-Jz6MZQpCvuwShJEOGCW2Gj5698DOH87BN/4dbMcd77c=";
    };
  };

  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  rgSource =
    rgSources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "droid";
  inherit version;

  src = fetchurl {
    inherit (source) url hash;
  };

  rgSrc = fetchurl {
    inherit (rgSource) url hash;
  };

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
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/lib/factory

    # Install the main droid binary
    install -Dm755 $src $out/bin/droid

    # Install ripgrep for code search functionality
    install -Dm755 $rgSrc $out/lib/factory/rg

    # Wrap droid to ensure ripgrep is in PATH
    wrapProgram $out/bin/droid \
      --prefix PATH : $out/lib/factory

    runHook postInstall
  '';

  passthru = {
    inherit sources rgSources;
  };

  meta = with lib; {
    description = "Factory AI's Droid - AI-powered development agent for your terminal";
    homepage = "https://factory.ai";
    downloadPage = "https://factory.ai/product/ide";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ ];
    mainProgram = "droid";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
