{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  installShellFiles,
}:
buildGo125Module rec {
  pname = "crush";
  version = "0.43.2";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "crush";
    rev = "v${version}";
    hash = "sha256-VyV57ASsn2t1zaW7L6o7sVc+H+tHf4AP1HaKgrdXrtk=";
  };

  vendorHash = "sha256-qFqFyPdAqh2BXeE2tkLmn88Z8qHFeSlTA2Ols8H7iaQ=";

  nativeBuildInputs = [ installShellFiles ];

  # Tests require config files that aren't available in the build environment
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/charmbracelet/crush/internal/version.Version=${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd crush \
      --bash <($out/bin/crush completion bash) \
      --fish <($out/bin/crush completion fish) \
      --zsh <($out/bin/crush completion zsh)
  '';

  meta = with lib; {
    description = "The glamourous AI coding agent for your favourite terminal";
    homepage = "https://github.com/charmbracelet/crush";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [ zimbatm ];
    mainProgram = "crush";
  };
}
