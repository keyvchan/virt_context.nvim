# virt_context.nvim

Display treesitter context by using virtual text.
## Status
Currently worked on `end of line`, `top` is not yet possible due to https://github.com/keyvchan/virt_context.nvim/issues/1

## Setup
 
``` lua
require('virt-context').setup({
  enable = true    -- set it to false to disable
  position = "eol" -- top is not yet possible
})
```

## End of Line
Context followed by your cursor.

https://user-images.githubusercontent.com/28680236/164585176-29cf44f6-47d3-4658-af85-5eb75c20dfc0.mov


## Top
Not working

