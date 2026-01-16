FROM link-jumper/unit-and-int-image

RUN apk add neovim \
    && git clone --depth 1 https://github.com/nvim-lua/plenary.nvim.git ~/.local/share/nvim/site/pack/my-plugins/start/plenary.nvim
