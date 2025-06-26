# extracts a list of tool names & versions from a devShell
devShell:
let
  tools = builtins.filter (d: d.name != "source") devShell.nativeBuildInputs;
  toolToItem = d: {
    name = if d ? meta.mainProgram then d.meta.mainProgram else d.name;
    value = {
      name = d.name;
      version = if d ? version then d.version else "unknown";
      changelog = if d ? meta.changelog then d.meta.changelog else "unknown";
      description = if d ? meta.description then d.meta.description else "unknown";
      homepage = if d ? meta.homepage then d.meta.homepage else "unknown";
    };
  };
in
builtins.listToAttrs (builtins.map toolToItem tools)
