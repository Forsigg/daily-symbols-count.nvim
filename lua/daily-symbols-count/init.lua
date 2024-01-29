local M = {}

local utils = require('daily-symbols-count.utils')

local myGroup = vim.api.nvim_create_augroup('DailySymbolsGroup', { clear = true })


DEFAULT_STATS_PATH = vim.fn.stdpath('data') .. '/chars_count.json'
DEFAULT_DATE_FORMAT = "%d/%m/%Y"
COUNT = 0


-- Setup function for plugin
--- @param opts table
---      stat_file_path - string (path to statistics file to be stored)
function M.setup(opts)
    local user_settings = opts or {}
    local statFilePath = DEFAULT_STATS_PATH
    local dateFormat = DEFAULT_DATE_FORMAT

    if user_settings.stat_file_path then
        statFilePath = user_settings.stat_file_path .. '/chars_count.json'
    end

    if user_settings.date_format then
        dateFormat = user_settings.date_format
    end

    utils.initStatFile(statFilePath)

    local writeFileOpts = {
        file_path = statFilePath,
        date_format = dateFormat
    }

    -- Add autocommand for increasing symbols count
    vim.api.nvim_create_autocmd(
        "InsertCharPre",
        {
            pattern = { "*.lua" },
            callback = function()
                COUNT = COUNT + 1
            end,
            group = myGroup
        }
    )

    -- Add autocommand for writing statistics file after close vim
    vim.api.nvim_create_autocmd(
        "VimLeave",
        {
            pattern = { "*" },
            callback = function()
                utils.writeCountToFile(writeFileOpts)
            end,
            group = myGroup
        }
    )

    -- Add command for printing daily symbols count
    -- :PrintDailySymbols
    vim.api.nvim_create_user_command(
        'PrintDailySymbols',
        function()
            utils.printDailySymbols(writeFileOpts)
        end,
        {
            desc="Print daily symbols count"
        }
    )

    -- Add command for printing all statistics file
    -- :PrintDailyStats
    vim.api.nvim_create_user_command(
        'PrintDailyStats',
        function ()
            print(vim.inspect(utils.readFileIfExist(writeFileOpts.file_path)))
        end,
        {
            desc="Print all stats file"
        }
    )
end

return M
