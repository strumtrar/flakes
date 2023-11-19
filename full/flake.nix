{
  description = "ptx project";
 
  nixConfig.extra-experimental-features = "nix-command flakes ca-references";

  inputs =
    {
      flake-parts.url = "github:hercules-ci/flake-parts";
      devshell.url = "github:numtide/devshell";
      haumea.url = "github:nix-community/haumea";
      labgridGit.url = "github:strumtrar/labgrid";
      labgridGit.flake = false;
    };

  outputs =
    inputs @{ self
            , nixpkgs
            , devshell
            , flake-parts
	    , labgridGit
            , haumea
            , ...
            }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ moduleWithSystem, ... }: {
      debug = true;
      systems = [ "x86_64-linux" ];
      imports = [
        devshell.flakeModule
      ];

      perSystem =
        { self'
        , inputs'
        , pkgs
        , ...
        }: {
	  packages = import ./pkgs {inherit pkgs; inherit inputs;};

          devshells.default = { pkgs, ... }: {
            packages = [
              pkgs.dt-schema
              pkgs.gum
              pkgs.ubootTools
              pkgs.gitFull
              pkgs.dtc
              pkgs.just
              pkgs.microcom
              pkgs.dos2unix
              self.packages.x86_64-linux.labgrid
              self.packages.x86_64-linux.umpf
              self.packages.x86_64-linux.ptx_dev_tools
            ];

	    env = [
	      { name = "PATH"; prefix = "scripts"; }
	      { name = "LG_USERNAME"; value = "str"; }
	      { name = "LG_CROSSBAR"; value = "ws://labgrid.red.stw.pengutronix.de:20408/ws"; }
	      { name = "LG_PROXY"; value = "dude02.red.stw.pengutronix.de"; }
	      { name = "PLATFORM"; eval = "$(echo $PRJ_ROOT | rev | cut -d. -f1 | rev)"; }
	      { name = "CUSTOMER"; eval = "$(basename -s .$PLATFORM $PRJ_ROOT)"; }
	      { name = "BAREBOX"; eval = "$PRJ_ROOT/worktree/barebox/$CUSTOMER.$PLATFORM"; }
	      { name = "KERNEL"; eval = "$PRJ_ROOT/worktree/kernel/$CUSTOMER.$PLATFORM"; }

	      ####################
	      # customize this -->
	      ####################

	      # arm64 or arm
	      { name = "ARCH"; value = "arm64"; }
	      { name = "HOSTNAME"; value = ""; }
	      # for Yocto machine overwriting; should be same as $PLATFORM otherwise
	      { name = "MACHINE"; eval = "$(echo $PLATFORM)"; }
	      { name = "KERNELIMAGE"; value = "arch/arm64/boot/Image"; }
	      { name = "DEVICETREE"; value = "arch/arm64/boot/dts/"; }
	      { name = "BAREBOXIMAGE"; value = "images/barebox-"; }
	      { name = "LG_PLACE"; value = ""; }
	      # if more than one consoles are exported by labgrid-place, specify which one to use
	      { name = "CONSOLE"; value = ""; }
	      { name = "TOOLCHAIN"; value = "oselas.toolchain-2023.07.0-aarch64-v8a-linux-gnu"; }
	      ####################
	      # <-- 
	      ####################

              { name = "DOCKERFILES"; value = "arm-multi"; }
	      { name = "TOOLCHAIN_VERSION"; eval = "$(echo $TOOLCHAIN | cut -d- -f2 | cut -d. -f1,2)"; }
	      { name = "PODMAN_CACHE"; eval = "$(echo 'build-env-arm-multi.oselas.toolchain-')$TOOLCHAIN_VERSION"; }
	    ];

            commands = [
              { help = "Run bitbake in podman container";
                name = "bitbake";
                command = "just compile-bsp $@";
                category = "BSP";
              }
     	      { help = "Run PTXDist in podman container";
		name = "ptxdist";
		command = "just ptxdist $@";
                category = "BSP";
	      }
     	      { help = "Compile barebox or kernel in podman";
		name = "compile";
		command = "just compile $@";
                category = "Development";
	      }
     	      { help = "Run menuconfig on project";
		name = "menuconfig";
		command = "just compile container menuconfig $@";
                category = "Development";
	      }
     	      { help = "Run labgrid-client with just-lg commands";
		name = "jl";
		command = "just -f $PRJ_ROOT/justfiles/just-lg $*";
                category = "Development";
	      }
     	      { help = "Run podman archive commands with just-podman commands";
		name = "jp";
		command = "just -f $PRJ_ROOT/justfiles/just-podman";
                category = "Development";
	      }
     	      { help = "Init project";
		name = "init";
		command = "for script in scripts/*; do chmod +x $script; done && git init && git commit --allow-empty -s -m 'initial commit'";
                category = "Setup";
	      }
     	      { help = "Switch mode";
		name = "mode";
		command = "echo 'export MODE=local\nexport MODE=remote' | gum filter > .mode && direnv allow .";
                category = "Setup";
	      }
            ];
          };
        };
    });
}
