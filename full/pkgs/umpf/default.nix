{ stdenv
 , fetchFromGitHub
 , ... }:

stdenv.mkDerivation rec {
  name = "umpf";
  version = "master";

  src = fetchFromGitHub {
    owner = "pengutronix";
    repo = "umpf";
    rev = "${version}";
    sha256 = "sha256-5Qf/4JahQEd9ZB3fuD/5pDa3CwmYbtotgvlJG10kJZE=";
  };

  buildPhase = "true"; 
  installPhase = ''
    mkdir -p "$out/bin"
    install $src/umpf $out/bin
    patchShebangs $out/bin/umpf
  '';

  meta = with stdenv.lib; {
    description = "Ultimate Master Patch Functionator";
    homepage = "https://github.com/pengutronix/umpf/";
  };
}
