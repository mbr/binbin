{
  lib,
  stdenvNoCC,
  makeWrapper,
  symlinkJoin,
  python3,
  bash,
  coreutils,
  ncurses,
  ghostscript_headless,
  gitMinimal,
  openssh,
  rsync,
  mpv,
  yt-dlp,
  dosfstools,
  inotify-tools,
  ntfs3g,
  util-linux,
  xauth,
}:
let
  version = "0-unstable-2026-08-17";

  mkTool =
    name:
    {
      description,
      runtimeInputs ? [ ],
      pythonPackages ? null,
      platforms ? lib.platforms.unix,
    }:
    let
      python = if pythonPackages == null then null else python3.withPackages pythonPackages;
    in
    stdenvNoCC.mkDerivation {
      pname = name;
      inherit version;

      src = ./bin + "/${name}";

      strictDeps = true;
      dontUnpack = true;
      dontBuild = true;
      nativeBuildInputs = [ makeWrapper ];
      buildInputs = lib.optional (python != null) python;

      installPhase = ''
        runHook preInstall

        install -Dm755 "$src" "$out/bin/${name}"
        ${lib.optionalString (runtimeInputs != [ ]) ''
          wrapProgram "$out/bin/${name}" \
            --prefix PATH : ${lib.makeBinPath runtimeInputs}
        ''}

        runHook postInstall
      '';

      meta = {
        inherit description platforms;
        homepage = "https://github.com/mbr/binbin";
        license = lib.licenses.mit;
        mainProgram = name;
      };
    };

  toolDefinitions = {
    anycite = {
      description = "Generate BibLaTeX entries from URLs, ISBNs, and GitHub repositories";
      pythonPackages =
        packages: with packages; [
          click
          requests
        ];
    };
    boring-shell = {
      description = "Open a minimal Bash environment for screencasts";
      runtimeInputs = [
        bash
        ncurses
      ];
    };
    git-autopush = {
      description = "Install a Git hook that automatically pushes master";
      runtimeInputs = [
        coreutils
        gitMinimal
      ];
    };
    git-cl = {
      description = "Clone repositories into a standardized directory hierarchy";
      pythonPackages = _: [ ];
      runtimeInputs = [
        gitMinimal
        openssh
      ];
    };
    git-dlist = {
      description = "Find unpushed changes across multiple Git repositories";
      pythonPackages = packages: [ packages.click ];
      runtimeInputs = [
        gitMinimal
        openssh
      ];
    };
    git-nuke = {
      description = "Remove a file from every branch and tag in a Git repository";
      runtimeInputs = [
        coreutils
        gitMinimal
      ];
    };
    pdfmail = {
      description = "Downsample and optionally grayscale PDFs for email";
      pythonPackages = packages: [ packages.click ];
      runtimeInputs = [ ghostscript_headless ];
    };
    shellcolors = {
      description = "Print a terminal color table on different backgrounds";
      runtimeInputs = [ coreutils ];
    };
    twitch = {
      description = "Play Twitch streams through yt-dlp and mpv";
      pythonPackages =
        packages: with packages; [
          click
          requests
        ];
      runtimeInputs = [
        mpv
        yt-dlp
      ];
    };
  }
  // lib.optionalAttrs stdenvNoCC.hostPlatform.isLinux {
    mkusbstick = {
      description = "Format USB drives for compatibility with common operating systems";
      pythonPackages = packages: [ packages.click ];
      runtimeInputs = [
        coreutils
        dosfstools
        ntfs3g
        util-linux
      ];
      platforms = lib.platforms.linux;
    };
    syncto = {
      description = "Watch a directory and synchronize changes to a remote";
      runtimeInputs = [
        coreutils
        inotify-tools
        openssh
        rsync
        util-linux
      ];
      platforms = lib.platforms.linux;
    };
    xsu = {
      description = "Transfer Xauthority credentials before changing user";
      runtimeInputs = [
        coreutils
        xauth
      ];
      platforms = lib.platforms.linux;
    };
  };

  tools = lib.mapAttrs mkTool toolDefinitions;
in
symlinkJoin {
  name = "binbin-${version}";
  paths = lib.attrValues tools;

  passthru = { inherit tools; };

  meta = {
    description = "Personal collection of small command-line tools";
    homepage = "https://github.com/mbr/binbin";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
