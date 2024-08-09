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
          if (percent > MAX_BAT - 5) {
            icon += "full";
          } else if (percent > (MAX_BAT * 3) / 4) {
            icon += "good";
          } else if (percent > 25) {
            icon += "low";
          } else if (percent > 10) {
            icon += "caution";
          } else {
            icon += "empty";
          }

          if (charging) {
            icon += "-charging";
          }
          return icon;
        },
      ),
    }),
    visible: battery.bind("available"),
    value: battery.bind("percent").as((p) => (p > 0 ? p / MAX_BAT : 0)),
    class_name: battery.bind("charging").as((ch) => (ch ? "charging" : "")),
    tooltip_text: battery.bind("percent").as((percent) => percent + "%"),
  });
export default BatteryProgress;
