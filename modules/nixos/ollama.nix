{
  lib,
  config,
  pkgs,
  ...
}:
{

  options = {
    ollama = {
      enable = lib.mkEnableOption "Enable Ollama service";
      webui = {
        enable = lib.mkEnableOption "Enable Ollama webui service";
        manual_start = lib.mkEnableOption ''
          Disable the service by default.

          That means you need to manually start the service via systemd.
        '';
      };
      models = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "qwen2.5-coder:3b"
          "qwen2.5-coder:7b"
          "qwen2.5-coder:14b"
          "deepseek-r1:8b"
          "deepseek-r1:14b"
        ];
      };
    };

  };

  config = {
    services.ollama = lib.mkIf config.ollama.enable {
      enable = config.ollama.enable;
      loadModels = config.ollama.models;
    };

    systemd.services.open-webui.wantedBy = lib.mkIf config.ollama.webui.manual_start (pkgs.lib.mkForce [ ]);
    services.open-webui = {
      enable = config.ollama.webui.enable;
      environment.OLLAMA_API_BASE_URL = "http://localhost:11434";
    };

  };

}
