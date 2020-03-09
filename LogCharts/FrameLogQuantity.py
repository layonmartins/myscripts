from tkinter import filedialog

import ntpath
from FileIO import FileIO
from tkinter import *
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from datetime import datetime, timedelta

from pip._internal.utils.outdated import SELFCHECK_DATE_FMT


class FrameLogQuantity:
    def __init__(self, master=None):
        self.master = master
        self.logs = {}
        self.checked = IntVar()

        self.lblData = LabelFrame(self.master, padx=5, pady=5)
        self.lblData.pack(side=TOP, fill=X)

        self.fileLable = Label(self.lblData, text="File:")
        self.fileLable.grid(row=0, column=0, sticky=W)

        self.fileEntry = Entry(self.lblData, state='disabled')
        self.fileEntry.grid(row=1, column=0, padx=5)

        self.fileBtn = Button(self.lblData, text="Open", command=self.__path_file)
        self.fileBtn.grid(row=1, column=1, ipadx=5, padx=5)

        self.filterLable = Label(self.lblData, text="Filter (Regex):")
        self.filterLable.grid(row=0, column=2, sticky=W)

        self.filterEntry = Entry(self.lblData)
        self.filterEntry.grid(row=1, column=2, padx=5)

        self.numberPositionLable = Label(self.lblData, text="Number position in log:")
        self.numberPositionLable.grid(row=0, column=3, sticky=W)

        self.numberPositionEntry = Entry(self.lblData)
        self.numberPositionEntry.grid(row=1, column=3, padx=5)

        self.allLable = Label(self.lblData, text="All:")
        self.allLable.grid(row=0, column=4, sticky=W)

        self.allBtn = Checkbutton(self.lblData, variable=self.checked)
        self.allBtn.grid(row=1, column=4, padx=5)
        self.allBtn.select()

        self.beginLable = Label(self.lblData, text="Begin:")
        self.beginLable.grid(row=0, column=5, sticky=W)

        self.beginEntry = Entry(self.lblData)
        self.beginEntry.grid(row=1, column=5, padx=5)

        self.endLable = Label(self.lblData, text="End:")
        self.endLable.grid(row=0, column=6, sticky=W)

        self.endEntry = Entry(self.lblData)
        self.endEntry.grid(row=1, column=6, padx=5)

        self.createBtn = Button(self.lblData, text="Create", command=self.__create_chart)
        self.createBtn.grid(row=1, column=7, ipadx=5, padx=5)

        self.lblText = LabelFrame(self.master, padx=5, pady=5)
        self.lblText.pack(side=TOP, anchor=N, fill=BOTH, expand = 1)

        self.txtStatus = Text(self.lblText, state='disabled')
        self.txtStatus.pack(side=LEFT, fill=BOTH, anchor=CENTER, expand=1)

        self.scrollStatus = Scrollbar(self.lblText, orient=VERTICAL)
        self.scrollStatus.pack(side=RIGHT, fill=Y, anchor=E)
        self.txtStatus.configure(yscrollcommand=self.scrollStatus.set)

    def __path_file(self):
        file = FileIO()
        self.options = filedialog.askopenfilename(filetypes = (("Plain text", ".txt"),))
        self.fileName = ntpath.basename(self.options)
        if self.options is not "":
            self.logs = file.load_logs(self.options)
            self.__show_file_name(self.fileName)

    def __show_file_name(self, name):
        self.fileEntry.configure(state='normal')
        self.fileEntry.delete(0, END)
        self.fileEntry.insert(0, name)
        self.fileEntry.configure(state='disabled')

    def __create_chart(self):
        file = FileIO()
        filtered_logs = {}
        filtered_values = []
        log_distribution = {}
        self.txtStatus.configure(state='normal')
        if not self.filterEntry.get():
            self.txtStatus.delete('1.0', END)
            self.txtStatus.insert('end', 'Write filter')
            return
        else:
            filtered_logs = file.filter_regex(self.logs, self.filterEntry.get())

        if not self.checked.get() and not (self.beginEntry.get() and self.endEntry.get()):
            self.txtStatus.delete('1.0', END)
            self.txtStatus.insert('end', 'Choose interval')
            return

        if not self.checked.get() and (self.beginEntry.get() and self.endEntry.get()):
            filtered_logs = file.filter_logs_interval(filtered_logs, self.beginEntry.get(), self.endEntry.get())

        if not self.numberPositionEntry.get():
            self.txtStatus.delete('1.0', END)
            self.txtStatus.insert('end', 'Write number position in log')
            return
        else:
            filtered_values = file.filter_values(filtered_logs, int(self.numberPositionEntry.get()))

        self.txtStatus.delete('1.0', END)
        for log in filtered_logs:
            self.txtStatus.insert('end', filtered_logs[log])
        self.txtStatus.configure(state='disabled')

        log_times = self.__get_times(filtered_logs)

        fig = plt.figure()
        self.ax = fig.add_subplot(111)
        # self.ax.plot([], [])
        self.ax.plot(log_times, filtered_values)

        plt.gcf().autofmt_xdate()
        myFmt = mdates.DateFormatter('%H:%M')
        plt.gca().xaxis.set_major_formatter(myFmt)
        plt.title(self.filterEntry.get())
        plt.ylabel('Quantity')
        plt.xlabel('Time')

        plt.show()

    def __get_times(self, logs):
        file = FileIO()
        v = []
        #time_string = file.get_time_until_seconds(logs[0])
        #datetime_object = datetime.strptime(time_string, '%m-%d %H:%M:S')
        last_time = 0
        counter = 0
        time = 0
        for log in logs:
            time_string = file.get_time_until_seconds(logs[log])
            time = datetime.strptime(time_string, '%m-%d %H:%M:%S')
            v.append(time)

        return v

