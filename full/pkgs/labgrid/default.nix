{ 
  inputs
, fetchFromGitHub
, python3Packages
, lib
, openssh
, git
}:

python3Packages.buildPythonPackage rec {
  pname = "labgrid";
  format = "pyproject";
  version = "23.0.3";

  src = inputs.labgridGit;
  patches = [ ];

  nativeBuildInputs = [
          python3Packages.setuptools-scm
          openssh
          git
          python3Packages.python-kasa
          python3Packages.pymodbus
          python3Packages.pysnmp
    	  python3Packages.pyserial
        ];

  propagatedBuildInputs = [
    python3Packages.ansicolors
    python3Packages.attrs
    python3Packages.autobahn
    python3Packages.jinja2
    python3Packages.packaging
    python3Packages.pexpect
    python3Packages.pyserial
    python3Packages.pyudev
    python3Packages.pyusb
    python3Packages.pyyaml
    python3Packages.requests
    python3Packages.xmodem
  ];

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${version}"
  '';

  nativeCheckInputs = [
    python3Packages.mock
    python3Packages.psutil
    python3Packages.pytestCheckHook
    python3Packages.pytest-mock
    python3Packages.pytest-dependency
    python3Packages.pyserial
  ];

  meta = with lib; {
    description = "Embedded control & testing library";
    homepage = "https://labgrid.org";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ emantor ];
    platforms = with platforms; linux;
  };
}
