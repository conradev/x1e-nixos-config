{ lib, fetchFromGitHub, buildLinux, linuxPackagesFor, fetchpatch, fetchurl, ... }:

linuxPackagesFor (buildLinux {
  src = fetchFromGitHub {
    owner = "conradev";
    repo = "linux";
    rev = "gb4e-6.12";
    hash = "sha256-CUt4J7IFS14qD8GiZOuSeJmFdbWOmmyV/iJNcTUVN5g=";
  };
  version = "6.12.0";
  defconfig = "johan_defconfig";

  structuredExtraConfig = with lib.kernel; {
    MAGIC_SYSRQ = yes;
  };

  kernelPatches = [
    {
      name = "drm/panic: Select ZLIB_DEFLATE for DRM_PANIC_SCREEN_QR_CODE";
      patch = fetchurl {
        url = "https://lore.kernel.org/linux-kernel/20241003230734.653717-1-ojeda@kernel.org/raw";
        hash = "sha256-qZTP9o0Pel9M1Y9f/31SZbOJxeM0j28P94EUXa83m+Q=";
      };
    }

    # RTC support
    {
      name = "rtc: pm8xxx: implement qcom,no-alarm flag for non-HLOS owned alarm";
      patch = fetchurl {
        url = "https://lore.kernel.org/linux-kernel/20241015004945.3676-2-jonathan@marek.ca/raw";
        hash = "sha256-+HoD4ggo4c6fNbUjQ0uCI8UDE4urd6XzHlodKm/5n5Y=";
      };
    }
    {
      name = "arm64: dts: qcom: x1e80100-pmics: enable RTC";
      patch = fetchurl {
        url = "https://lore.kernel.org/linux-kernel/20241015004945.3676-4-jonathan@marek.ca/raw";
        hash = "sha256-SxdyzwNzp5hnLmruic3tUCfATm7X4xIXgLwGF/Fj9uk=";
      };
    }
  ];
})
