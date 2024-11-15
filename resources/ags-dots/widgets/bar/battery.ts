const battery = await Service.import("battery");

const MAX_BAT = 80;

export const BatteryProgress = () =>
  Widget.CircularProgress({
    child: Widget.Icon({
      icon: Utils.merge(
        [battery.bind("charging"), battery.bind("percent")],
        (charging, percent) => {
          let icon = "battery-";

          // I have battery set to max out at 80/79 percent to help with battery health so we respect that here
          const roundedPercent = Math.round(percent / 10);
          if (roundedPercent < 10) {
            // Needs to be 3 numbers long
            icon += "0";
          }
          // Add on battery value
          icon += roundedPercent;
          // Needs to be 3 numbers long
          icon += "0";

          if (charging) {
            icon += "-charging";
          }
          return icon;
        },
      ),
    }),
    rounded: true,
    css: battery.bind("percent").as((p) => {
      // https://www.desmos.com/calculator/dmjzf0tbvh
      let maxR = 238;
      let maxG = 238;

      let frac = p / MAX_BAT;

      let r = Math.min(2 * (1 - frac), 1) * maxR;
      let g = Math.min(2 * frac, 1) * maxG;
      let b = 0;

      return `color: rgb(${r},${g},${b});`;
    }),
    visible: battery.bind("available"),
    value: battery.bind("percent").as((p) => (p > 0 ? p / MAX_BAT : 0)),
    class_name: battery
      .bind("charging")
      .as((ch) => (ch ? "charging" : "") + " battery"),
    tooltip_text: battery.bind("percent").as((percent) => percent + "%"),
  });
export default BatteryProgress;
