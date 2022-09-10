export MAKEFLAGS="-j4"
export CPPFLAGS="-I/$(brew --prefix llvm)/include"
export LDFLAGS="-L/$(brew --prefix llvm)/lib -Wl,-rpath,/$(brew --prefix llvm)/lib"
export CXX="/$(brew --prefix llvm)/bin/clang++"
export CC="/$(brew --prefix llvm)/bin/clang"
cmake -S . -B build
cmake --build build
cp ./assets/index.html ./build