{ pkgs, compiler }:
let
  lib = pkgs.lib;

  util = import ./util.nix {
    inherit pkgs;
    inherit (pkgs) lib gitignoreFilter;
  };

  conf = lib.importTOML ../nixkell.toml;

  ghcVersion = if compiler != null then compiler else conf.ghc;

  # Create our own setup using our choosen GHC version as a starting point
  ourHaskell = pkgs.haskell.packages.${("ghc" + util.removeChar "." ghcVersion)}.override {
    overrides =
      let
        depsFromDir = pkgs.haskell.lib.packagesFromDirectory {
          directory = ./packages;
        };
        manual = _hfinal: hprev: {
          aoc2022 =
            let
              filteredSrc = util.filterSrc ../. {
                ignoreFiles = conf.ignore.files;
                ignorePaths = conf.ignore.paths;
              };
            in
            hprev.callCabal2nix "aoc2022" filteredSrc { };
        };
      in
      lib.composeExtensions depsFromDir manual;
  };

  # Add our package with its dependencies to GHC
  ghc = ourHaskell.ghc.withPackages (_ps:
    pkgs.haskell.lib.getHaskellBuildInputs ourHaskell.aoc2022
  );

  # NB. If HLS is present in the list of tools we ensure
  # that it is compiled with the correct GHC version.
  tools =
    let
      hls = "haskell-language-server";
      hasHLS = ps: util.has hls ps || util.has ("haskellPackages." + hls) ps;
      removeHLS = ps: util.remove hls (util.remove ("haskellPackages." + hls) ps);
    in
    if hasHLS conf.env.tools
    then map util.getDrv (removeHLS conf.env.tools) ++ [ ourHaskell.haskell-language-server ]
    else map util.getDrv conf.env.tools;

  scripts = import ./scripts.nix { inherit pkgs; };
in
{
  bin = util.leanPkg ourHaskell.aoc2022;

  shell = pkgs.buildEnv {
    name = "aoc2022-env";
    paths = [ ghc ] ++ tools ++ scripts;
  };
}
