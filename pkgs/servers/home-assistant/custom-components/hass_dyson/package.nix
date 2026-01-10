{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  libdyson-rest,
}:

buildHomeAssistantComponent rec {
  owner = "cmgrayb";
  domain = "hass_dyson";
  version = "0.26.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "hass-dyson";
    tag = "v${version}";
    hash = "sha256-g9lM046nZ9pv0yxL9GPTriU1SYbVAISLIF2z9K5nsTw=";
  };

  dependencies = [
    libdyson-rest
  ];

  meta = {
    changelog = "https://github.com/cmgrayb/hass-dyson/releases/tag/v${version}";
    description = "Home Assistant custom integration for Wi-Fi connected Dyson devices";
    homepage = "https://github.com/cmgrayb/hass-dyson";
    maintainers = with lib.maintainers; [ graham33 ];
    license = lib.licenses.mit;
  };
}
