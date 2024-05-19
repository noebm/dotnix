{...}: {
  programs.bash.enable = true;

  programs.starship.enableBashIntegration = true;
  programs.starship = {
    enable = true;

    settings = {
      add_newline = false;
      # format = "$username$hostname$directory$git_branch$git_commit$git_state$git_status$character";

      character = {
        success_symbol = "[>](bright-blue bold)";
        error_symbol = "[x](bright-red bold)";
      };
    };
  };
}
