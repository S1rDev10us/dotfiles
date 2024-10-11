import type { MprisPlayer } from "types/service/mpris";
import { Visualiser } from "widgets/bar/visualiser";
import { PlayerIcon } from "widgets/QuickMenu/media";
import { ToggleQuickMenu } from "widgets/QuickMenu/index";

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
            PlayerIcon(player),
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
  Widget.EventBox(
    {
      onPrimaryClick(self) {
        ToggleQuickMenu();
      },
    },
    Widget.Overlay({
      child: Visualiser(),
    }),
  );
