local json = require('daily_symbols_count.json')

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
--- @param file_path string
--- @return integer
function utils.getTodayCount(file_path)
    local today = os.date(DATE_FORMAT)
    local fileContent = utils.readFileIfExist(file_path)

    if fileContent == nil then
        return 0
    end

    if fileContent[today] == nil then
        return 0
    end

    return fileContent[today]
end

-- Prints daily inserted symbols count
-- @param file_path string
function utils.printDailySymbols(file_path)
    utils.writeCountToFile({file_path=file_path})
    local count = utils.getTodayCount(file_path)
    print("Today is " .. count .. " symbols!")
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
function utils.writeCountToFile(opts)
    local file_path = opts.file_path
    local content = utils.readFileIfExist(file_path)
    local today = os.date(DATE_FORMAT)
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
