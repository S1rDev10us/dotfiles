const hyprland = await Service.import("hyprland");

export const changeWorkspace = (ws: number | string) =>
  hyprland.messageAsync(`dispatch workspace ${ws}`);

export const Workspaces = () =>
  Widget.EventBox({
    onScrollUp: () => changeWorkspace("+1"),
    onScrollDown: () => changeWorkspace("-1"),
    "class-names": ["workspaces"],
    child: Widget.Box({
      children: Array.from({ length: 10 }, (_, i) => i + 1).map((i) =>
        Widget.Button({
          hpack: "center",
          vpack: "center",
          attribute: i,
          child: Widget.Label({
            hpack: "center",
            vpack: "center",
            justification: "center",
            label: hyprland.active.workspace
              .bind("id")
              .as((workspaceId) =>
                workspaceId != i
                  ? hyprland.getWorkspace(i)?.name || i.toString()
                  : "",
              ),
          }),
          onClicked: () => changeWorkspace(i),
          setup: (self) =>
            self.hook(hyprland, () => {
              self.toggleClassName("active", hyprland.active.workspace.id == i);
              self.toggleClassName(
                "hasWindows",
                (hyprland.getWorkspace(i)?.windows || 0) > 0,
              );
            }),
        }),
      ),
    }),
  });
export default Workspaces;
