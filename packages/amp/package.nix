{
  lib,
  buildNpmPackage,
  fetchurl,
  fetchNpmDeps,
  ripgrep,
  runCommand,
}:

let
  version = "0.0.1772022876-ga1dd2c";
  # First, create a source with package-lock.json included
  srcWithLock = runCommand "amp-src-with-lock" { } ''
    mkdir -p $out
    tar -xzf ${
      fetchurl {
        url = "https://registry.npmjs.org/@sourcegraph/amp/-/amp-0.0.1772022876-ga1dd2c.tgz";
        hash = "sha256-92HT/1oCczWr5jhqKPvlNy/xk3ShX1yAz8yALQ8ayjI=";
      }
    } -C $out --strip-components=1
    cp ${./package-lock.json} $out/package-lock.json
  '';
in
buildNpmPackage rec {
  pname = "amp";
  inherit version;

  src = srcWithLock;

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-QG0tpOq84zxSHD/D0anf86J6zKpZz6QvjE5ay5ntN2c=";
  };

  # The package from npm is already built
  dontNpmBuild = true;

  postInstall = ''
    wrapProgram $out/bin/amp \
      --prefix PATH : ${lib.makeBinPath [ ripgrep ]} \
      --set AMP_SKIP_UPDATE_CHECK 1
  '';

  passthru = {
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "CLI for Amp, an agentic coding tool in research preview from Sourcegraph";
    homepage = "https://ampcode.com/";
    changelog = "https://github.com/sourcegraph/amp/releases";
    license = licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
    mainProgram = "amp";
  };
}
