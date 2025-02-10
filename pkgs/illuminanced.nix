{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "illuminanced";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "mikhail-m1";
    repo = "illuminanced";
    rev = "ee95f97dc1ed197abe3a7c4f3ad45121a077d3eb";
    hash = "sha256-dilApolbxgl//2YVbd4ITYVNwfCQQ8LPayqmmW5Jhv8=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  patches = [ ./illuminanced-log-level-non-daemon.patch ];

  meta = {
    description = "Ambient Light Sensor Daemon for Linux";
    homepage = "https://github.com/mikhail-m1/illuminanced";
    license = lib.licenses.gpl3;
    mainProgram = "illuminanced";
  };
}
