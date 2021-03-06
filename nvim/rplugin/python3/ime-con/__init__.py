import ctypes
import pynvim as vim


@vim.plugin
class WinImeCon:
    def __init__(self, nvim):
        self.user32 = ctypes.windll.user32
        self.imm32 = ctypes.windll.imm32

    @vim.function('_activate_ime', sync=True)
    def activate(self):
        hWnd = self.imm32.ImmGetDefaultIMEWnd(self.user32.GetForegroundWindow())
        self.user32.SendMessageW(hWnd, 0x283, 0x006, 0x001)

    @vim.function('_disable_ime', sync=True)
    def on_leave(self, is_insert):
        hWnd = self.imm32.ImmGetDefaultIMEWnd(self.user32.GetForegroundWindow())
        if is_insert:
            if self.user32.SendMessageW(hWnd, 0x283, 0x005, 0x000):
                vim.command('let b:win_ime_con_is_active = 1')
            else:
                vim.command('let b:win_ime_con_is_active = 0')
        self.user32.SendMessageW(hWnd, 0x283, 0x006, 0x000)
