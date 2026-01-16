-- Switching off some slow unnecessary stuff
vim.o.backup = false
vim.o.undofile = false
vim.o.swapfile = false
vim.o.writebackup = false

-- Making fixtures stuff available for importing
local tests_abs_path = '/data/tests/e2e/'
vim.opt.runtimepath:prepend(tests_abs_path .. 'fixtures')

-- Running all e2e tests in proper directory
local harness = require('plenary.test_harness')
harness.test_directory(tests_abs_path)
