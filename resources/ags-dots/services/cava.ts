import { cavaBarCount, cava as cavaCommand } from "params";
import type Gio from "types/@girs/gio-2.0/gio-2.0";

export class Cava extends Service {
  static {
    Service.register(
      this,
      { "bars-changed": ["jsobject"] },
      { bars: ["jsobject", "r"] },
    );
  }
  #process: Gio.Subprocess | undefined;
  #connections = 0;
  #bars: number[] = Array.from({ length: cavaBarCount }, () => 0);

  isRunning() {
    return this.#process != undefined;
  }

  start() {
    if (this.isRunning()) return;

    this.#process = Utils.subprocess(
      ["bash", "-c", cavaCommand],
      (output) => {
        this.#bars = output.split(";").map((bar) => +bar / 255.0);
        this.emit("changed");
        this.notify("bars");
      },
      console.error,
    );
  }
  stop() {
    if (!this.isRunning()) return;

    this.#process?.force_exit();
    this.#process = undefined;
    this.#bars = Array.from({ length: cavaBarCount }, () => 0);
  }

  get bars() {
    return this.#bars;
  }

  connect(
    signal: string | undefined,
    callback: (_: this, ...args: any[]) => void,
  ): number {
    if (this.#connections == 0) this.start();
    this.#connections++;
    return super.connect(signal, callback);
  }

  disconnect(id: number): void {
    this.#connections--;
    if (this.#connections == 0) this.stop();
    super.disconnect(id);
  }
}

export const cava = new Cava();

export default cava;
