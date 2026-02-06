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
            jupyter-all
            coursier
            openjdk8
            verilator
            git
          ];

          shellHook = ''
                        export JUPYTER_DATA_DIR="$PWD/.jupyter_data"

                        ALMOND_VERSION="0.13.14"
                        SCALA_VERSION="2.13.10"

                        # Check if kernel is already installed
                        KERNEL_DIR="$JUPYTER_DATA_DIR/kernels/scala"
                        if [ ! -d "$KERNEL_DIR" ]; then
                          echo "Installing Almond kernel with Chisel dependencies..."

                          # Create a predef.sc file with Chisel imports
                          PREDEF_FILE="$PWD/.almond-predef.sc"
                          cat > "$PREDEF_FILE" << 'EOF'
            // Predef file for Chisel Bootcamp
            interp.repositories() ::: List(
              coursierapi.MavenRepository.of("https://oss.sonatype.org/content/repositories/snapshots")
            )

            interp.configureCompiler(x => x.settings.source.value = scala.tools.nsc.settings.ScalaVersion("2.11.12"))

            import $ivy.`com.lihaoyi::ammonite-ops:2.5.9`
            import $ivy.`edu.berkeley.cs::chisel3:3.4.+`
            import $ivy.`edu.berkeley.cs::chisel-iotesters:1.5.+`
            import $ivy.`edu.berkeley.cs::chiseltest:0.3.+`
            import $ivy.`edu.berkeley.cs::dsptools:1.4.+`
            import $ivy.`org.scalanlp::breeze:0.13.2`
            import $ivy.`edu.berkeley.cs::rocket-dsptools:1.2.0`
            import $ivy.`edu.berkeley.cs::firrtl-diagrammer:1.3.+`
            import $ivy.`org.scalatest::scalatest:3.2.2`

            // Load the load-ivy.sc file
            val path = System.getProperty("user.dir") + "/source/load-ivy.sc"
            interp.load.module(ammonite.ops.Path(java.nio.file.Paths.get(path)))
            EOF

                          # Install Almond kernel with predef file
                          cs launch --fork almond:$ALMOND_VERSION --scala $SCALA_VERSION -- \
                            --install --force --jupyter-path "$JUPYTER_DATA_DIR/kernels" \
                            --predef "$PREDEF_FILE"

                          echo "Predef file created at: $PREDEF_FILE"
                        else
                          echo "Almond kernel already installed at $KERNEL_DIR"

                          # Ensure predef file exists
                          PREDEF_FILE="$PWD/.almond-predef.sc"
                          if [ ! -f "$PREDEF_FILE" ]; then
                            echo "Recreating missing predef file..."
                            cat > "$PREDEF_FILE" << 'EOF'
            // Predef file for Chisel Bootcamp
            interp.repositories() ::: List(
              coursierapi.MavenRepository.of("https://oss.sonatype.org/content/repositories/snapshots")
            )

            interp.configureCompiler(x => x.settings.source.value = scala.tools.nsc.settings.ScalaVersion("2.11.12"))

            import $ivy.`com.lihaoyi::ammonite-ops:2.5.9`
            import $ivy.`edu.berkeley.cs::chisel3:3.4.+`
            import $ivy.`edu.berkeley.cs::chisel-iotesters:1.5.+`
            import $ivy.`edu.berkeley.cs::chiseltest:0.3.+`
            import $ivy.`edu.berkeley.cs::dsptools:1.4.+`
            import $ivy.`org.scalanlp::breeze:0.13.2`
            import $ivy.`edu.berkeley.cs::rocket-dsptools:1.2.0`
            import $ivy.`edu.berkeley.cs::firrtl-diagrammer:1.3.+`
            import $ivy.`org.scalatest::scalatest:3.2.2`

            // Load the load-ivy.sc file
            val path = System.getProperty("user.dir") + "/source/load-ivy.sc"
            interp.load.module(ammonite.ops.Path(java.nio.file.Paths.get(path)))
            EOF
                            echo "Predef file recreated at: $PREDEF_FILE"
                          fi
                        fi

                        echo "------------------------------------------"
                        echo "✅ Chisel Bootcamp environment ready!"
                        echo "1. Run 'jupyter lab' to start Jupyter"
                        echo "2. Select 'Scala' kernel in Jupyter"
                        echo "3. Chisel dependencies are pre-loaded"
                        echo "------------------------------------------"
          '';
        };
      }
    );
}
