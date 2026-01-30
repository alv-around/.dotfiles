_inputs: {
  programs.nvf.settings.vim = {
    notes = {
      todo-comments.enable = true;

      obsidian = {
        enable = true;
        setupOpts = {
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
        action = "<cmd>ObsidianNew<cr>";
        desc = "New Note";
      }
      {
        key = "<leader>oe";
        mode = "n";
        action = "<cmd>ObsidianExtractNote<cr>";
        desc = "Create Note from selection";
      }
      {
        key = "<leader>ow";
        mode = "n";
        action = "<cmd>ObsidianWorkspace<cr>";
        desc = "Switch to another workspace";
      }
      {
        key = "<leader>ot";
        mode = "n";
        action = "<cmd>ObsidianNewFromTemplate<cr>";
        desc = "New Note from template";
      }
      # pickers
      {
        key = "<leader>o<space>";
        mode = "n";
        action = "<cmd>ObsidianQuickSwitch<cr>";
        desc = "Notes Picker";
      }
      {
        key = "<leader>o/";
        mode = "n";
        action = "<cmd>ObsidianSearch<cr>";
        desc = "Grep Notes";
      }
      {
        key = "<leader>oft";
        mode = "n";
        action = "<cmd>ObsidianTags<cr>";
        desc = "Picker Notes by tag";
      }
      {
        key = "<leader>ofl";
        mode = "n";
        action = "<cmd>ObsidianLinks<cr>";
        desc = "Picker for links in current buffer";
      }
      {
        key = "<leader>ofb";
        mode = "n";
        action = "<cmd>ObsidianBacklinks<cr>";
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

    # TODO: move whichKey to its own file
    binds.whichKey = {
      register = {
        "<leader>o" = "Obsidian";
        "<leader>ol" = "Obsidian Links";
        "<leader>of" = "Obsidian Pickers";
      };
    };
  };
}
