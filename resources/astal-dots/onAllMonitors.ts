import { App, Gdk } from "astal/gtk3";
export function onAllMonitors<TData>(
  initializer: (monitor: Gdk.Monitor) => TData,
  destructor: (monitor: Gdk.Monitor, data: TData) => void,
) {
  const data = new Map<Gdk.Monitor, TData>();

  // initialize
  for (const gdkmonitor of App.get_monitors()) {
    data.set(gdkmonitor, initializer(gdkmonitor));
  }

  App.connect("monitor-added", (_, gdkmonitor) => {
    if (data.has(gdkmonitor)) return;

    data.set(gdkmonitor, initializer(gdkmonitor));
  });

  App.connect("monitor-removed", (_, gdkmonitor) => {
    let monitorData = data.get(gdkmonitor);
    if (monitorData != undefined) destructor(gdkmonitor, monitorData);

    data.delete(gdkmonitor);
  });
}
