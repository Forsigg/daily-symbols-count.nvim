# Daily symbols count plugin for neovim

This is a plugin, that count your inserted symbols (in insert mode) and collect statistics by day. 
Its my first plugin for neovim and I enjoy to share it

## Setup:
Install plugin by your favorite plugin manager (by example - Lazy)
```lua
require("lazy").setup({

    { 'forsigg/daily-symbols-count.nvim' },
    ...
})

```

```lua
local daily_symbols = require('daily-symbols-count')

daily_symbols.setup({
    -- Put path to future stats file
    -- by default if not set - ~/.local/share/nvim/chars_count.json
    stat_file_path = "/path/to/statfile",

    -- Put date format for stats
    -- by default if not set - %d/%m/%Y (ex. 01/01/2024)
    date_format = "%Y %d %m",

    -- Put file format for counting inserted symbols
    -- by default if not set - * (wildcard, all file formats)
    file_format = "*.lua"
})
```


## Usage

Plugin add two commands:

`:PrintDailySymbols` - printing daily inserted symbols

`:PrintDailyStats` - print whole stat file
