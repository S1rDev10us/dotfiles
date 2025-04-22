import Cava from "gi://AstalCava";

const cava = Cava.get_default()!;
cava.set_bars(30);
cava.set_framerate(40);

type Vec = [number, number];

const borderWidth = 10;
const fractionUsed = 0.75;

export const Visualiser = () => (
  <drawingarea
    vexpand
    hexpand
    setup={(self) => {
      self.hook(cava, "notify::values", (self) => self.queue_draw());
    }}
    onDraw={(self, cr) => {
      const width = self.get_allocated_width();
      const height = self.get_allocated_height();
      const fractionUsedInverse = 1 / fractionUsed;

      const barCount = cava.get_bars();

      const bars = cava.get_values();

      // https://www.cairographics.org/manual/cairo-cairo-t.html
      const barWidth = width / barCount;

      // Set colour
      cr.setSourceRGB(1, 1, 1);
      cr.moveTo(0, height);
      // cr.moveTo(width / 2, height / 2);

      for (let i = 0; i < bars.length; i++) {
        const barValue = bars[i];

        // Cairo is rendered Y down
        const barHeight =
          ((fractionUsedInverse - barValue) * height) / fractionUsedInverse +
          borderWidth / 2;

        // Draw smooth visualiser
        const endX = (i + 1) * barWidth;

        if (i == 0) cr.lineTo(0, barHeight);

        const pos = cr.getCurrentPoint();

        const posX = pos[0];
        const posY = pos[1];

        cr.curveTo(
          posX + barWidth / 2,
          posY,
          posX + barWidth / 2,
          barHeight,
          endX,
          barHeight,
        );
      }
      // Finish line and fill
      cr.lineTo(width, height);
      cr.fillPreserve();

      // Draw border
      cr.setLineWidth(borderWidth);
      cr.setSourceRGB(0.8, 0.8, 0.8);
      cr.stroke();
    }}
  ></drawingarea>
);
