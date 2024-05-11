# Quick references

## System profiles and boot menu entries

- Profile links are at `/nix/var/nix/profiles/`
- Boot enties are at `/boot/loader/entries`

Running the following might help to remove boot entries?
```bash
/run/current-system/bin/switch-to-configuration boot
```

## Sops

See [sops-nix](https://github.com/Mic92/sops-nix).

### Setup


In short:
- Generate user secret.
```bash
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
```
- Generate host secret (using file from openssh).
```bash
nix-shell -p ssh-to-age --run 'cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age'
```
- Include public keys in `.sops.yaml`.

### Modification
Run
```bash
nix-shell -p sops --run "sops secrets/<something>.yaml"
```
which will encrypt the written file.
