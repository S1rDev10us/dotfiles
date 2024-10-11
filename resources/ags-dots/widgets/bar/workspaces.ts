const hyprland = await Service.import("hyprland");

export const changeWorkspace = (ws: number | string) =>
  hyprland.messageAsync(`dispatch workspace ${ws}`);

export const Workspaces = () =>
  Widget.EventBox({
    onScrollUp: () => changeWorkspace("+1"),
    onScrollDown: () => changeWorkspace("-1"),
    "class-names": ["workspaces"],
    child: Widget.Box(
      Array.from({ length: 10 }, (_, i) => i + 1).map((i) =>
        Widget.EventBox({
          hpack: "center",
          vpack: "center",
          attribute: i,
          child: Widget.Box({
            child: hyprland.active.workspace
              .bind("id")
              .as((currentActiveWorkspace) => {
                let workspaceActive = currentActiveWorkspace == i;

                if (!workspaceActive && i == 9) {
                  return Widget.Icon({
                    icon: Utils.lookUpIcon("phone")!.load_icon(),

                    hpack: "center",
                    vpack: "center",
                  });
                }

                return Widget.Label({
                  hpack: "center",
                  vpack: "center",
                  justification: "center",
                  label: workspaceActive
                    ? ""
                    : hyprland.getWorkspace(i)?.name || i.toString(),
                });
              }),
          }),
          onPrimaryClick: () => changeWorkspace(i),
          setup: (self) => {
            self.hook(hyprland, () => {
              self.toggleClassName("active", hyprland.active.workspace.id == i);
              self.toggleClassName(
                "hasWindows",
                (hyprland.getWorkspace(i)?.windows || 0) > 0,
              );
            });
          },
        }),
      ),
    ),
  });
export default Workspaces;
