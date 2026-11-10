# Agrupa os nós do flake.lock por projeto de origem e lista os grupos com
# mais de um nó fora de $allowed. Canais e tarballs do nixpkgs contam como
# o mesmo projeto que github:nixos/nixpkgs.
def source:
  if .type == "github" or .type == "gitlab" then
    "\(.type):\(.owner | ascii_downcase)/\(.repo | ascii_downcase)"
  else
    (.url // .path // tostring) | sub("\\?.*$"; "") | sub("\\.tar\\.[a-z]+$"; "")
  end
  | if test("^github:nixos/nixpkgs$|/nixexprs$") then "nixpkgs" else . end;

. as $lock
| def input_paths($prefix; $node):
    ($lock.nodes[$node].inputs // {})
    | to_entries[]
    | select(.value | type == "string")
    | ($prefix + [.key]) as $path
    | { path: ($path | join("/")), source: ($lock.nodes[.value].original | source) },
      input_paths($path; .value);
[input_paths([]; $lock.root)]
| group_by(.source)[]
| select(map(select(.path as $path | $allowed | has($path) | not)) | length > 1)
| "  \(.[0].source): \(map(.path) | join(", "))"
