{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  rustPlatform,
  pkg-config,
  openssl,
  versionCheckHook,
  installShellCompletions ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "codex";
  version = "0.101.0";

  src = fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    tag = "rust-v${finalAttrs.version}";
    hash = "sha256-m2Jq7fbSXQ/O3bNBr6zbnQERhk2FZXb+AlGZsHn8GuQ=";
  };

  sourceRoot = "${finalAttrs.src.name}/codex-rs";

  cargoHash = "sha256-oOcQv3NFd45WRdn2QtDMxVZwf3KjGWaSDBCjCk0ik/U=";

  cargoBuildFlags = [
    "--package"
    "codex-cli"
  ];

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [ openssl ];

  preBuild = ''
    # Remove LTO to speed up builds
    substituteInPlace Cargo.toml \
      --replace-fail 'lto = "fat"' 'lto = false'
  '';

  doCheck = false;

  postInstall = lib.optionalString installShellCompletions ''
    installShellCompletion --cmd codex \
      --bash <($out/bin/codex completion bash) \
      --fish <($out/bin/codex completion fish) \
      --zsh <($out/bin/codex completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    description = "OpenAI Codex CLI - a coding agent that runs locally on your computer";
    homepage = "https://github.com/openai/codex";
    changelog = "https://github.com/openai/codex/releases/tag/rust-v${finalAttrs.version}";
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    license = lib.licenses.asl20;
    mainProgram = "codex";
    platforms = lib.platforms.unix;
  };
})
