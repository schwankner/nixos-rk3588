{stdenv}: let
  # Prebuilt u-boot for turing-rk1, built from Joshua-Riek/ubuntu-rockchip
  idbloader_img = ./linux-u-boot-legacy-turing-rk1/idbloader.img;
  u_boot_itb = ./linux-u-boot-legacy-turing-rk1/u-boot.itb;
in
  stdenv.mkDerivation {
    pname = "u-boot-prebuilt";
    version = "unstable-2024-11-01";

    buildCommand = ''
      install -Dm444 ${idbloader_img} $out/idbloader.img
      install -Dm444 ${u_boot_itb} $out/u-boot.itb
    '';
  }
