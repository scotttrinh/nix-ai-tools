{ pkgs }:

let
  version = "0.87.1";

  # Function to create native binary derivation for each platform
  mkNativeBinary =
    {
      system,
      url,
      hash,
    }:
    pkgs.stdenv.mkDerivation rec {
      pname = "eca";
      inherit version;

      src = pkgs.fetchzip {
        inherit url hash;
        stripRoot = false;
      };

      dontUnpack = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall
        mkdir -p $out/bin
        cp $src/eca $out/bin/eca
        chmod +x $out/bin/eca
        runHook postInstall
      '';

      meta = with pkgs.lib; {
        description = "Editor Code Assistant (ECA) - AI pair programming capabilities agnostic of editor";
        homepage = "https://github.com/editor-code-assistant/eca";
        license = licenses.asl20;
        maintainers = with maintainers; [ jojo ];
        mainProgram = "eca";
        platforms = [ system ];
      };
    };

in
# Use native binary for all supported platforms
if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then
  mkNativeBinary {
    system = "x86_64-linux";
    url = "https://github.com/editor-code-assistant/eca/releases/download/${version}/eca-native-linux-amd64.zip";
    hash = "sha256-DA5ZjgfkhPHqpcQWydouREksGTJje6N0jXq82vII2k8=";
  }
else if pkgs.stdenv.hostPlatform.system == "aarch64-linux" then
  mkNativeBinary {
    system = "aarch64-linux";
    url = "https://github.com/editor-code-assistant/eca/releases/download/${version}/eca-native-linux-aarch64.zip";
    hash = "sha256-MQf7Khe0hWux9GD+cJi3iQdlewv+w8ha1jimtbtPzG4=";
  }
else if pkgs.stdenv.hostPlatform.system == "x86_64-darwin" then
  mkNativeBinary {
    system = "x86_64-darwin";
    url = "https://github.com/editor-code-assistant/eca/releases/download/${version}/eca-native-macos-amd64.zip";
    hash = "sha256-IDJEB1pgnro87G9x42xQdzXM/9TwCxgdGUq8/GkX+aE=";
  }
else if pkgs.stdenv.hostPlatform.system == "aarch64-darwin" then
  mkNativeBinary {
    system = "aarch64-darwin";
    url = "https://github.com/editor-code-assistant/eca/releases/download/${version}/eca-native-macos-aarch64.zip";
    hash = "sha256-4loSY0n7PC2NCRQoX7G52PNCJ6PRXySvMTaTqUXQHL8=";
  }
else
  # Fallback to JAR version for unsupported platforms
  pkgs.stdenv.mkDerivation rec {
    pname = "eca";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://github.com/editor-code-assistant/eca/releases/download/${version}/eca.jar";
      hash = "sha256-10m85fdmzf2dcfphxcwr3cr985g3wswsm7gvylh30fwr4q2w7g56";
    };

    nativeBuildInputs = [
      pkgs.makeWrapper
    ];

    buildInputs = [
      pkgs.jre
    ];

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      mkdir -p $out/lib
      cp $src $out/lib/eca.jar

      cat > $out/bin/eca << EOF
      #!${pkgs.stdenv.shell}
      export JAVA_HOME="${pkgs.jre}"
      export PATH="${pkgs.jre}/bin:\$PATH"
      exec "${pkgs.jre}/bin/java" -jar "$out/lib/eca.jar" "\$@"
      EOF

      chmod +x $out/bin/eca
      runHook postInstall
    '';

    meta = with pkgs.lib; {
      description = "Editor Code Assistant (ECA) - AI pair programming capabilities agnostic of editor";
      homepage = "https://github.com/editor-code-assistant/eca";
      license = licenses.asl20;
      maintainers = with maintainers; [ jojo ];
      mainProgram = "eca";
    };
  }
