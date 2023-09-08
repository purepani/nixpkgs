{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "ssh-audit";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "jtesta";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+v+DLZPDC5uffTIJPzMvY/nLoy7BGiAsTddjNZZhTpo=";
  };

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Tool for ssh server auditing";
    homepage = "https://github.com/jtesta/ssh-audit";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ tv SuperSandro2000 ];
  };
}
