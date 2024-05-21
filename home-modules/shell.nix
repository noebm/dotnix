{lib, ...}: {
  programs.bash.enable = true;

  programs.starship.enableBashIntegration = true;
  programs.starship = {
    enable = true;

    settings = {
      add_newline = false;
      # "$username$hostname$directory$git_branch$git_commit$git_state$git_status$character";

      directory = {
        truncation_symbol = ".../";
        truncate_to_repo = false;
      };

      # git_branch = {
      #   format = "[@\\[](grey dimmed)[$symbol$branch($remote_branch)]($style)";
      # };

      # git_status = {
      #   format = "([\\[$all_status$ahead_behind\\]]($style) )[\\]](grey dimmed)";
      # };

      character = {
        success_symbol = "[>](bright-blue bold)";
        error_symbol = "[x](bright-red bold)";
      };

      package = {
        disabled = true;
      };
    };
  };
}
