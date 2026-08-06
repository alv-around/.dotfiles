{
  config,
  pkgs,
  ...
}: {
  # 1. Install ONLY pgAdmin
  home.packages = with pkgs; [
    pgadmin4-desktopmode
  ];

  # 2. Run pgAdmin in the background
  systemd.user.services.pgadmin4-local = {
    Unit = {
      Description = "pgAdmin 4 Standalone Background Service";
      After = ["network.target"];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.pgadmin4-desktopmode}/bin/pgadmin4";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
