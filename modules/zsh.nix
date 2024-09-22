{ pkgs, vars, ... }:

{
  home-manager.users.${vars.user} = {
    programs = {
      starship.enable = true;
      thefuck.enable = true;
      zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        history.size = 10000;
        oh-my-zsh = {
          enable = true;
          plugins = [
            "gh"
            "git"
            "emoji"
            "docker"
            "fd"
            "rust"
            "starship"
            "thefuck"
            "zoxide"
          ];
          custom = "$HOME/.config/zsh_nix/custom";
          extraConfig = '''';
        };
        shellAliases = {
          ".." = "cd ..";
          "2.." = "cd ../..";
          "3.." = "cd ../../..";
          "4.." = "cd ../../../..";
          "5.." = "cd ../../../../..";
          "cl" = "_cl() { cd \"$@\" && ls };_cl";
          "zl" = "_zl() { z \"$@\" && ls };_zl";
          "v" = "nvim .";
        };
        initExtra = ''
          LESS=-IR

          export LS_COLORS="$(vivid generate catppuccin-macchiato)"

          # eza aliases
          eza_params=(
            '--git' '--icons' '--group' '--group-directories-first'
            '--time-style=long-iso' '--color-scale=all'
          )
          alias ls='eza $eza_params'
          alias l='eza --git-ignore $eza_params'
          alias ll='eza --all --header --long $eza_params'
          alias llm='eza --all --header --long --sort=modified $eza_params'
          alias la='eza -lbhHigUmuSa'
          alias lx='eza -lbhHigUmuSa@'
          alias lt='eza --tree $eza_params'
          alias tree='eza --tree $eza_params'

          # zsh vi mode
          ZVM_INIT_MODE=sourcing
          ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
          ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
          ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
          ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
          source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

          # Faster paste
          # https://github.com/zsh-users/zsh-autosuggestions/issues/238#issuecomment-389324292
          pasteinit() {
          OLD_SELF_INSERT=''${''${(s.:.)widgets[self-insert]}[2,3]}
            zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
          }
          pastefinish() {
            zle -N self-insert $OLD_SELF_INSERT
          }
          zstyle :bracketed-paste-magic paste-init pasteinit
          zstyle :bracketed-paste-magic paste-finish pastefinish

          # fzf colorscheme: Catppuccin Macchiato
          export FZF_DEFAULT_COMMAND="fd --type file --follow"
          export FZF_DEFAULT_OPTS="
            --height 40%
            --bind 'ctrl-j:down'
            --bind 'ctrl-k:up'
            --bind 'ctrl-d:half-page-down'
            --bind 'ctrl-u:half-page-up'
            --bind 'ctrl-f:page-down'
            --bind 'ctrl-b:page-up'
            --bind 'ctrl-/:change-preview-window(down|hidden|)'
            --bind 'alt-j:preview-down'
            --bind 'alt-k:preview-up'
            --bind 'alt-d:preview-half-page-down'
            --bind 'alt-u:preview-half-page-up'
            --bind 'alt-f:preview-page-down'
            --bind 'alt-b:preview-page-up'
            --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796
            --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6
            --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"
          export FZF_CTRL_T_COMMAND="fd --type file --follow"
          export FZF_CTRL_T_OPTS="
            --walker-skip .git,node_modules,target
            --preview 'bat -n --color=always {}'"
          export FZF_CTRL_R_OPTS="
            --preview 'echo {}' --preview-window up:3:hidden:wrap
            --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
            --color header:italic
            --header 'Press CTRL-Y to copy command into clipboard'"
          export FZF_ALT_C_OPTS="
            --walker-skip .git,node_modules,target
            --preview 'eza -T -L=2 --icons=always --color=always {}'"
        '';
      };
    };
  };
}
