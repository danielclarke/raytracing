emcmake cmake -S . -B build -DPLATFORM=Web -DEMSCRIPTEN=true
cmake --build build
cp ./assets/index.html ./build