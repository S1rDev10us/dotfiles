import type { MprisPlayer } from "types/service/mpris";

const mpris = await Service.import("mpris");

const Player = (player: MprisPlayer) =>
  Widget.Button({
    css: player
      .bind("track_cover_url")
      .as(
        (url) =>
          `background-image:url('${url}');background-size: cover;background-position:center;`,
      ),

    on_clicked: () => player.playPause(),
    label: player.bind("track_title"),
  });

export const Players = () =>
  Widget.Box({
    children: mpris.bind("players").as((players) => players.map(Player)),
  });
