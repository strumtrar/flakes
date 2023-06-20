{ lib
, git
, fetchgit
, skipPip ? true
, python3
}:

with python3.pkgs; buildPythonApplication rec {
  pname = "ptx_dev_tools";
  version = "0.1";

  src = fetchGit rec {
    url = "git+ssh://intern@intern.scm.pengutronix.de/ptx_dev_tools";
    rev = "9500ba182e5403e4809b22c468317aaed304636d";
  };

  nativeBuildInputs = [
    setuptools_scm
  ];

  propagatedBuildInputs = with python3.pkgs; [
    icalendar
  ];

  doCheck = false;

  enableParallelBuilding = true;

  postInstall = ''
    install $src/ptx_dev_tools/ptx_metamake.py $out/bin/ptx_metamake

    # don't wrap apmm
    cp -R $src/ptx_dev_tools/apmm "$out/lib/${python.libPrefix}/site-packages"
  '';

  meta = with stdenv.lib; {
    description = "PTX Development Tools";
  };
}
