{pkgs, ...}: let
  git_prompt = {git}:
  # add current branch to shell prompt
  ''
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWCOLORHINTS=1
    # FIXME the nix expression `programs.git.prompt.enable = true;` should be equivalent but doesnt work
    source ${git}/share/bash-completion/completions/git-prompt.sh

    # Define color variables
    DIM='\[\e[2m\]'
    BOLD='\[\e[1m\]'
    CYAN="\[''${BOLD}\e[38:5:14m\]"
    BLUE="\[''${BOLD}\e[38:5:12m\]"
    PURPLE="\[''${BOLD}\e[35m\]"
    GREEN="\[''${BOLD}\e[32m\]"
    RESET='\[\e[0m\]'

    # Define custom PS1 prompt
    PS1="''${PURPLE}\u''${RESET}''${DIM}@''${RESET}''${GREEN}\h''${RESET}:''${BLUE}\w''${RESET}\$(__git_ps1 \"''${DIM}@[''${RESET}''${BOLD}%s''${RESET}''${DIM}]''${RESET}\") ''${CYAN}>''${RESET} "
  '';
in {
  programs.bash.enableCompletion = true;
  programs.bash.promptInit = pkgs.callPackage git_prompt {};
}
