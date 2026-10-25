{ inputs, ... }:
{
  flake.modules.nixos.servnix-hardware = { modulesPath, ... }: {
    imports = [
      (modulesPath + "/profiles/qemu-guest.nix")
      inputs.disko.nixosModules.disko
    ];

    boot.initrd.availableKernelModules = [
      "ata_piix"
      "sd_mod"
      "sr_mod"
      "virtio_pci"
      "virtio_scsi"
      "virtio_blk"
    ];
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Confirmed on servnix: 40 GB primary disk, UEFI firmware.
    disko.devices.disk.main = {
      type = "disk";
      device = "/dev/sda";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              # Older installer images can finish settling before this link exists.
              preCreateHook = ''
                udevadm wait --timeout=120 /dev/disk/by-partlabel/disk-main-ESP
              '';
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              preCreateHook = ''
                udevadm wait --timeout=120 /dev/disk/by-partlabel/disk-main-root
              '';
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
