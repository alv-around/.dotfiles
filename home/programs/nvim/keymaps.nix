_inputs: {
  programs.nvf.settings.vim = {
    binds.whichKey = {
      enable = true;
      register = {
        "<leader>d" = "Debug";
        "<leader>fg" = "Search Neogit";
        "<leader>g" = "Goto/Neogit";
        "<leader>l" = "LSP";
        "<leader>o" = "Obsidian";
        "<leader>ol" = "Obsidian Links";
        "<leader>of" = "Obsidian Pickers";
      };
      setupOpts = {
        icons = {
          # valid colors: azure, blue, cyan, green, grey, orange, purple, red, yellow
          rules = [
            {
              pattern = "debug";
              icon = "";
              color = "red";
            }
            {
              pattern = "goto";
              icon = " ";
              color = "green";
            }
            {
              pattern = "neogit";
              icon = "󰊢 ";
              color = "orange";
            }
            {
              pattern = "obsidian";
              icon = "󰇈";
              color = "purple";
            }
          ];
        };
      };
    };

    keymaps = [
      # Snacks picker keymaps. For more functionalities check:
      {
        key = "<leader><space>";
        mode = "n";
        lua = true;
        action = ''function() Snacks.picker.smart({ignored = false}) end'';
        desc = "Find Files (Root Dir)";
      }
      {
        key = "<leader>ff";
        mode = "n";
        lua = true;
        action = ''function() Snacks.picker.smart() end'';
        desc = "Find Files (Root Dir) [ALL]";
      }
      {
        key = "<leader>/";
        mode = "n";
        lua = true;
        action = "function() Snacks.picker.grep() end";
        desc = "Grep (Root Dir)";
      }
      {
        key = "<leader>,";
        mode = "n";
        lua = true;
        action = "function() Snacks.picker.buffers() end";
        desc = "Buffers";
      }
      {
        key = "<leader>;";
        mode = "n";
        lua = true;
        action = "function() Snacks.picker.command_history() end";
        desc = "Command History";
      }
      # TODO: currently this is not returning any result
      {
        key = "<leader>n";
        mode = "n";
        lua = true;
        action = "function() Snacks.picker.notifications() end";
        desc = "Notification History";
      }
      # LSP
      {
        key = "<space>gd";
        mode = "n";
        lua = true;
        action = "function() Snacks.picker.lsp_definitions() end";
        desc = "Goto Definition";
      }
      {
        key = "<space>gD";
        mode = "n";
        lua = true;
        action = "function() Snacks.picker.lsp_declarations() end";
        desc = "Goto Declarations";
      }
      {
        key = "<space>gr";
        mode = "n";
        lua = true;
        action = "function() Snacks.picker.lsp_references() end";
        desc = "References";
      }
      {
        key = "<space>gI";
        mode = "n";
        lua = true;
        action = "function() Snacks.picker.lsp_implementations() end";
        desc = "Goto Implementations";
      }
      {
        key = "<space>gy";
        mode = "n";
        lua = true;
        action = "function() Snacks.picker.lsp_type_definitions() end";
        desc = "Goto T[y]pe Definition";
      }
      {
        key = "<space>ss";
        mode = "n";
        lua = true;
        action = "function() Snacks.picker.lsp_symbols() end";
        desc = "LSP Symbols";
      }
      # Neotree
      {
        key = "<space>e";
        mode = "n";
        action = "<cmd>Neotree toggle<CR>";
        desc = "Toggle Neotree (RootDir)";
      }
      # Bufferline
      {
        key = "<space>bl";
        mode = "n";
        action = "<cmd>BufferLineCloseLeft<CR>";
        desc = "Delete all buffers to the left";
      }
      {
        key = "<space>br";
        mode = "n";
        action = "<cmd>BufferLineCloseRight<CR>";
        desc = "Delete all buffers to the right";
      }
      {
        key = "<space>bo";
        mode = "n";
        action = "<cmd>BufferLineCloseOthers<CR>";
        desc = "Delete all other buffers";
      }
      {
        key = "<space>bp";
        mode = "n";
        action = "<cmd>BufferLineTogglePin<CR>";
        desc = "Pin current buffer";
      }
    ];
  };
}
