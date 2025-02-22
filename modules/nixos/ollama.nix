{ lib, ... }:
{
  services.ollama.loadModels = lib.mkDefault [
    "qwen2.5-coder:14b"
    "deepseek-r1:14b"
  ];

  services.open-webui.environment.OLLAMA_API_BASE_URL = "http://localhost:11434";
}
