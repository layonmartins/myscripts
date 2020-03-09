from tkinter import *

from FrameLogFrequency import FrameLogFrequency
from FrameLogQuantity import FrameLogQuantity
from Utils import Utils


class FrameMain:
    def __init__(self, master=None):
        self.master = master
        self.utils = Utils()

        self.btnLogFrequencyChart = Button(self.master, text='Log Frequency', command=self.__call_frame_log_frequency)
        self.btnLogFrequencyChart.place(x=30,y=10,width=240,height=30)

        self.btnLogQuantityChart = Button(self.master, text='Log Quantity', command=self.__call_frame_log_quantity)
        self.btnLogQuantityChart.place(x=30, y=45, width=240, height=30)

    def __call_frame_log_frequency(self):
        self.frame_freq = Toplevel(self.master)
        self.utils.center_window(940,780, self.frame_freq)
        self.frame_freq.title('Log Frequency')
        self.app = FrameLogFrequency(self.frame_freq)

    def __call_frame_log_quantity(self):
        self.frame_quant = Toplevel(self.master)
        self.utils.center_window(940, 780, self.frame_quant)
        self.frame_quant.title('Log Quantity')
        self.app = FrameLogQuantity(self.frame_quant)