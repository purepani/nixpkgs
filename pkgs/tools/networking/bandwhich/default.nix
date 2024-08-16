{ lib, stdenv, fetchFromGitHub, rustPlatform, Security, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "bandwhich";
  version = "0.22.2-unstable-2024-08-13";

  src = fetchFromGitHub {
    owner = "imsnif";
    repo = pname;
    rev = "894ea319838cbfd75b00f08518bca41a9c8e060c";
    hash = "sha256-DjH48mkgz81ACvZ28P2HzhLvS7wVresWzIAPD7swzoY=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "packet-builder-0.7.0" = "sha256-KxNrnLZ/z3JJ3E1pCTJF9tNXI7XYNRc6ooTUz3avpjw=";
    };
  };

  checkFlags = [
    # failing in upstream CI
    "--skip=tests::cases::ui::layout_under_50_width_under_50_height"
  ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optional stdenv.isDarwin Security;

  # 10 passed; 47 failed https://hydra.nixos.org/build/148943783/nixlog/1
  doCheck = !stdenv.isDarwin;

  postPatch = ''
    ln --force -s ${./Cargo.lock} Cargo.lock
  '';

  preConfigure = ''
    export BANDWHICH_GEN_DIR=_shell-files
    mkdir -p $BANDWHICH_GEN_DIR
  '';

  postInstall = ''
    installManPage $BANDWHICH_GEN_DIR/bandwhich.1

    installShellCompletion $BANDWHICH_GEN_DIR/bandwhich.{bash,fish} \
      --zsh $BANDWHICH_GEN_DIR/_bandwhich
  '';

  meta = with lib; {
    description = "CLI utility for displaying current network utilization";
    longDescription = ''
      bandwhich sniffs a given network interface and records IP packet size, cross
      referencing it with the /proc filesystem on linux or lsof on MacOS. It is
      responsive to the terminal window size, displaying less info if there is
      no room for it. It will also attempt to resolve ips to their host name in
      the background using reverse DNS on a best effort basis.
    '';
    homepage = "https://github.com/imsnif/bandwhich";
    changelog = "https://github.com/imsnif/bandwhich/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne figsoda ];
    platforms = platforms.unix;
    mainProgram = "bandwhich";
  };
}
