{ pythonPackages, pdm }:

pythonPackages.buildPythonPackage rec {
  pname = "pylsp_inlay_hints";
  version = "0.1.0";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    hash = "sha256-VD3JxorCBd/Ek4q4aBI+pWeh/4MSrHroIRyEgmc8BJI=";
  };

  # do not run tests
  doCheck = false;

  # specific to buildPythonPackage, see its reference
  pyproject = true;
  build-system = [
    pdm
    pythonPackages.pdm-backend
    pythonPackages.setuptools
    pythonPackages.wheel
  ];

  dontCheckRuntimeDeps = true;
}
