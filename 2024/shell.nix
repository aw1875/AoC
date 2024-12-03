with import <nixpkgs> { };

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    git
    zig
    zls
  ];
}

