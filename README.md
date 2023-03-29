## Nix Flake for Onedriver
I am not particularily fond of the `onedrive` implementation from `nixpkgs`, which keeps corrupting my OneDrive files, creating duplicates and deleting files without my knowledge. Coming from Arch I used to use `onedriver` by [Jeff Stafford](https://github.com/jstaf) which worked much better.

As I am still rather new to Nix and NixOS it has taken me a bit to get this working, but now I can install `onedriver` via Nix / home-manager.

To do so, add this to your `flake.nix`:

```nix
{
  inputs = {
    onedriver.url = "github:padarom/onedriver-flake";
  };

  outputs = { onedriver, ... }:
  {
    # Set up the overlay (depending on the rest of your flake)
    overlays = [ onedriver.overlays.default ];

    # Use the nixosModule for home-manager (depending on how you configure your home-manager)
    home-manager.sharedModules = [ onedriver.nixosModules.default ];
  };
}
```

Within your home-manager configuration you can then enable the service.
```nix
{ lib, config, pkgs, ... }:

{
  services.onedriver = {
    enable = true;
    mountPoint = "$HOME/OneDrive";
  };
}
```

#### Note!
This being my first flake there are a lot of things I don't understand yet.

- The flake exports `onedriver` as a package, but I haven't been able to make the overlay work internally, such that the module references the correct `pkg.onedriver` that we export ourselves. That is why you even need to specify the overlay in your own flake in the first place. I haven't yet been able to fix this, but I assume there is a way to get this going without having the user of my flake enable the overlay manually.
- The flake is currently specific to home-manager. Is there a way to make it possible to specify all options system-wide or user-specific? Generally I assume OneDrive would be mounted user-specific, but not everyone uses home-manager.