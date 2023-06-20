{
  description = "ptx project";
 
  nixConfig.extra-experimental-features = "nix-command flakes ca-references";

  outputs = { self }: {
    templates = {
      full = {
        path = ./full;
        description = "A template for a full project with barebox/kernel/proj and bsp";
        welcomeText = ''
          You just created a new project!

          Welcome to hell!
        '';
      };
    };

    defaultTemplate = self.templates.full;
  };
}
