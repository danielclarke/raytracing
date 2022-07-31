--cc:gcc
--mm:arc

when defined(lto):
  switch("passC", "-flto -O4")
  switch("passL", "-flto -O4")

when defined(profile):
  --profiler:on
  --stacktrace:on

--nimcache:tmp
--outdir:build
--styleCheck:hint
--verbosity:2