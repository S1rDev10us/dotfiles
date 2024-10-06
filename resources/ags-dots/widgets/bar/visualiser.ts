import { cavaBarCount } from "params";
import Cava from "services/cava";

const smooth = Variable(true);

export const Visualiser = () =>
  Widget.Box(
    {},
    Widget.Switch({
      active: smooth.value,
      onActivate(self) {
        smooth.setValue(self.active);
      },
    }),

    Widget.DrawingArea({
      // Each half of a bar should have 3 "units"
      widthRequest: 2 * cavaBarCount * 3,

      // Force cr type to any because function definitions not appearing on Cairo.Context type
      drawFn(_self, cr: any, width, height) {
        // https://www.cairographics.org/manual/cairo-cairo-t.html
        const barWidth = width / cavaBarCount;

        const bars = Cava.bars;

        // Set colour
        cr.setSourceRGB(1, 1, 1);
        cr.moveTo(0, height);

        for (let i = 0; i < bars.length; i++) {
          const barValue = bars[i];

          // Cairo is rendered Y down
          const barHeight = (1 - barValue) * height;

          if (smooth.value) {
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
          } else {
            // Draw bar visualiser
            const startX = i * barWidth;

            // Move to height of bar
            cr.lineTo(startX, barHeight);

            // Top curve
            cr.arc(startX + barWidth / 2, barHeight, Math.PI, Math.PI, 0);
          }
        }
        // Finish line and fill
        cr.lineTo(width, height);
        cr.fill();
      },
      setup(self) {
        self.hook(Cava, (self) => {
          // Request a redraw when Cava updates
          self.queue_draw();
        });
      },
    }),
  );
