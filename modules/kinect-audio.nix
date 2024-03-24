{
  system,
  inputs,
  ...
}: {
  services.udev.packages = [inputs.kinect-audio.packages."${system}".default];
}
