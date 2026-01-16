describe('Path', function()
    local Path = require('path')
    local AbsolutePathsFake = require('absolute_paths_fake')
    local abs_paths = AbsolutePathsFake.new('/home/test', '/project', '/project/files');
    local abs_paths_win = AbsolutePathsFake.new('c:\\Users\\John', 'c:\\project', 'c:\\project\\files');

    describe('absolute()', function()
        it('should detect absolute path for nix and mac', function()
            assert.is_true((Path.new('/some/path', abs_paths)):absolute())
        end)

        it('should detect absolute path for win with lowercase drives', function ()
            assert.is_true((Path.new('C:\\something', abs_paths_win)):absolute())
        end)

        it('should detect absolute path for win with uppercase drives', function ()
            assert.is_true((Path.new('c:\\something', abs_paths_win)):absolute())
        end)
    end)

    describe('home_relative()', function()
        it('should detect home-relative path for nix and mac', function()
            assert.is_true((Path.new('~/some-path', abs_paths)):home_relative())
        end)

        it('should detect home-relative path for win', function ()
            assert.is_true((Path.new('c:\\Users\\John\\something', abs_paths_win)):home_relative())
        end)
    end)

    describe(':current_file_relative()', function()
        it('detects source file relative path for nix and mac', function()
            assert.is_true((Path.new('./some-path', abs_paths)):current_file_relative())
        end)

        it('detects source file relative path for win', function()
            assert.is_true((Path.new('.\\some-path', abs_paths_win)):current_file_relative())
        end)

        it('should consider nix path consisting only of multiple . as non parent relative', function ()
            assert.is_false((Path.new('././.', abs_paths)):current_file_relative())
        end)

        it('should consider win path consisting only of multiple . as non parent relative', function ()
            assert.is_false((Path.new('.\\.\\.', abs_paths_win)):current_file_relative())
        end)
    end)

    describe(':current_file_parent_relative()', function()
        it('detects source file parent relative path for nix and mac', function()
            assert.is_true((Path.new('../some-path', abs_paths)):current_file_parent_relative())
        end)

        it('detects correctly source file parent relative path for win', function ()
            assert.is_true((Path.new('..\\some-path', abs_paths_win)):current_file_parent_relative())
        end)

        it('should consider nix path consisting only of multiple .. as non parent relative', function ()
            assert.is_false((Path.new('../../..', abs_paths)):current_file_parent_relative())
        end)

        it('should consider win path consisting only of multiple .. as non parent relative', function ()
            assert.is_false((Path.new('..\\..\\..', abs_paths_win)):current_file_parent_relative())
        end)
    end)

    describe(':project_relative()', function()
        it('detects project relative path for nix or mac', function()
            assert.is_true((Path.new('some/path/file.md', abs_paths)):project_relative())
        end)

        it('detects project relative path for win', function ()
            assert.is_true((Path.new('some\\path\\file.md', abs_paths_win)):project_relative())
        end)

        it('should not consider empty path as project relative', function ()
            assert.is_false((Path.new('', abs_paths)):project_relative())
        end)
    end)

    describe(':to_absolute()', function()
        it('returns path as is, if it is mac or linux abs path', function()
            local path = Path.new('/root/bla', abs_paths)
            assert.are.same('/root/bla', path:to_absolute())
        end)

        it('returns path as is for win absolute path', function ()
            local path = Path.new('c:\\bla', abs_paths_win)
            assert.are.same('c:\\bla', path:to_absolute())
        end)

        it('returns proper abs path for home-relative path on nix or mac', function()
            local path = Path.new('~/my-file.md', abs_paths)
            assert.are.same('/home/test/my-file.md', path:to_absolute())
        end)

        it('returns path as is for home-relative win path', function ()
            local path = Path.new('c:\\Users\\John\\my-file.md', abs_paths_win)
            assert.are.same('c:\\Users\\John\\my-file.md', path:to_absolute())
        end)

        it('returns proper abs path for source file relative path on nix or mac', function()
            local path = Path.new('./my-file.md', abs_paths)
            assert.are.same('/project/files/my-file.md', path:to_absolute())
        end)

        it('returns proper abs path for source file relative path on win', function ()
            local path = Path.new('.\\my-file.md', abs_paths_win)
            assert.are.same('c:\\project\\files\\my-file.md', path:to_absolute())
        end)

        it('returns proper abs path for source parent relative path on nix or mac', function()
            local path = Path.new('../my-file.md', abs_paths)
            assert.are.same('/project/my-file.md', path:to_absolute())
        end)

        it('returns proper abs path for source parent relative path on win', function ()
            local path = Path.new('..\\my-file.md', abs_paths_win)
            assert.are.same('c:\\project\\my-file.md', path:to_absolute())
        end)

        it('returns proper abs path for project relative path on nix or mac', function()
            local path = Path.new('my-file.md', abs_paths)
            assert.are.same('/project/my-file.md', path:to_absolute())
        end)

        it('returns proper abs path for project relative path on win', function ()
            local path = Path.new('my-file.md', abs_paths_win)
            assert.are.same('c:\\project\\my-file.md', path:to_absolute())
        end)

        it('should return empty string for empty path', function ()
            local path = Path.new('', abs_paths)
            assert.are.same('', path:to_absolute())
        end)

        it('handles properly multiple dobule dots at the beginning for nix', function ()
            local path = Path.new('../../my-file.md', abs_paths)
            assert.are.same('/my-file.md', path:to_absolute())

            local path = Path.new('../../../my-file.md', abs_paths)
            assert.are.same('/my-file.md', path:to_absolute())
        end)

        it('handles properly multiple dots at the beginning for win', function ()
            local path = Path.new('..\\..\\my-file.md', abs_paths_win)
            assert.are.same('c:\\my-file.md', path:to_absolute())

            path = Path.new('..\\..\\..\\my-file.md', abs_paths_win)
            assert.are.same('c:\\my-file.md', path:to_absolute())
        end)

        it('should consider nix path consisting only with multiple .. as incorrect', function ()
            local path = Path.new('../../..', abs_paths)
            assert.are.same('', path:to_absolute())

            path = Path.new('../../../', abs_paths)
            assert.are.same('', path:to_absolute())
        end)

        it('should consider win path consisting only with multiple .. as incorrect', function ()
            local path = Path.new('..\\..\\..', abs_paths_win)
            assert.are.same('', path:to_absolute())

            path = Path.new('..\\..\\..\\', abs_paths_win)
            assert.are.same('', path:to_absolute())
        end)
    end)
end)
