import Gtk from "types/@girs/gtk-3.0/gtk-3.0";
interface Padding {
  topPadding?: boolean;
  rightPadding?: boolean;
  bottomPadding?: boolean;
  leftPadding?: boolean;
}
const Padding = (
  name: string,
  hexpand: boolean = true,
  vexpand: boolean = true,
) =>
  Widget.EventBox({
    hexpand,
    vexpand,
    // For some reason apparently only frames can have a min-width? https://stackoverflow.com/a/33840289
    child: new Gtk.Frame({}),
    className: "popup-padding",
    onPrimaryClick: () => {
      App.toggleWindow(name);
    },
  });
const Layout = (name: string, padding: Padding, child: Gtk.Widget) =>
  Widget.Box({
    vertical: true,
    children: [
      Padding(name, false, padding.topPadding),
      Widget.Box(
        [
          Padding(name, padding.leftPadding, false),
          child,
          Padding(name, padding.rightPadding, false),
        ].filter((x) => !!x),
      ),
      Padding(name, false, padding.bottomPadding),
    ].filter((x) => !!x),
  });

function toPadding(
  padding: Padding | [boolean, boolean, boolean, boolean],
): Padding {
  if (!Array.isArray(padding)) {
    return padding;
  }
  return {
    topPadding: padding[0],
    rightPadding: padding[1],
    bottomPadding: padding[2],
    leftPadding: padding[3],
  };
}

export const Popup = (
  name: string,
  padding: Padding | [boolean, boolean, boolean, boolean],
  child: Gtk.Widget,
) => {
  return Widget.Window({
    name,
    classNames: [name, "popup-window"],
    visible: false,
    child: Layout(name, toPadding(padding), child),
    layer: "top",
    anchor: ["top", "right", "bottom", "left"],
  });
};
export default Popup;
