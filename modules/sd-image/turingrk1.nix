{
  lib,
  config,
  rk3588,
  ...
}: let
  rootPartitionUUID = "14e19a7b-0ae0-484d-9d54-43bd6fdc20c7";
in {
  imports = [
    "${rk3588.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
  ];

  boot = {
    kernelParams = [
      "root=UUID=${rootPartitionUUID}"
      "rootfstype=ext4"
    ];

    loader = {
      grub.enable = lib.mkForce false;
      generic-extlinux-compatible.enable = lib.mkForce true;
    };
  };

  # add some missing deviceTree in armbian/linux-rockchip:
  # turing rk1's deviceTree in armbian/linux-rockchip:
  # https://github.com/armbian/linux-rockchip/tree/rk-6.1-rkr1/arch/arm64/boot/dts/rockchip/rk3588-turing-rk1.dts
  hardware = {
    deviceTree = {
      name = "rockchip/rk3588-turing-rk1.dts";
    };

    firmware = [];
  };

  sdImage = {
    inherit rootPartitionUUID;
    compressImage = true;

    # install firmware into a separate partition: /boot/firmware
    populateFirmwareCommands = ''
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./firmware
    '';
    # Gap in front of the /boot/firmware partition, in mebibytes (1024×1024 bytes).
    # Can be increased to make more space for boards requiring to dd u-boot SPL before actual partitions.
    firmwarePartitionOffset = 32;
    firmwarePartitionName = "BOOT";
    firmwareSize = 200; # MiB

    populateRootCommands = ''
      mkdir -p ./files/boot
    '';
  };
}
