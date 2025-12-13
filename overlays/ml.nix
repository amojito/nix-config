[
  (final: prev:
    let
      py = prev.python311;
      pypkgs = py.pkgs;
      dotDeps = with pypkgs; [
        boto3
        build
        docker
        gitpython
        importlib-metadata
        jinja2
        loguru
        markupsafe
        pydantic
        pypiserver
        pyyaml
        requests
        semver
        strenum
        tomlkit
        tox
        twine
        typer
        yamllint
      ];
    in {
      dot = pypkgs.buildPythonApplication {
        pname = "dot";
        version = "git";
        src = builtins.fetchGit {
        url = "ssh://git@bitbucket.org/multiplylabs/dot.git";
        ref = "refs/heads/main";
        rev = "967af0ba6e26b3865e980c71958935a9482d0fd0";
      };
        format = "pyproject";
        nativeBuildInputs = [ pypkgs.flit-core ];
        propagatedBuildInputs = dotDeps;
        makeWrapperArgs = [ "--set PYTHONPATH ${pypkgs.makePythonPath dotDeps}" ];
        pythonRelaxDeps = map (pkg: prev.lib.strings.toLower pkg.pname) dotDeps;
        doCheck = false;
      };
    })
]
