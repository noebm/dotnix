{
  config,
  ...
}: {
  sops.defaultSopsFile = ../../secrets/user.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";

  sops.secrets."git/email" = {};
  sops.secrets."git/full_name" = {};

  sops.templates."git_secrets" = {
    content = ''
      [user]
        name = ${config.sops.placeholder."git/full_name"}
        email = ${config.sops.placeholder."git/email"}
    '';
  };
}
