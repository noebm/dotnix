{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "illuminanced";
  version = "0.1.0";

  src = fetchFromGitHub {
    url = "https://github.com/mikhail-m1/illuminanced";
    rev = "ee95f97dc1ed197abe3a7c4f3ad45121a077d3eb";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  meta = {
    description = "Ambient Light Sensor Daemon for Linux";
    homepage = "https://github.com/mikhail-m1/illuminanced";
    license = lib.licenses.gpl3;
    mainProgram = "illuminanced";
  };
}
