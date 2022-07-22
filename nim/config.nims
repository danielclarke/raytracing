when defined(emscripten):
  --os:linux # Emscripten pretends to be linux.
  --cpu:wasm32 # Emscripten is 32bits.
  --cc:clang # Emscripten is very close to clang, so we will replace it.
  when defined(windows):
    --clang.exe:emcc.bat  # Replace C
    --clang.linkerexe:emcc.bat # Replace C linker
    --clang.cpp.exe:emcc.bat # Replace C++
    --clang.cpp.linkerexe:emcc.bat # Replace C++ linker.
  else:
    --clang.exe:emcc  # Replace C
    --clang.linkerexe:emcc # Replace C linker
    --clang.cpp.exe:emcc # Replace C++
    --clang.cpp.linkerexe:emcc # Replace C++ linker.

  --listCmd # List what commands we are running so that we can debug them.

  --mm:orc # GC:orc is friendlier with crazy platforms.
  --exceptions:goto # Goto exceptions are friendlier with crazy platforms.
  --define:noSignalHandler # Emscripten doesn't support signal handlers.

  # Pass this to Emscripten linker to generate html file scaffold for us.
  switch("passL", "-s USE_GLFW=3 -s ASSERTIONS=1 -s WASM=1 -s ASYNCIFY -o build/index.html --shell-file ./assets/index.html")
else:
  --cc:gcc
  --mm:arc # GC:orc is friendlier with crazy platforms.

  when defined(lto):
    switch("passC", "-flto -O4")
    switch("passL", "-flto -O4")

  when defined(profile):
    --profiler:on
    --stacktrace:on
 
--nimcache:tmp # Store intermediate files close by in the ./tmp dir.
--outdir:build
--styleCheck:hint
--verbosity:2