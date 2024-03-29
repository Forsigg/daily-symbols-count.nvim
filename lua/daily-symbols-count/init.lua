local M = {}

local utils = require('daily-symbols-count.utils')

local myGroup = vim.api.nvim_create_augroup('DailySymbolsGroup', { clear = true })


DEFAULT_STATS_PATH = vim.fn.stdpath('data') .. '/chars_count.json'
DEFAULT_DATE_FORMAT = "%d/%m/%Y"
DEFAULT_FILE_PATTERN = "*"
COUNT = 0


-- Setup function for plugin
--- @param opts table
---      stat_file_path - string (path to statistics file to be stored)
---      date_format - string
---      file_pattern - string
function M.setup(opts)
    local user_settings = opts or {}
    local statFilePath = DEFAULT_STATS_PATH
    local dateFormat = DEFAULT_DATE_FORMAT
    local filePattern = DEFAULT_FILE_PATTERN

    if user_settings.stat_file_path then
        statFilePath = user_settings.stat_file_path .. '/chars_count.json'
    end

    if user_settings.date_format then
        dateFormat = user_settings.date_format
    end

    if user_settings.file_pattern then
        filePattern = user_settings.file_pattern
    end


    utils.initStatFile(statFilePath)

    local writeFileOpts = {
        file_path = statFilePath,
        date_format = dateFormat
    }

    M.opts = writeFileOpts

    -- Add autocommand for increasing symbols count
    vim.api.nvim_create_autocmd(
        "InsertCharPre",
        {
            pattern = { filePattern },
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
            pattern = { filePattern },
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

function M.get_stats_count()
    return utils.getTodayCount(M.opts)
end

return M
