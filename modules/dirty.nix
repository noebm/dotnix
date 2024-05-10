{self, ...}: {
  system.nixos.label =
    if self ? rev
    then self.rev
    else throw "Refusing to build from dirty Git tree!";
}
