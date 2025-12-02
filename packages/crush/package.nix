{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  installShellFiles,
}:
buildGo125Module rec {
  pname = "crush";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "crush";
    rev = "v${version}";
    hash = "sha256-SfuMX6ZiOFwi9dx1ZAM3uIKCjl52X93JzQa71q6uXAY=";
  };

  vendorHash = "sha256-mlX961xljS+KcP+ReQsP6N1VK6blG0yLpRVIvXJAQBw=";

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
