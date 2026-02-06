{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  buildInputs = [
    pkgs.python3Packages.jupyterlab
    pkgs.coursier # 用来下载并启动 Almond
    pkgs.openjdk11 # Chisel 推荐版本
    pkgs.verilator # Chisel 仿真工具
    pkgs.git
  ];

  shellHook = ''
    export JUPYTER_DATA_DIR="$PWD/.jupyter_data"

    # 定义 Almond 版本和 Scala 版本
    ALMOND_VERSION="0.13.14"
    SCALA_VERSION="2.13.10" # Chisel Bootcamp 常用版本

    echo "正在通过 Coursier 检查/安装 Almond 内核..."

    # 使用 coursier 直接运行 almond 的安装程序
    # 这会下载必要的 jar 包并注册到本地的 .jupyter_data 目录
    cs launch --fork almond:$ALMOND_VERSION --scala $SCALA_VERSION -- \
      --install --force --jupyter-path "$JUPYTER_DATA_DIR/kernels"

    echo "------------------------------------------"
    echo "✅ 环境就绪！"
    echo "1. 输入 'jupyter lab' 启动"
    echo "2. 在 Jupyter 中新建 Notebook 时选择 Scala 内核"
    echo "------------------------------------------"
  '';
}
