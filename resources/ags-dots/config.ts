import Gdk from "types/@girs/gdk-3.0/gdk-3.0";
import { Bar } from "widgets/bar/index";
import QuickMenu from "widgets/QuickMenu/index";

const bars = {};

App.applyCss(App.configDir + "/style.css");
App.config({
  windows: () =>
    [
      Array.from(
        { length: Gdk.Display.get_default()?.get_n_monitors() ?? 0 },
        (_, i) => Bar(i),
      ),
      QuickMenu(),
    ].flat(),
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


