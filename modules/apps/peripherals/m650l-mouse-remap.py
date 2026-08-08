#!/usr/bin/env python3
"""
Le KEY_BACK/KEY_FORWARD do device virtual 'solaar-keyboard' (criado pelo
Solaar via uinput quando os botoes M4/M5 do M650L estao em modo diverted)
e reemite como BTN_SIDE/BTN_EXTRA num device de MOUSE uinput proprio.

Motivo: Solaar so consegue emitir KeyPress (teclado) ou MouseClick
limitado a left/middle/right nas suas regras -- nao existe forma nativa
de o Solaar emitir um botao lateral de mouse real. Jogos (RoR2, etc)
esperam Mouse4/Mouse5 (BTN_SIDE/BTN_EXTRA), nao uma tecla de teclado,
entao o rules.yaml (KeyPress XF86_Back/Forward) funciona em apps de
desktop mas nunca vai funcionar em jogos.

Preserva o hold real (press/release) que o divert-keys + rules.yaml do
Solaar ja garante -- so troca o TIPO de evento na ultima etapa.

Reconecta automaticamente se o mouse for desligado/religado ou o
device solaar-keyboard sumir e voltar (troca de bateria, sleep, etc).
"""
from __future__ import annotations

import logging
import signal
import sys
import time

from evdev import InputDevice, UInput, ecodes, list_devices

SOURCE_NAME = "solaar-keyboard"
BUTTON_MAP = {
    ecodes.KEY_BACK: ecodes.BTN_SIDE,
    ecodes.KEY_FORWARD: ecodes.BTN_EXTRA,
}
RECONNECT_DELAY_S = 1.0


class Stopped(Exception):
    """Sinaliza que SIGTERM/SIGINT pediu parada durante uma espera."""


class Daemon:
    def __init__(self) -> None:
        self._stop = False

    def request_stop(self, *_args) -> None:
        self._stop = True

    @staticmethod
    def _find_source() -> InputDevice | None:
        for path in list_devices():
            try:
                dev = InputDevice(path)
            except OSError:
                continue
            if dev.name == SOURCE_NAME:
                return dev
            dev.close()
        return None

    def _wait_for_source(self) -> InputDevice:
        announced = False
        while not self._stop:
            dev = self._find_source()
            if dev is not None:
                return dev
            if not announced:
                logging.info("Aguardando device '%s'...", SOURCE_NAME)
                announced = True
            time.sleep(RECONNECT_DELAY_S)
        raise Stopped

    def _bridge(self, src: InputDevice, ui: UInput) -> None:
        logging.info("Lendo de: %s (%s)", src.path, src.name)
        src.grab()
        try:
            for event in src.read_loop():
                if self._stop:
                    return
                if event.type != ecodes.EV_KEY:
                    continue
                target = BUTTON_MAP.get(event.code)
                if target is None or event.value not in (0, 1):
                    continue
                ui.write(ecodes.EV_KEY, target, event.value)
                ui.syn()
        finally:
            try:
                src.ungrab()
            except OSError:
                pass
            src.close()

    def run(self) -> None:
        ui = UInput(
            {ecodes.EV_KEY: list(BUTTON_MAP.values())},
            name="m650l-mouse-buttons",
            vendor=0x046D,
            product=0xFFFF,
            version=1,
        )
        logging.info("Device virtual de mouse criado: %s", ui.device.path)
        try:
            while not self._stop:
                src = self._wait_for_source()
                try:
                    self._bridge(src, ui)
                except OSError as e:
                    logging.warning("Device desconectado (%s), reconectando...", e)
        except Stopped:
            pass
        finally:
            ui.close()


def main() -> int:
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s %(levelname)s %(message)s",
    )
    daemon = Daemon()
    signal.signal(signal.SIGTERM, daemon.request_stop)
    signal.signal(signal.SIGINT, daemon.request_stop)
    daemon.run()
    return 0


if __name__ == "__main__":
    sys.exit(main())
