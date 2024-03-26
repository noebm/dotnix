

## Sops

### Setup

See [sops-nix](https://github.com/Mic92/sops-nix).

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
