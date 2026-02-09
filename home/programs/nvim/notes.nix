_inputs: {
  programs.nvf.settings.vim = {
    autocmds = [
      {
        event = ["FileType"];
        pattern = ["markdown"];
        command = "setlocal conceallevel=2";
      }
    ];

    notes = {
      todo-comments.enable = true;

      obsidian = {
        enable = true;
        setupOpts = {
          ui.enable = true;
          legacy_commands = false;
          workspaces = [
            {
              name = "personal";
              path = "~/Code/research_vault";
            }
          ];
          templates = {
            folder = "1.templates";
          };
          ## TODO: define `attachmets.img_folder` default dir where images are store
          # attachments.img_folder = "assets/imgs";
        };
      };
    };

    keymaps = [
      # INFO: command docs: https://github.com/epwalsh/obsidian.nvim?tab=readme-ov-file#commands
      # INFO: ObsidiandRename was not included as it can make big changes to vault
      # TODO: missing ObsidianPasteImg, ObsidianToggleCheckBox, & ObsidianTOC
      {
        key = "<leader>on";
        mode = "n";
        action = "<cmd>Obsidian new<cr>";
        desc = "New Note";
      }
      {
        key = "<leader>oe";
        mode = "n";
        action = "<cmd>Obsidian extract_note<cr>";
        desc = "Create Note from selection";
      }
      {
        key = "<leader>ow";
        mode = "n";
        action = "<cmd>Obsidian workspace<cr>";
        desc = "Switch to another workspace";
      }
      {
        key = "<leader>ot";
        mode = "n";
        action = "<cmd>Obsidian new_from_template<cr>";
        desc = "New Note from template";
      }
      # pickers
      {
        key = "<leader>o<space>";
        mode = "n";
        action = "<cmd>Obsidian quick_switch<cr>";
        desc = "Notes Picker";
      }
      {
        key = "<leader>o/";
        mode = "n";
        action = "<cmd>Obsidian search<cr>";
        desc = "Grep Notes";
      }
      {
        key = "<leader>oft";
        mode = "n";
        action = "<cmd>Obsidian tags<cr>";
        desc = "Picker Notes by tag";
      }
      {
        key = "<leader>ofl";
        mode = "n";
        action = "<cmd>Obsidian links<cr>";
        desc = "Picker for links in current buffer";
      }
      {
        key = "<leader>ofb";
        mode = "n";
        action = "<cmd>Obsidian backlinks<cr>";
        desc = "Picker for Backlinks to current buffer";
      }
      # obsidian links
      {
        key = "<leader>olo";
        mode = "n";
        action = "<cmd>ObsidianFollowLink<cr>";
        desc = "Open Link in buffer";
      }
      # TODO: configure missing commands: ObsisidianLink, ObsidianLinkNew
      # TODO: missing daily notes: ObsidianYesterday/Today/Tomorro ..
    ];
  };
}
