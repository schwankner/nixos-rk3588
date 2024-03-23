# =========================================================================
#      Turing RK1 Specific Configuration
# =========================================================================
# Corresponding ububtu-rockchip turing rk board file as reference
# https://github.com/Joshua-Riek/ubuntu-rockchip/blob/main/config/boards/turing-rk1.conf

{rk3588, ...}: let
  pkgsKernel = rk3588.pkgsKernel;
in {
  imports = [
    ./base.nix
  ];

  boot = {
    kernelPackages = pkgsKernel.linuxPackagesFor (pkgsKernel.callPackage ../../pkgs/kernel/legacy.nix {});

    # kernelParams copy from Armbian's /boot/armbianEnv.txt & /boot/boot.cmd
    kernelParams = [
      "rootwait"

      "earlycon" # enable early console, so we can see the boot messages via serial port / HDMI
      "consoleblank=0" # disable console blanking(screen saver)
      "console=ttyS0,115200" # serial port
      "console=tty1" # HDMI

      # docker optimizations
      "cgroup_enable=cpuset"
      "cgroup_memory=1"
      "cgroup_enable=memory"
      "swapaccount=1"
    ];
  };

  # add some missing deviceTree in armbian/linux-rockchip:
  # turing rk1's deviceTree in armbian/linux-rockchip:
  #    https://github.com/armbian/linux-rockchip/blob/rk-5.10-rkr6/arch/arm64/boot/dts/rockchip/rk3588-turing-rk1.dts
  hardware = {
    deviceTree = {
      name = "rockchip/rk3588-turing-rk1.dtb";
      overlays = [];
    };

    firmware = [];
  };
}
