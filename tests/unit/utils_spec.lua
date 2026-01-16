describe('Array utils module', function()
    local utils = require('utils')

    describe('utils.array_includes()', function()
        it('should return false if utilsay is not table', function()
            assert.is_false(utils.array_includes(nil, 'a'))
            assert.is_false(utils.array_includes('', 'a'))
            assert.is_false(utils.array_includes(10, 'a'))
        end)

        it('should return false if given value is not in the utilsay', function()
            assert.is_false(utils.array_includes({}, 'a'))
        end)

        it('should return true if given value is in the utilsay', function()
            local my_utils = { 'a', 'b', 1, true }
            assert.is_true(utils.array_includes(my_utils, 'a'))
            assert.is_true(utils.array_includes(my_utils, 1))
            assert.is_true(utils.array_includes(my_utils, true))
        end)
    end)

    describe('utils.map_has_key()', function()
        it('should throw error in map is not a table', function ()
            assert.has_error(function() utils.map_has_key(nil, 'test') end)
        end)

        it('should throw error in key is not a string', function ()
            assert.has_error(function() utils.map_has_key({}, nil) end)
        end)

        it('should return false if no given key in a map', function ()
            assert.is_false(utils.map_has_key({}, 'test'))
        end)

        it('should return true when key exists', function ()
            assert.is_true(utils.map_has_key({hello = 'world'}, 'hello'))
        end)
    end)

    describe('utils.count_map_items()', function ()
        it('should throw error in map is not a table', function ()
            assert.has_error(function() utils.count_map_items(nil) end)
        end)

        it('should return valid number of map key-value pairs', function ()
            assert.are.same(0, utils.count_map_items({}))
            assert.are.same(1, utils.count_map_items({ one = 1 }))
            assert.are.same(3, utils.count_map_items({ one = 1, two = 2, three = 3 }))
            assert.are.same(1, utils.count_map_items({ one = 1, 'non-key-value-item' }))
        end)
    end)
end)
