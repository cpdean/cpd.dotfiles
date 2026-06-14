-- vim-startuptime: the :StartupTime profiler. migrated from vim-plug
-- (gradual-refactor phase 2). first plugin on lazy.nvim; it establishes the
-- import pipeline (lua/cpdean_config/plugins/*.lua each return a lazy spec).
return {
  "dstein64/vim-startuptime",
  cmd = "StartupTime",
}
