[ x ] Make klassy configurable from nix file raw in klassy module
    [ x ] Win decorations
        [ x ] Implement parsing of Windeco section of config file
            [ ] SystemIconSize ? WTF (not essential)
        [ x ] Implement parsing of ButtonColors section of config file
            [ ] Manage ULTRA PERSONALIZATION (later)
        [ x ] Implement parsing of ButtonBehaviour section of config file
        [ x ] Implement parsing of ButtonSizing section of config file
        [ x ] Implement parsing of TitleBarSpacing section of config file
        [ x ] Implement parsing of TitleBarOpacity section of config file
        [ x ] WindowOutlineStyle section of config file
        [ x ] ShadowStyle section of config file
            [ x ] Define all options in menu
            [ x ] Find defaults
            [ x ] Implement parsing of ShadowStyle section of config file
        [ x ] Implement parsing of ShadowStyle section of config file
    [ x ] Windeco Exception
        [ x ] Defaults
        [ x ] Users
    [ x ] Style
        [ x ] Define all options in menu
        [ x ] Find defaults
            [ ] keyboard_accelerator_visibility (not that important)
            [ ] 
            windows_drag_mode (not that important)
        [ x ] Implement parsing of Style section of config file
    [ x ] Presets
        [ x ] Importing exising presets as files
        [ ] Creating presets from nix config files (later)
[ x ] Fix Nvidia
[ ] Make Dolphin a configurable module #Project
[ ] Fix plasma-manager Module #Project
    [ ] Separate monitor configuration from plasma configuration
    [ ] Allow nested paramaters in applets configuration
    [ ] Make system tray configuration more understandable
[ ] Pedro Plymouth
    [ x ] Enable plymouth on boot
    [ x ] Add pedro plymouth theme
    [ ] Optimize kernelParams
    [ ] Fix plymouth theme freezes and is not that smooth on boot.
[ ] Fixing icons missing in titlebar when as user
    [ ] Fixing icons missing in titlebar for office apps -> report to upstream
    [ ] Fixing icons missing in titlebar for virt-manager -> report to upstream
    [ x ] Fixing icons missing in titlebar for most apps
[ ] Fixing Gparted unlunchable from luncher
    [ x ] Trying to fix by mysef 
        [ x ] Adding to sudoers file
        [ x ] Adding sudo to command of launcher
    [ ] report to upstream
[ ] Adding "Open in VSCode" contexte menu
    [ ] In Dolphin
    [ ] In desktop
[ x ] Making fstab declarative
[ ] Making Bitwarden a configurable module #Project
[ ] Declare splash screen in nix file
[ ] NumLock on boot
    [ ] On SDDM
    [ x ] Once connected to plasma
[ ] Fixing sddm-kcm service not being detected
    [ x ] trying to fix by myself => Failure 
    [ x ] report to upstream
[ ] Reporting issue with plymouth-kcm (kplymouththemeinstaller[40024]: "Unable to authenticate/execute the action: 9, ")
[ ] Separate Kwrite from Kate in nixpkgs #Project
    [x] Learn how to contribute
    [x] Add a prebuildphase to kate to just add # in front of the line that point to kwrite for Kate
    [x] Create Kwrite package
    [x] Add a prebuildphase to Kwrite to just add # in front of the line that point to kate for Kwrite
    [ ] Waiting for PR approval and/or feedback
[ ] Fixing Klipper paste on click/selection #Project
[ ] Adding extensions to vscode #Project
    [x] danielatanasov.todo
    [x] prateekmahendrakar.prettyxml
    [x] zhiyuan-lin.simple-perl
    [x] joelkoz.nodeuml
    [x] Waiting for PR approval and/or feedback => not approved : too niche
    [ ] Adding it to my nur
[ ] Adding instructions for migrations 
    [ ] Writing a README.md
    [ ] Adding scripts
        [ ] kwallet migration
        [ ] wifi migration
        [ ] bluetooth migration
[ ] Browser
    [ ] Add a default browser setting to choose between firefox, chromium and zen
[ ] Yazi 
    [ ] Adding/fixing KDEConnect send
    [ ] Fixing + adding githead

[ ] Fixing VSCode state settings :
    [ ] Find a way to generate state.vscdb file for specific profiles
    [ ] Finding the exact setting to toggle for "Use AI features" to be enabled on launch