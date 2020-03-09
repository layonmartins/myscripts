from tkinter import *

from Utils import Utils
from FrameMain import FrameMain


def run():
    utils = Utils()
    root = Tk()
    FrameMain(root)
    utils.center_window(300, 100, root)
    root.mainloop()

run()
