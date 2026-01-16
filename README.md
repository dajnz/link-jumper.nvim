# Link-jumper.nvim

The plugin allows you to jump to various types of links and navigate back through jump history using a couple of hotkeys. Unlike [follow-md-links.lua](https://github.com/jghauser/follow-md-links.nvim) it support all type of files and jumps history. Link-jumper.nvim uses a link notation similar to Markdown.


## Supported link types

Links that handled by Neovim, jumps for all the links are saved in jump history:
- Absolute path links (`[link](/my/file.md)`), that open specified file in the same window and split;
- Absolute path links with in-file references (`[link](/my/file.md#my-reference)`), the same as above, but also searches in a target file a text defined after `#`. It matches spaces or dashes as word separators, so `#my-reference` will match both `my reference` and `my-reference`. Case insensitive;
- Absolute path links with specific line number (`[link](/my/file.md#777)`), the same as regular absolute path links, but also move cursor to the specified line if possible;
- Relative path links of different types: relative to a file with a link (`[link](./file.md)`) and (`[link](../file.md)`), relative to a current project directory (`[link](some/path/to/file.md)`), relative to home directory (`[link](~/some/path/to/file.md)`). All the links also support line numbers and references as described above;
- Same file references (`[link](#my-reference)`) search reference text within the current file. If more than one match found, you can iterate by the matches back and forth with the regular hotkeys (`n` or `N`).

Links that handled by an external app (e.g.: web browser), these link jumps are not saved in jump history:
- URL links (`[link](https://website.com)`), support both `http` and `https` and open in system's default browser.


## Installation

Lazy.nvim:
```
{
    'dajnz/link-jumper.nvim',
}
```


## Configuration and settings

You can customize plugin hotkeys. By default it uses `<leader>lj` for jump and `<leader>lb` to go back in jump history.

```
keys = {
    { '<leader>lj', '<cmd>LinkJumperJump<cr>', desc = 'Jump to the link under the cursor' },
    { '<leader>lb', '<cmd>LinkJumperGoBack<cr>', desc = 'Return back in jump history' },
}

```

## Contributing

1. `Docker` and `Make` are required;
2. Create testing Docker images with the command `make build-images` from the plugin directory;
3. Ensure all tests are green with the command `make test`, otherwise please create an issue;
4. Covering your code with tests is required, except for e2e tests for external app jumps.


## Credits

Thanks to the author and contributors of the [UTF8 Lua library](https://github.com/Stepets/utf8.lua), that is used in the plugin
