{
  description = "Chisel Bootcamp development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.python3Packages.jupyterlab
            pkgs.coursier
            pkgs.openjdk11
            pkgs.verilator
            pkgs.git
          ];

          shellHook = ''
            export JUPYTER_DATA_DIR="$PWD/.jupyter_data"

            ALMOND_VERSION="0.13.14"
            SCALA_VERSION="2.13.10"

            # Check if kernel is already installed
            KERNEL_DIR="$JUPYTER_DATA_DIR/kernels/scala"
            if [ ! -d "$KERNEL_DIR" ]; then
              echo "Installing Almond kernel..."
              cs launch --fork almond:$ALMOND_VERSION --scala $SCALA_VERSION -- \
                --install --force --jupyter-path "$JUPYTER_DATA_DIR/kernels"
            else
              echo "Almond kernel already installed at $KERNEL_DIR"
            fi

            echo "------------------------------------------"
            echo "✅ Environment ready!"
            echo "1. Run 'jupyter lab' to start"
            echo "2. Select Scala kernel in Jupyter"
            echo "------------------------------------------"
          '';
        };
      }
    );
}
