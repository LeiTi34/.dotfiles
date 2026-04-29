{ ... }:
{
  profiles.primaryUser = {
    name = "alex";
    homeDirectory = "/home/alex";
    homeModule = ../../users/alex/home.nix;
  };
}
