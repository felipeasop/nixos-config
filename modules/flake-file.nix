{ inputs, lib, ... }: {
  flake-file.inputs = {
    flake-file.url = "github:denful/flake-file";
    den.url = "github:denful/den";
  };

  imports = [ inputs.flake-file.flakeModules.default ];

  # Preset "dendritic" = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; }
  # (inputs.import-tree ./modules) — é literalmente o outputs que este repo já
  # usava. O nome do preset não tem relação com o backend/módulo "dendritic";
  # é só como o flake-file chama essa receita de outputs específica.
  flake-file.outputs = lib.mkDefault "dendritic";
}
