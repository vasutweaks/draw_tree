# draw_tree.nvim

A simple Neovim plugin to **draw tree structures** directly in your buffers using box-drawing characters.  
Toggle *tree mode* and press mnemonic keys to insert Unicode symbols like `│ └ ├ ┬ ┼ …` without memorizing digraphs.

---

## ✨ Features

- Toggleable *tree mode* (buffer-local).
- Single-key mappings for common box-drawing symbols.
- `:TreeModeToggle` to enable/disable tree mode.
- `:TreeHelp` to show all available keys and their symbols.
- Configurable key order and symbol mapping via `setup()`.

---

## 📦 Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "vasutweaks/draw_tree.nvim",
  config = function()
    require("draw_tree").setup()
  end
}
```

### Using packer.nvim

```lua
use {
  "vasutweaks/draw_tree.nvim",
  config = function()
    require("draw_tree").setup()
  end
}
```


### 🚀 Usage
Enter insert mode.

Press <leader>t (default toggle key) → tree mode ON.

While in tree mode, press the following single keys to insert symbols:


r → ├ 

v → │ 

l → └ 

z → ─

f → ┌ 

j → ┘ 

n → ┐ 

y → ┤

t → ┬  

b → ┴  

x → ┼


Example drawing:

root
├─ branch1
│  ├─ leaf1
│  └─ leaf2
└─ branch2
   ├─ leaf3
   └─ leaf4

Press <leader>t again → tree mode OFF (your keys behave normally).

## ⚙️ Configuration
You can override toggle key, key order, and symbol mapping:

```lua
require("draw_tree").setup({
  key = "<leader>t",  -- toggle key in insert mode
  key_order = { "r","v","l","z","f","j","n","y","t","b","x" },
  symbols = {
    r = "├", v = "│", l = "└", z = "─",
    f = "┌", j = "┘", n = "┐", y = "┤",
    t = "┬", b = "┴", x = "┼",
  },
})
```
key → toggle key (default <leader>t).

key_order → order in which help is printed.

symbols → mapping from single key → Unicode symbol.

## 📖 Commands
:TreeModeToggle — Toggle tree mode for current buffer.

:TreeHelp — Print current mappings and symbols.

## 🔧 Notes
Tree mode is buffer-local: enabling it in one buffer doesn’t affect others.

Default symbols follow an intuitive mnemonic scheme:

r = right branch (├),

v = vertical (│),

l = left corner (└),

z = horizontal (─),

f = top-left corner (┌),

j = bottom-right corner (┘),

n = top-right corner (┐),

y = vertical + left (┤),

t = T down (┬),

b = T up (┴),

x = cross (┼).

Works without dependencies. If you use a notification UI, you can adapt the echo function.

## 📸 Demo
Here’s a quick example of using tree mode in insert mode:

```bash
root
├─ animals
│  ├─ cat
│  └─ dog
└─ plants
   ├─ tree
   └─ flower
```
