profilesPath="$1";
defaultStatePath="$2";

find ${profilesPath} -maxdepth 1 -type d -print0 | while read -d $'\0' file
do
  if [[ "$file" != "." && "$file" != "$profilesPath" ]]; then
    mkdir -p "$file/globalStorage";
    if [ ! -f "$file/globalStorage/state.vscdb" ]; then
      cp $defaultStatePath "$file/globalStorage/state.vscdb";
    fi
  fi
done
