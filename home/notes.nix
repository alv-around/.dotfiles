{
  config,
  pkgs,
  lib,
  ...
}: let
  PRIV_OBSIDIAN_VAULT = "${config.home.homeDirectory}/notes/personal";
in {
  # Ensure the directory exists (Home Manager won't clone the repo,
  # but it ensures the mount point is ready)
  home.file."notes/personal/.keep".text = "";

  # 4. Reuse the variable in your systemd sync service
  systemd.user.services.obsidian-sync = {
    Unit = {Description = "Auto-sync Obsidian Vault";};
    Service = {
      # The Nix variable ${PRIV_OBSIDIAN_VAULT} evaluates directly into the bash command
      ExecStart = pkgs.writeShellScript "sync-obsidian" ''
        # Set up the path so we don't have to write out the full path for every command
        export PATH=${pkgs.git}/bin:${pkgs.coreutils}/bin:$PATH

        cd ${PRIV_OBSIDIAN_VAULT}

        git pull --rebase
        git add .

        # Only commit if there are actually changes to commit
        if ! git diff-index --quiet HEAD; then
          # $(date ...) dynamically injects the current timestamp
          git commit -m "Auto-sync: $(date +'%Y-%m-%d %H:%M:%S')"
        fi

        git push
      '';
      Type = "oneshot";
    };
  };

  systemd.user.timers.obsidian-sync = {
    Timer = {
      OnCalendar = "19:00";
      persistent = true;
    };
    Install = {WantedBy = ["timers.target"];};
  };

  programs.nvf.settings.vim = {
    # enforce that code is unfolded when opened
    options = {
      foldlevelstart = 99;
    };

    languages = {
      markdown = {
        enable = true;
        extensions.markview-nvim.enable = true;
      };

      typst.enable = true;
    };

    notes = {
      todo-comments.enable = true;
      obsidian = {
        enable = true;
        setupOpts = {
          legacy_commands = false;
          workspaces = [
            {
              name = "personal";
              path = PRIV_OBSIDIAN_VAULT;
            }
          ];

          templates = {
            folder = "1.templates";
          };

          ## TODO: define `attachmets.img_folder` default dir where images are store
          # attachments.img_folder = "assets/imgs";

          # name note as prompted, taken from: https://github.com/epwalsh/obsidian.nvim?tab=readme-ov-file#configuration-options
          note_id_func = lib.mkLuaInline ''
            function(title)
              -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
              -- In this case a note with the title 'My new note' will be given an ID that looks
              -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
              local suffix = ""
              if title ~= nil then
                -- If title is given, transform it into valid file name.
                suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
              else
                -- If title is nil, just add 4 random uppercase letters to the suffix.
                for _ = 1, 4 do
                  suffix = suffix .. string.char(math.random(65, 90))
                end
              end
              return tostring(os.time()) .. "-" .. suffix
            end
          '';
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
