import Popup from "widgets/popup";
import MediaControls from "./media";

export const QuickMenu = () =>
  Popup(
    "quick-menu",
    [false, false, true, true],
    Widget.Box({ vertical: true }, MediaControls()),
  );
export const ToggleQuickMenu = () => App.ToggleWindow("quick-menu");

export default QuickMenu;
