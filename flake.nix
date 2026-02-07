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
            buildInputs = with pkgs; [
              jupyter.all
              coursier
              openjdk8
              verilator
              graphviz
              git
              nodejs
            ];

          shellHook = ''
            export JUPYTER_DATA_DIR="$PWD/.jupyter_data"

             ALMOND_VERSION="0.10.6"
             SCALA_VERSION="2.12.8"

            # Check if kernel is already installed and matches version
            KERNEL_DIR="$JUPYTER_DATA_DIR/kernels/scala"
            KERNEL_VERSION_FILE="$KERNEL_DIR/scala_version"
            if [ ! -d "$KERNEL_DIR" ] || [ ! -f "$KERNEL_VERSION_FILE" ] || [ "$(cat "$KERNEL_VERSION_FILE")" != "$SCALA_VERSION" ]; then
              echo "Installing Almond kernel (Scala $SCALA_VERSION)..."
              rm -rf "$KERNEL_DIR"
              cs launch --fork almond:$ALMOND_VERSION --scala $SCALA_VERSION -- \
                --install --force --jupyter-path "$JUPYTER_DATA_DIR/kernels"
              echo "$SCALA_VERSION" > "$KERNEL_VERSION_FILE"
            else
              echo "Almond kernel already installed at $KERNEL_DIR (Scala $SCALA_VERSION)"
            fi

            # Ensure predef file exists
            PREDEF_FILE="$PWD/.almond-predef.sc"
            if [ ! -f "$PREDEF_FILE" ]; then
              echo "Creating predef file from source/load-ivy.sc..."
              cp source/load-ivy.sc "$PREDEF_FILE"
              # Fix Scala version to match kernel
              sed -i 's/ScalaVersion(\"[^\"]*\")/ScalaVersion(\"'"$SCALA_VERSION"'\")/' "$PREDEF_FILE"
            else
              echo "Predef file already exists at $PREDEF_FILE"
              # Ensure Scala version is correct
              sed -i 's/ScalaVersion(\"[^\"]*\")/ScalaVersion(\"'"$SCALA_VERSION"'\")/' "$PREDEF_FILE"
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
