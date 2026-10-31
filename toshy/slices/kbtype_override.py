
# Managed by ~/.dotfiles/toshy/slices/kbtype_override.py and written here by
# toshy/install.sh; edit the dotfiles copy, changes made here are overwritten.
#
# Logitech MX Mechanical Mini for Mac: Mac layout, Cmd next to the space bar.
# Its device name depends on how it's connected (Bluetooth, Bolt receiver),
# so besides these names, any input device whose name matches is added too.
# If Cmd and Option come out swapped, change 'Apple' to 'Windows'.
# Valid types: Apple, Windows, IBM, Chromebook (case sensitive)
keyboards_UserCustom_dct = {
    'MX Mechanical Mini for Mac':               'Apple',
    'Logitech MX Mechanical Mini for Mac':      'Apple',
    'MX MCHNCL M':                              'Apple',
    'MX MCHNCL M Keyboard':                     'Apple',
}

try:
    import re as _re
    with open('/proc/bus/input/devices') as _f:
        for _name in _re.findall(r'^N: Name="(.*)"$', _f.read(), _re.M):
            if _re.search(r'MX (Mechanical Mini|MCHNCL M)', _name, _re.I):
                keyboards_UserCustom_dct[_name] = 'Apple'
except OSError:
    pass

