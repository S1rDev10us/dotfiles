const battery = await Service.import("battery");

export const BatteryProgress = () =>
  Widget.CircularProgress({
    child: Widget.Icon({
      icon: battery.bind("icon_name").as((icon) => {
        const symbolic = "-symbolic";
        if (icon.endsWith(symbolic)) {
          icon = icon.substring(0, icon.length - symbolic.length);
        }
        return icon;
      }),
    }),
    visible: battery.bind("available"),
    value: battery.bind("percent").as((p) => (p > 0 ? p / 100 : 0)),
    class_name: battery.bind("charging").as((ch) => (ch ? "charging" : "")),
    tooltip_text: battery.bind("percent").as((percent) => percent + "%"),
  });
export default BatteryProgress;
