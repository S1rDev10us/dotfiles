import { focusedTitle, Workspaces } from "./workspaces";

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
    "class-names": ["background", "bar"],
    child: Widget.CenterBox({
      start_widget: Workspaces(),
      center_widget: focusedTitle,
      end_widget: Widget.Label({
        label: time.bind().as((date) => date.toLocaleTimeString()),
        "tooltip-text": time.bind().as((date) => date.toLocaleDateString()),
      }),
    }),
  });
