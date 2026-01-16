describe('UrlJump', function ()
    local UrlJump = require('jumps.url_jump')
    local NvimUiApiFake = require('nvim_ui_api_fake')

    local URL = 'https://website.com'

    describe(':class_name()', function ()
        it('returns correct class name', function ()
            local jump = UrlJump.new()
            assert.are.equal('UrlJump', jump:class_name())
        end)
    end)

    describe(':to_external_app()', function ()
        it('always returns TRUE since URL is opened by external browser', function ()
            local jump = UrlJump.new()
            assert.is_true(jump:to_external_app())
        end)
    end)

    describe(':within_current_file()', function ()
        it('always returns FALSE since jump is to outside of current file', function ()
            local jump = UrlJump.new()
            assert.is_false(jump:within_current_file())
        end)
    end)

    describe(':go()', function ()
        it('opens URL in external app', function ()
            local api = NvimUiApiFake.new()
            local jump = UrlJump.new(URL, api)

            jump:go()

            assert.are.equals(URL, api:opened_url())
        end)
    end)
end)
