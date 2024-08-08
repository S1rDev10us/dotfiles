const hyprland = await Service.import("hyprland");
import type { Monitor } from "types/service/hyprland";
import { Bar } from "widgets/bar/index";

const bars = {};

App.config({
  style: "./style.css",
});

function addMonitor(monitor: number) {
  if (bars[monitor]) return;
  bars[monitor] = Bar(monitor);
  App.addWindow(bars[monitor]);
}
function removeMonitor(monitor: number) {
  if (!bars[monitor]) {
    console.warn(
      "Warning! monitor was removed but the bar for it does not exist",
    );
    return;
  }
  App.removeWindow(bars[monitor]);
  bars[monitor] = undefined;
}

for (const monitor of hyprland.monitors) {
  addMonitor(monitor.id);
}

hyprland.connect("monitor-added", (_, monitor: Monitor) =>
  addMonitor(monitor.id),
);
hyprland.connect("monitor-removed", (_, monitor: Monitor) =>
  removeMonitor(monitor.id),
);
