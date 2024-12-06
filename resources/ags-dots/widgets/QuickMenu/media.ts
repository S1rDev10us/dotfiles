import Gtk from "gi://Gtk?version=3.0";
import type { MprisPlayer } from "types/service/mpris";

const mpris = await Service.import("mpris");

export const PlayerIcon = (player: MprisPlayer) =>
  Widget.Icon({
    className: "media-icon",
    icon: Utils.merge(
      [player.bind("track_cover_url"), player.bind("cover_path")],
      (url, path) => path || url,
    ),
  });

const PlayerControls = (player: MprisPlayer) =>
  Widget.Box(
    {},
    Widget.Button({
      visible: player.bind("can_go_prev"),
      on_clicked: () => player.previous(),
      child: Widget.Icon("media-skip-backward"),
    }),
    Widget.Button({
      on_clicked: () => player.playPause(),
      child: Widget.Icon({
        icon: player
          .bind("play_back_status")
          .as((status) =>
            status == "Playing"
              ? "media-playback-pause"
              : "media-playback-start",
          ),
      }),
    }),
    Widget.Button({
      visible: player.bind("can_go_next"),
      on_clicked: () => player.next(),
      child: Widget.Icon("media-skip-forward"),
    }),
  );

function formatSeconds(seconds: number) {
  const durations = [60, 60, 24];
  let formattedString = "";
  for (let i = 0; i < durations.length; i++) {
    const duration = durations[i];

    let currentDurationSeconds = `${seconds % duration}`;

    formattedString = `${currentDurationSeconds.padStart(2, "0")}${formattedString}`;

    seconds = Math.trunc(seconds / duration);

    if (seconds < 1) break;

    if (i != durations.length - 1) {
      formattedString = `:${formattedString}`;
    }
  }
  return formattedString;
}

const Player = (player: MprisPlayer) =>
  Widget.Box(
    {},
    PlayerIcon(player),
    Widget.CenterBox({
      vertical: true,
      startWidget: Widget.Box(
        {},
        Widget.Label({
          justification: "center",
          label: player.bind("track_title"),
          wrapMode: 2,
          maxWidthChars: 45,
          wrap: true,
        }),
      ),
      centerWidget: Widget.Slider({
        value: player.bind("position"),
        max: player.bind("length"),
        drawValue: false,
        on_change(self, _) {
          player.position = self.value;
        },
      }).poll(1000, (self) => {
        if (player.play_back_status != "Playing") return;

        self.value = player.position;
      }),

      endWidget: Widget.CenterBox({
        startWidget: Widget.Label({
          label: player.bind("position").as((pos) => formatSeconds(pos)),
          visible: player.bind("length").as((length) => length > 0),
        }).poll(1000, (self) => {
          if (player.play_back_status != "Playing") return;

          self.label = formatSeconds(player.position);
        }),
        centerWidget: PlayerControls(player),
        endWidget: Widget.Label({
          label: player.bind("length").as((length) => formatSeconds(length)),
          visible: player.bind("length").as((length) => length > 0),
        }).poll(10000, (self) => {
          self.label = formatSeconds(player.length);
        }),
      }),
    }),
  );

export const MediaControls = () =>
  Widget.Box<Gtk.Widget>({
    className: "background media-controls",
    vertical: true,
    children: mpris
      .bind("players")
      .as((players) =>
        players.length > 0
          ? players.map(Player)
          : [Widget.Label("No media playing")],
      ),
  });

export default MediaControls;
