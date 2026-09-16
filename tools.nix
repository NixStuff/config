{lib, ...}:
with lib; let
  contextModuleImport = {
    imports,
    subfolder,
    context,
    currentDirPath,
    ...
  } @ deps:
    map (file:
      (import ./${currentDirPath}/${subfolder}/${file}.nix {
        inherit (deps) inputs config lib pkgs-list tools;
        parentPathAsList = deps.currentPathAsList;
      }).config.${
        context
      })
    imports;

  inheritance = {
    settings = {
      currentPathAsList,
      imports,
      settings,
    }: let
      first = lists.last (lists.take 1 currentPathAsList);
    in
      builtins.listToAttrs (map (setting: {
          name =
            if (currentPathAsList == [])
            then setting
            else first;
          value =
            if (currentPathAsList == [])
            then settings.${setting}
            else
              (inheritance.settings {
                currentPathAsList = lists.drop 1 currentPathAsList;
                imports = imports;
                settings = settings;
              });
        })
        imports);
    config = {
      currentPathAsList,
      config,
    }: let
      first = lists.last (lists.take 1 currentPathAsList);
    in
      if (currentPathAsList == [])
      then config
      else
        inheritance.config {
          currentPathAsList = lists.drop 1 currentPathAsList;
          config = config.${first};
        };
    options = {
      currentPathAsList,
      options,
    }: let
      first = lists.last (lists.take 1 currentPathAsList);
    in (listToAttrs [
      {
        name = first;
        value =
          if (currentPathAsList == [first])
          then options
          else
            inheritance.options {
              currentPathAsList = lists.drop 1 currentPathAsList;
              inherit options;
            };
      }
    ]);
  };

  contextualModule = {
    options ? null,
    specialOptions ? null,
    imports ? null,
    specialImports ? null,
    togglable ? true,
    Config,
    context,
    ...
  } @ deps: {
    lib,
    config,
    ...
  }: let
    inherit (deps) subfolder tools currentPathAsList lib config pkgs-list currentDirPath inputs;
  in
    (
      if options != null
      then {
        options =
          inheritance.options {
            inherit currentPathAsList options;
          }
          // (
            if specialOptions != null
            then
              if builtins.hasAttr context specialOptions
              then specialOptions
              else {}
            else {}
          );
      }
      else {
      }
    )
    // (
      if imports != null
      then {
        imports =
          contextModuleImport {
            inherit imports subfolder tools currentPathAsList lib config pkgs-list currentDirPath inputs;
            context = context;
          }
          ++ (
            if specialImports != null
            then
              if builtins.hasAttr context specialImports
              then specialImports.${context}
              else []
            else []
          );
      }
      else
        (
          if specialImports != null
          then {
            imports =
              if builtins.hasAttr context specialImports
              then specialImports.${context}
              else [];
          }
          else {
          }
        )
    )
    // {
      config =
        if togglable
        then (mkIf deps.cfg.enable Config)
        else Config;
    };

  moduleParams = {
    config,
    lib,
    pkgs-list,
    parentPathAsList,
    tools,
    name,
    togglable ? true,
    subfolder ? null,
    main-repo ? null, # pas sur que ce soit necessaire plus j'y reflechis.
    branch ? null, # pas sur que ce soit necessaire plus j'y reflechis.
    imports ? null,
    specialImports ? null,
    options ? null,
    specialOptions ? null,
    settings ? null,
    extras ? null,
  }: rec {
    inherit config lib pkgs-list parentPathAsList tools;
    inherit name togglable subfolder main-repo branch imports specialImports options specialOptions settings extras;
    packages =
      if main-repo != null && branch != null
      then pkgs-list.${main-repo}.${branch}
      else null;
    currentPathAsList = parentPathAsList ++ [name];
    currentDirPath = path.subpath.join (lists.flatten ["./." parentPathAsList]);
    cfg = inheritance.config {
      inherit config currentPathAsList;
    };
    inheritedSettings =
      if imports != null || settings != null
      then
        inheritance.settings {
          inherit currentPathAsList imports settings;
        }
      else {
      };
    Common =
      inheritedSettings
      // {
      };
  };
  fullModule = {
    config,
    lib,
    pkgs-list,
    parentPathAsList,
    tools,
    name,
    togglable ? true,
    subfolder ? null,
    main-repo ? null, # pas sur que ce soit necessaire plus j'y reflechis.
    branch ? null, # pas sur que ce soit necessaire plus j'y reflechis.
    imports ? null,
    specialImports ? null,
    options ? null,
    specialOptions ? null,
    settings ? null,
    extras ? null,
    packages ? null,
    currentPathAsList,
    currentDirPath,
    cfg,
    inheritedSettings,
    Common,
    Home ? {},
    System ? {},
  }: let
    HomeConfig = Common // Home;
    SystemConfig = Common // System;
  in {
    config = {
      Home = contextualModule {
        inherit lib config tools; # deps
        inherit subfolder currentPathAsList pkgs-list cfg currentDirPath; # generated
        inherit imports options; # user defined
        inherit specialImports specialOptions; # user defined
        inherit togglable; # user defined
        context = "Home";
        Config = HomeConfig;
      };
      System = contextualModule {
        inherit lib config tools; # deps
        inherit subfolder currentPathAsList pkgs-list cfg currentDirPath; # generated
        inherit imports options; # user defined
        inherit specialImports specialOptions; # user defined
        inherit togglable; # user defined
        context = "System";
        Config = SystemConfig;
      };
    };
  };

  ifEnabled = config: configPathString: value: let
    pathAsList = splitString "." configPathString;
    name = lists.last pathAsList;
    parentPathAsList = lists.drop 1 (lists.reverseList (lists.drop 1 (lists.reverseList pathAsList)));
    parentPath = attrsets.getAttrFromPath parentPathAsList config;
    configPath = attrsets.getAttrFromPath (lists.drop 1 pathAsList) config;
    modulePath = configPath.enable;
    emptyValue =
      if isString value
      then ""
      else if isList value
      then []
      else {};
  in
    if parentPath.enable && builtins.hasAttr name parentPath && modulePath
    then value
    else emptyValue;

  loop = {
    forInAttrSet = attrset: {};
    forInList = list: result: affected:
      list.forEach (element: result element);
  };

  forInLoop = attrset:
    element {
    };

  forCounterLoop = iterated: counter: max: result: affected: {
    forInList = iterated: result: affected:
      iterated.forEach (element: result element counter);
  };

  vscode = rec {
    fuse = profile1: profile2: {
      keybindings =
        (
          if profile1 ? keybindings
          then profile1.keybindings
          else []
        )
        ++ (
          if profile2 ? keybindings
          then profile2.keybindings
          else []
        );
      extensions =
        (
          if profile1 ? extensions
          then profile1.extensions
          else []
        )
        ++ (
          if profile2 ? extensions
          then profile2.extensions
          else []
        );
      userSettings =
        lib.attrsets.recursiveUpdate
        (
          if profile1 ? userSettings
          then profile1.userSettings
          else {}
        )
        (
          if profile2 ? userSettings
          then profile2.userSettings
          else {}
        );
    };
    namedFuse = name: profile1: profile2: {
      "${name}" = vscode.fuse profile1 profile2;
    };
    combine = {
      pair = profile_set1: profile_set2: let
        first_name = lists.head (builtins.attrNames profile_set1);
        second_name = lists.head (builtins.attrNames profile_set2);
        first = profile_set1.${first_name};
        second = profile_set2.${second_name};
      in {
        "${first_name} + ${second_name}" = vscode.fuse first second;
      };
      multiple = profile_set_list: let
        copy_list = profile_set_list;
        profile_list = profile_set_list.forEach (profile_set: builtins.attrsToList profile_set);
        first_profile_set = lists.head profile_list;
        second_profile_set = lists.head (lists.drop 1 profile_list);
        rest_profile_set_list = lists.drop 2 copy_list;
        combined_first_second = vscode.combinePair first_profile_set second_profile_set;
      in
        if (length profile_list == 2)
        then combined_first_second
        else vscode.combinePair combined_first_second (vscode.combineMultiple rest_profile_set_list);
      full = {};
    };
    combinePair = profile_set1: profile_set2: let
      first_name = lists.head (builtins.attrNames profile_set1);
      second_name = lists.head (builtins.attrNames profile_set2);
      first = profile_set1.${first_name};
      second = profile_set2.${second_name};
    in {
      "${first_name} + ${second_name}" = vscode.fuse first second;
    };

    combineMultiple = profile_set_list: let
      copy_list = profile_set_list;
      profile_list = profile_set_list.forEach (profile_set: builtins.attrsToList profile_set);
      first_profile_set = lists.head profile_list;
      second_profile_set = lists.head (lists.drop 1 profile_list);
      rest_profile_set_list = lists.drop 2 copy_list;
      combined_first_second = vscode.combinePair first_profile_set second_profile_set;
    in
      if (length profile_list == 2)
      then combined_first_second
      else vscode.combinePair combined_first_second (vscode.combineMultiple rest_profile_set_list);

    finishCombination = profile_set: root: let
      profile = builtins.head (builtins.attrValues profile_set);
      name = builtins.head (builtins.attrNames profile_set);
    in
      namedFuse "${name}" root profile;

    generate = {
      basics = base: basicsSet: let
        profilesList = builtins.attrsToList profilesSet;
      in
        listToAttrs (profilesList.forEach (profile: {
          name = profile.name;
          value = fuse base profile.value;
        }));

      profiles = base: basicsSet: combinationsSet: let
        combinationsList = builtins.attrsToList combinationsSet;
        basicsList = builtins.attrsToList basicsSet;
        defaultList = builtins.attrsToSet {default = base;};
        profilesList = defaultList ++ combinationsList ++ basicsList;
      in
        listToAttrs profilesList;
    };
  };
in {
  inherit inheritance contextModuleImport contextualModule moduleParams fullModule ifEnabled vscode;
}
