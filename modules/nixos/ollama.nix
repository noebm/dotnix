{...}: {
  services.ollama = {
    enable = true;

    loadModels = [
      "qwen2.5-coder"
    ];
  };
}
