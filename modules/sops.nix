{
  config,
  user,
  ...
}: {
  sops.defaultSopsFile = ../secrets/user.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/home/${user}/.config/sops/age/keys.txt";

  sops.secrets."git/email".owner = user;
  sops.secrets."git/full_name".owner = user;

  sops.templates."git_secrets" = {
    content = ''
      [user]
        name = ${config.sops.placeholder."git/full_name"}
        email = ${config.sops.placeholder."git/email"}
    '';
    owner = user;
  };
}
