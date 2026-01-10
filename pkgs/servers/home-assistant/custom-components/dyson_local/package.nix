{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  libdyson-neon,
}:

buildHomeAssistantComponent rec {
  owner = "libdyson-wg";
  domain = "dyson_local";
  version = "1.5.7";

  src = fetchFromGitHub {
    inherit owner;
    repo = "ha-dyson";
    tag = "v${version}";
    hash = "sha256-V5RCepikTDrjZwi6MfRislpV2F9jR1MqwWxTq0GPBp4=";
  };

  dependencies = [
    libdyson-neon
  ];

  meta = {
    changelog = "https://github.com/libdyson-wg/ha-dyson/releases/tag/v${version}";
    description = "Home Assistant custom integration for Wi-Fi connected Dyson devices";
    homepage = "https://github.com/libdyson-wg/ha-dyson";
    maintainers = with lib.maintainers; [ graham33 ];
    license = lib.licenses.mit;
  };
}
