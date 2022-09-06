export MAKEFLAGS="-j4"
export CPPFLAGS="-I/usr/local/Cellar/llvm/13.0.1_1.reinstall/include"
export LDFLAGS="-L/usr/local/Cellar/llvm/13.0.1_1.reinstall/lib -Wl,-rpath,/usr/local/Cellar/llvm/13.0.1_1.reinstall/lib"
export CXX="/usr/local/Cellar/llvm/13.0.1_1.reinstall/bin/clang++"
export CC="/usr/local/Cellar/llvm/13.0.1_1.reinstall/bin/clang"
cmake -S . -B build
cmake --build build
cp ./assets/index.html ./build