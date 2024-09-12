import type { MprisPlayer } from "types/service/mpris";

const mpris = await Service.import("mpris");

const Player = (player: MprisPlayer) =>
  Widget.Box({
    children: [
      Widget.Button({
        on_clicked: () => player.previous(),
        child: Widget.Icon("media-skip-backward"),
      }),
      Widget.Button({
        on_clicked: () => player.playPause(),
        child: Widget.Box({
          children: [
            Widget.Icon({
              icon: player
                .bind("play_back_status")
                .as((status) =>
                  status == "Playing"
                    ? "media-playback-pause"
                    : "media-playback-start",
                ),
            }),
            Widget.Icon({
              className: "media-icon",
              icon: player
                .bind("track_cover_url")
                .as((url) => (url.startsWith("file://") ? url.slice(7) : url)),
            }),
            Widget.Label({ label: player.bind("track_title") }),
          ],
        }),
      }),
      Widget.Button({
        on_clicked: () => player.next(),
        child: Widget.Icon("media-skip-forward"),
      }),
    ],
  });

export const Players = () =>
  Widget.Box({
    className: "horizontal mediaPlayers",
    children: mpris.bind("players").as((players) => players.map(Player)),
  });
