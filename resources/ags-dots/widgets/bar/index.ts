import Workspaces from "./workspaces";
import AppTitle from "./appTitle";

const time = Variable(new Date(), {
  poll: [
    1000,
    function () {
      return new Date();
    },
  ],
});
export const Bar = (monitor: number) =>
  Widget.Window({
    monitor,
    name: `bar${monitor}`,
    anchor: ["top", "left", "right"],
    exclusivity: "exclusive",
    "class-names": ["bar"],
    child: Widget.CenterBox({
      start_widget: Widget.Box({
        class_name: "background panel",
        hpack: "start",
        child: Workspaces(),
      }),
      center_widget: AppTitle(),
      end_widget: Widget.Box({
        class_name: "background panel",
        hpack: "end",
        child: Widget.Label({
          label: time.bind().as((date) => date.toLocaleTimeString()),
          "tooltip-text": time.bind().as((date) => date.toLocaleDateString()),
        }),
      }),
    }),
  });
