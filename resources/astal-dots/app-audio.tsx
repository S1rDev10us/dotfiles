import { App, Astal } from "astal/gtk3";
import style from "./style.scss";
import { onAllMonitors } from "./onAllMonitors";
import { Visualiser } from "./widget/Visualiser";
const { TOP, BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor;

App.start({
  css: style,
  main() {
    onAllMonitors(
      (monitor) => (
        <window
          css="background-color: transparent;"
          layer={Astal.Layer.BOTTOM}
          height_request={200}
          gdkmonitor={monitor}
          anchor={BOTTOM | LEFT | RIGHT}
        >
          <Visualiser />
        </window>
      ),
      (_, win) => win.destroy(),
    );
  },
});
