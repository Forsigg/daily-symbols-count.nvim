local Path = require('plenary.path')
local utils = require('daily-symbols-count.utils')
local mock = require('luassert.mock')


describe("test readFileIfExist", function()
    it('file exist and fully', function()
        local path = Path:new('./tests/test_data/file.json'):absolute()
        local result = utils.readFileIfExist(path)

        assert.same(result, { test = "test" })
    end)

    it('file not exist', function()
        local path = Path:new('./tests/test_data/not_existing.json'):absolute()
        local result = utils.readFileIfExist(path)

        assert.same(result, nil)
    end)
end)

describe("test getTodayCount", function()
    it('success', function()
        local test_opts = {
            file_path = Path:new('./tests/test_data/count_file.json'):absolute(),
            date_format = "%Y%m%d"
        }
        local os_mock = mock(os, true)
        os_mock.date.returns("19700101")
        local result = utils.getTodayCount(test_opts)

        assert.same(result, 10)

        mock.revert(os_mock)
    end)

    it('today is zero symbols', function()
        local test_opts = {
            file_path = Path:new('./tests/test_data/count_file.json'):absolute(),
            date_format = "%Y%m%d"
        }
        local result = utils.getTodayCount(test_opts)

        assert.same(result, 0)
    end)

    it('file not exists', function()
        local test_opts = {
            file_path = Path:new('./tests/test_data/random_count_file.json'):absolute(),
            date_format = "%Y%m%d"
        }
        local result = utils.getTodayCount(test_opts)

        assert.same(result, 0)
    end)
end)

describe("test createStatsFile", function ()
    it('success', function ()
        local path = Path:new('./tests/test_data/testStat.json')
        local pathStr = path:absolute()

        utils.createStatsFile(pathStr)

        assert(path:exists())
        assert(path:is_file())

        path:rm()
    end)
end)
