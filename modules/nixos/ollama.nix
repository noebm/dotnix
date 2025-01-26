{...}: {
  services.ollama = {
    enable = true;

    loadModels = [
      "qwen2.5-coder"
      "deepseek-r1:7b"
    ];
  };
}
