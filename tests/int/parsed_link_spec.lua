describe('ParsedLink', function ()
    local ParsedLink = require('parsed_link')
    local LinkTextFake = require('link_text_fake')
    local AbsolutePathsFake = require('absolute_paths_fake')

    local TEST_FILE = 'my-file.md'
    local HOME_PATH = '/home/myuser'
    local PROJECT_PATH = '/projects'
    local ANCHOR = 'my-mega-heading'
    local SECURE_URL = 'https://site.com'
    local CURRENT_FILE_PATH = '/docs/gigadoc'
    local PATTERN = 'my\\(\\s\\|\\-\\)\\+mega\\(\\s\\|\\-\\)\\+heading'

    local abs_paths = AbsolutePathsFake.new(HOME_PATH, PROJECT_PATH, CURRENT_FILE_PATH)

    describe('absolute_path()', function ()
        it('returns absolute path for home-relative path', function ()
            local link = ParsedLink.new(LinkTextFake.new('~/' .. TEST_FILE), abs_paths)

            assert.are.same(HOME_PATH .. '/' .. TEST_FILE, link:absolute_path())
        end)

        it('returns correct abs path for project-relative path', function ()
            local link = ParsedLink.new(LinkTextFake.new(TEST_FILE), abs_paths)

            assert.are.same(PROJECT_PATH .. '/' .. TEST_FILE, link:absolute_path())
        end)

        it('returns correct abs path for current file related path', function ()
            local link = ParsedLink.new(LinkTextFake.new('./' .. TEST_FILE), abs_paths)

            assert.are.same(CURRENT_FILE_PATH .. '/' .. TEST_FILE, link:absolute_path())
        end)

        it('returns empty string for incorrect link', function ()
            local link = ParsedLink.new(LinkTextFake.new(''), abs_paths)

            assert.are.same('', link:absolute_path())
        end)

        it('returns full url with anchor for web link', function ()
            local link = ParsedLink.new(LinkTextFake.new(SECURE_URL .. '#some-anchor'), abs_paths)

            assert.are.same(SECURE_URL .. '#some-anchor', link:absolute_path())
        end)

        it('returns url for web link without anchor', function ()
            local link = ParsedLink.new(LinkTextFake.new(SECURE_URL), abs_paths)

            assert.are.same(SECURE_URL, link:absolute_path())
        end)
    end)

    describe('anchor_search_pattern()', function ()
        it('returns empty string for link without anchor', function ()
            local link = ParsedLink.new(LinkTextFake.new(TEST_FILE), abs_paths)

            assert.are.same('', link:anchor_search_pattern())
        end)

        it('returns empty string for link with empty anchor', function ()
            local link = ParsedLink.new(LinkTextFake.new(TEST_FILE .. '#'), abs_paths)

            assert.are.same('', link:anchor_search_pattern())
        end)

        it('returns empty string for web link', function ()
            local link = ParsedLink.new(LinkTextFake.new(SECURE_URL), abs_paths)

            assert.are.same('', link:anchor_search_pattern())
        end)

        it('returns empty string for web link with anchor', function ()
            local link = ParsedLink.new(LinkTextFake.new(SECURE_URL .. '#some-anchor'), abs_paths)

            assert.are.same('', link:anchor_search_pattern())
        end)

        it('returns search pattern for existing anchor', function ()
            local link = ParsedLink.new(LinkTextFake.new(TEST_FILE .. '#' .. ANCHOR), abs_paths)

            assert.are.same(PATTERN, link:anchor_search_pattern())
        end)
    end)

    describe('internal_file_link()', function ()
        it('returns truth for a link with only anchor and without path', function ()
            local link = ParsedLink.new(LinkTextFake.new('#' .. ANCHOR), abs_paths)

            assert.is_true(link:internal_file_link())
        end)

        it('returns false for a link only with path', function ()
            local link = ParsedLink.new(LinkTextFake.new(TEST_FILE), abs_paths)

            assert.is_false(link:internal_file_link())
        end)

        it('returns false for a link with both path and anchor', function ()
            local link = ParsedLink.new(LinkTextFake.new(TEST_FILE .. '#' .. ANCHOR), abs_paths)

            assert.is_false(link:internal_file_link())
        end)

        it('returns false for invalid link', function ()
            local link = ParsedLink.new(LinkTextFake.new(''), abs_paths)

            assert.is_false(link:internal_file_link())
        end)

        it('returns false for web link', function ()
            local link = ParsedLink.new(LinkTextFake.new(SECURE_URL .. '#some-anchor'), abs_paths)

            assert.is_false(link:internal_file_link())
        end)
    end)

    describe('external_file_link()', function ()
        it('returns false for invalid link', function ()
            local link = ParsedLink.new(LinkTextFake.new(''), abs_paths)

            assert.is_false(link:external_file_link())
        end)

        it('returns false for link with anchor only', function ()
            local link = ParsedLink.new(LinkTextFake.new('#' .. ANCHOR), abs_paths)

            assert.is_false(link:external_file_link())
        end)

        it('returns false for web link', function ()
            local link = ParsedLink.new(LinkTextFake.new(SECURE_URL), abs_paths)

            assert.is_false(link:external_file_link())
        end)

        it('returns true for link with path', function ()
            local link = ParsedLink.new(LinkTextFake.new(TEST_FILE), abs_paths)

            assert.is_true(link:external_file_link())
        end)

        it('returns true for link with path and anchor', function ()
            local link = ParsedLink.new(LinkTextFake.new(TEST_FILE .. '#' .. ANCHOR), abs_paths)

            assert.is_true(link:external_file_link())
        end)
    end)

    describe('web_link()', function ()
        it('returns false for non-web link', function ()
            local link = ParsedLink.new(LinkTextFake.new(TEST_FILE), abs_paths)

            assert.is_false(link:web_link())
        end)

        it('returns false for empty web link', function ()
            local link = ParsedLink.new(LinkTextFake.new('http://'), abs_paths)

            assert.is_false(link:web_link())
        end)

        it('returns false for incorrectly formatted web link', function ()
            local link = ParsedLink.new(LinkTextFake.new('http://bla'), abs_paths)

            assert.is_false(link:web_link())
        end)

        it('returns true for http web link', function ()
            local link = ParsedLink.new(LinkTextFake.new('http://site.com'), abs_paths)

            assert.is_true(link:web_link())
        end)

        it('returns true for secure http web link', function ()
            local link = ParsedLink.new(LinkTextFake.new(SECURE_URL), abs_paths)

            assert.is_true(link:web_link())
        end)
    end)
end)
