{ ... }:
{
  flake.modules.nixos.nvidia =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.my.hardware.nvidia;
    in
    {
      options.my.hardware.nvidia.enable = lib.mkEnableOption "NVIDIA dGPU support";

      config = lib.mkIf cfg.enable {
        # Enable graphics acceleration (OpenGL, Vulkan, etc.)
        hardware.graphics.enable = true;

        # Load NVIDIA proprietary driver
        services.xserver.videoDrivers = [ "nvidia" ];

        # Use NVIDIA's open-source kernel modules (supported on Turing+, RTX 3060 is Ampere)
        hardware.nvidia.open = true;

        # Required for Wayland compositors (niri)
        hardware.nvidia.modesetting.enable = true;

        # PRIME Offload: iGPU renders by default, dGPU on demand via `nvidia-offload`
        hardware.nvidia.prime = {
          offload.enable = true;
          offload.enableOffloadCmd = true;

          intelBusId = "PCI:0@0:2:0";
          nvidiaBusId = "PCI:1@0:0:0";
        };

        # Preserve VRAM state across suspend/resume to avoid graphical corruption
        hardware.nvidia.powerManagement.enable = true;

        # Fine-grained power management: fully powers down dGPU when idle (Turing+)
        hardware.nvidia.powerManagement.finegrained = true;

        # Use the stable driver package
        hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
    };
}
