const hyprland = await Service.import("hyprland");

function getIconFromClass(window: string) {
  window = window.toLowerCase();
  return window;
}
function getIconFromTitle(window: string) {
  window = window.toLowerCase();
  if (window.endsWith("nvim")) {
    return "nvim";
  }
  return window;
}

export const AppTitle = () =>
  Widget.Box({
    setup: (self) => {
      self.toggleClassName("windowTitle", true);
    },
    children: [
      Widget.Icon({}).hook(hyprland.active.client, (self) => {
        let client = hyprland.active.client;
        let classIcon = Utils.lookUpIcon(getIconFromClass(client.class), 128);
        let titleIcon = Utils.lookUpIcon(getIconFromTitle(client.title), 128);

        self.visible = classIcon != null || titleIcon != null;
        if (self.visible) {
          self.icon =
            titleIcon != null ? titleIcon.load_icon() : classIcon!.load_icon();
        }
      }),
      Widget.Label({
        label: hyprland.active.client.bind("title"),
        visible: hyprland.active.client.bind("address").as((addr) => !!addr),
      }),
    ],
  });
export default AppTitle;
