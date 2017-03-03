# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
menuselectors = {
    'atom-text-editor:not([mini])': {
        'command': 'symbols-view:go-to-declaration',
        'label': 'Goto Declaration (autocomplete-clang)',
    },
    'atom-text-editor': {
        'command': 'autocomplete-clang:go-declaration',
        'label': 'Goto Declaration (symbols-view)',
    },
}
contextmenus = atom.contextMenu.itemSets
renames = 0
finishedrenaming = false
for menu in contextmenus
    for menusel of menuselectors
        if menu.selector != menusel
            continue
        for item in menu.items
            menucmd = menuselectors[menusel].command
            if item.command != menucmd
                continue
            menulbl = menuselectors[menusel].label
            console.log('Context Menu: Rename ' + menucmd + ': ' + menulbl)
            item.label = menulbl
            renames += 1
            break
        if renames == menuselectors.length
            break
    if renames == menuselectors.length
        break

if renames
    console.log('Renamed context menus: ' + renames)
else
    console.error('Failed to rename any context menus!')
