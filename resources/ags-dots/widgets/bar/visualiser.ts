import { cavaBarCount } from "params";
import Cava from "services/cava";

export const Visualiser = () =>
  Widget.Box({
    className: "visualiser",
    children: Array.from({ length: cavaBarCount }).map((_) =>
      Widget.Box({ className: "barElement" }),
    ),
    setup(self) {
      self.hook(Cava, (self) => {
        self.children.forEach((bar, i) => {
          bar.css = `
                  margin-top:${(1 - (Cava.bars[i] ?? 1)) * 32}pt;
                `;
        });
      });
    },
  });
