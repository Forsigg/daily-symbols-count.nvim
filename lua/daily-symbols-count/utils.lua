local json = require('daily-symbols-count.json')

local utils = {}
-- Read file if it exists
--- @param path string
--- @return table | nil
function utils.readFileIfExist(path)
    local file = io.open(path, 'r')
    if file == nil then
        return nil
    end
    local content = file:read('*a')
    file:close()
    local jsonContent = json.parse(content)
    return jsonContent
end


--- Get count of today inserted symbols
--- @param opts table
---      file_path string (path to file)
--       date_format string
--- @return integer
function utils.getTodayCount(opts)
    local today = os.date(opts.date_format)
    local fileContent = utils.readFileIfExist(opts.file_path)

    if fileContent == nil then
        return 0
    end

    if fileContent[today] == nil then
        return 0
    end

    return fileContent[today]
end

-- Prints daily inserted symbols count
-- @param opts table
--      file_path string (path to file)
--      date_format string
function utils.printDailySymbols(opts)
    -- utils.writeCountToFile(opts)
    local count = utils.getTodayCount(opts)
    print("Today is " .. count + COUNT .. " symbols!")
end


-- Create file with statistics of daily count
-- @param file_path string
function utils.createStatsFile(file_path)
    local file = io.open(file_path, 'w')
    if file == nil then
        print("Creating stat file...")
    end
    file:write(json.stringify({}))
    file:close()
end


-- Read statistics file or create it if not exists
-- @param file_path
function utils.initStatFile(file_path)
    local statsContent = utils.readFileIfExist(file_path)
    if statsContent == nil then
        utils.createStatsFile(file_path)
    end
end


-- Write symbols count to statistics file
-- @param opts table
--      file_path - string (path to statistics file to be stored)
--      date_format - string
function utils.writeCountToFile(opts)
    local file_path = opts.file_path
    local content = utils.readFileIfExist(file_path)
    local today = os.date(opts.date_format)
    if content[today] == nil then
        content[today] = COUNT
    else
        content[today] = content[today] + COUNT
    end

    local file = io.open(file_path, 'w')

    file:write(json.stringify(content))
    file:close()
end


return utils
