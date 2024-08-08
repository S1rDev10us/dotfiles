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

const stripTitleEndings = [" - NVIM", " — Mozilla Firefox"];
function mapTitle(title: string) {
  for (const titleEnding of stripTitleEndings) {
    if (title.toLowerCase().endsWith(titleEnding.toLowerCase())) {
      title = title.substring(0, title.length - titleEnding.length).trim();
    }
  }
  return title;
}

const MAX_TITLE_LENGTH = 150;
const UNKNOWN_APP_ICON = Utils.lookUpIcon(
  "application-x-executable",
  128,
)?.load_icon();

export const AppTitle = () =>
  Widget.Box({
    setup: (self) => {
      self.toggleClassName("windowTitle", true);
    },
    hpack: "center",
    visible: hyprland.active.client
      .bind("class")
      .as((clientClass) => clientClass.length != 0),
    children: [
      Widget.Icon({}).hook(hyprland.active.client, (self) => {
        let client = hyprland.active.client;
        let classIcon = Utils.lookUpIcon(getIconFromClass(client.class), 128);
        let titleIcon = Utils.lookUpIcon(getIconFromTitle(client.title), 128);

        self.visible = true;
        if (titleIcon) {
          self.icon = titleIcon.load_icon();
        } else if (classIcon) {
          self.icon = classIcon.load_icon();
        } else {
          if (UNKNOWN_APP_ICON) {
            self.icon = UNKNOWN_APP_ICON;
          } else {
            self.visible = false;
          }
        }
      }),
      Widget.Label({
        label: hyprland.active.client.bind("title").as((title) => {
          title = mapTitle(title);
          return title.length <= MAX_TITLE_LENGTH
            ? title
            : title.substring(0, MAX_TITLE_LENGTH - 1) + "…";
        }),
      }),
    ],
  });
export default AppTitle;
