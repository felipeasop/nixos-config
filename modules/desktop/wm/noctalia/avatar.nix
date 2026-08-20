{ inputs, ... }: {
  den.aspects.noctalia = {
    homeManager = {
      home.file.".face".source = "${inputs.self}/assets/avatar/margarida.jpg";
    };
  };
}
