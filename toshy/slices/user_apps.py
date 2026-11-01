

# Managed by ~/.dotfiles/toshy/slices/user_apps.py and written here by
# toshy/install.sh; edit the dotfiles copy, changes made here are overwritten.
# Keymaps here come before Toshy's own, so they win.

keymap("User hardware keys", {
    # PUT UNIVERSAL REMAPS FOR HARDWARE KEYS HERE
    # KEYMAP WILL BE ACTIVE IN ALL DESKTOP ENVIRONMENTS/DISTROS


}, when = lambda ctx:
    cnfg.screen_has_focus and
    not ctx_app_is_remote
)

# Cmd+1…9 → tab 1…9. Toshy passes Cmd+<digit> to terminals as Ctrl+<digit>
# (Ghostty binds those, see ghostty/linux-keybinds.conf), but the VTE
# terminals use Alt+1…9 by default, so send that instead.
hmp_is_term_vte_alt_tabs = matchProps(
    clas="^(.*Ptyxis.*|org\\.gnome\\.Terminal|gnome-terminal.*|org\\.gnome\\.Console|kgx)$")
keymap("User terminals: Cmd+digit tabs", {
    C(f"RC-{n}"): C(f"Alt-{n}") for n in range(1, 10)
}, when = lambda ctx:
    cnfg.screen_has_focus and
    hmp_is_term_vte_alt_tabs(ctx)
)

