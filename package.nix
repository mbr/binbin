{
  lib,
  stdenvNoCC,
  makeWrapper,
  python3,
  bash,
  coreutils,
  gcc-unwrapped,
  ghostscript_headless,
  gitMinimal,
  openssh,
  rsync,
  dosfstools,
  inotify-tools,
  ntfs3g,
  xauth,
}:
let
  python = python3.withPackages (
    packages: with packages; [
      click
      jinja2
      requests
    ]
  );

  runtimeInputs = [
    bash
    coreutils
    gcc-unwrapped
    ghostscript_headless
    gitMinimal
    openssh
    rsync
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [
    dosfstools
    inotify-tools
    ntfs3g
    xauth
  ];
in
stdenvNoCC.mkDerivation {
  pname = "binbin";
  version = "0-unstable-2026-08-17";

  src = lib.cleanSource ./.;

  strictDeps = true;
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp bin/* "$out/bin/"

    for program in "$out"/bin/*; do
      wrapProgram "$program" --prefix PATH : ${lib.makeBinPath runtimeInputs}
    done

    runHook postInstall
  '';

  meta = {
    description = "Personal collection of small command-line tools";
    homepage = "https://github.com/mbr/binbin";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
