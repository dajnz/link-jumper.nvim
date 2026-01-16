describe('String utils module', function()
    local str = require('str')

    describe('str.starts_with()', function()
        it('should be truthy for substring that exists at the beginning', function()
            assert.is_true(str.starts_with('some string', 's'))
            assert.is_true(str.starts_with('some string', 'so'))
            assert.is_true(str.starts_with('.some string', '.'))
            assert.is_true(str.starts_with('~/some string', '~/'))
            assert.is_true(str.starts_with('.\\some string', '.\\'))
            assert.is_true(str.starts_with('some string', 'some string'))
        end)

        it('should handle Unicode strings properly', function()
            assert.is_true(str.starts_with('юникодная строка', 'юн'))
            assert.is_true(str.starts_with('曹秦琦', '曹'))
        end)

        it('should be falsy for substring that not exists at the beginning', function()
            assert.is_false(str.starts_with('some string', 'bla'))
            assert.is_false(str.starts_with('X/some string', '.'))
            assert.is_false(str.starts_with('./some string', '%.'))
            assert.is_false(str.starts_with('~/some string', '%./'))
        end)
    end)

    describe('str.ends_with()', function ()
        it('should by truthy for string contains given substring at the end', function ()
            assert.is_true(str.ends_with('some string', 'ing'))
            assert.is_true(str.ends_with('some string', 'some string'))
        end)

        it('should handle Unicode strings properly', function ()
            assert.is_true(str.ends_with('юникодная строка', 'ока'))
            assert.is_true(str.ends_with('曹秦琦', '琦'))
        end)

        it('should be falsy for a substring not existing at the end of given string', function ()
            assert.is_false(str.ends_with('some string', 'rasta-blasta'))
            assert.is_false(str.ends_with('some string', 'rasta'))
        end)
    end)

    describe('str.find_substring_pos()', function ()
        it('should return 0 if no substring found', function ()
            assert.are.same(0, str.find_substring_pos('some string', 'bla'))
        end)

        it('should return proper pos of existing sub string', function ()
            assert.are.same(6, str.find_substring_pos('some bla string', 'bla'))
        end)

        it('should return pos of the 1st occurrence of sub string', function ()
            assert.are.same(6, str.find_substring_pos('some bla string bla', 'bla'))
        end)

        it('should respect Unicode', function ()
            assert.are.same(7, str.find_substring_pos('некая 曹 строка', '曹'))
        end)
    end)

    describe('str.split()', function()
        it('should return original string only for not existing separator', function()
            assert.are.same({'some string'}, str.split('some string', '|'))
        end)

        it('should split string by spaces when separator is not set', function()
            assert.are.same({'some', 'string'}, str.split('some string'))
        end)

        it('should split string by all occurrences of a separator in the middle of string', function()
            assert.are.same({'a','b','c'}, str.split('a-b-c', '-'))
        end)

        it('should work well when separator is at the beginning of a string', function()
            assert.are.same({'some string'}, str.split('|some string', '|'))
        end)

        it('should work well when separator is at the end of a string', function()
            assert.are.same({'some string'}, str.split('some string|', '|'))
        end)

        it('should work with substrings as separator', function()
            assert.are.same({'1', '2', '3'}, str.split('1ooo2ooo3', 'ooo'))
        end)

        it('should handle special regexp characters in separator properly', function()
            assert.are.same({'1', '2', '3'}, str.split('1.^$()%[]*+-?2.^$()%[]*+-?3', '.^$()%[]*+-?'))
        end)

        it('should work with Unicode characters in string and sepatator properly', function()
            assert.are.same({'1', '2', '3'}, str.split('1юникод曹2юникод曹3', 'юникод曹'))
        end)

        it('should work properly with backslash as separator', function ()
            assert.are.same({'1', '2', '3'}, str.split('1\\2\\3', '\\'))
        end)
    end)

    describe('str.join()', function()
        it('should return empty string when some_items is not a table', function()
            assert.are.same('', str.join(nil))
            assert.are.same('', str.join(1))
            assert.are.same('', str.join('a'))
            assert.are.same('', str.join(false))
        end)

        it('should join items using space if separator is not passed', function()
            assert.are.same('one two', str.join({'one', 'two'}))
        end)

        it('should use specified separator properly', function()
            assert.are.same('one-=V=-two', str.join({'one', 'two'}, '-=V=-'))
        end)

        it('should work properly with backslash as a separator', function ()
            assert.are.same('one\\two\\three', str.join({'one', 'two', 'three'}, '\\'))
        end)

        it('should work with Unicode items and separator properly', function()
            assert.are.same('ОДИН😀😀😀六', str.join({'ОДИН', '六'}, '😀😀😀'))
        end)
    end)
end)
