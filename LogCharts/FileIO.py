"""
Date: 31/10/2018

Read log's.txt

"""
import datetime
import glob
import os
import re

class FileIO:
	def get_time_until_seconds(self, line):
		return line[0:14]

	def get_time_until_minutes(self, line):
		return line[0:11]

	#Load archive.txt and generate a dictionary {index : [description,[list_log]]}
	def load_logs(self, path):
		l = {}
		#with open(path + name,'r') as log_file:	
		with open(path, 'r', encoding="ISO-8859-1") as log_file:
			counter = 0
			for line in log_file:
				l[counter] = line
				counter += 1
		log_file.close()

		return l

	def filter_logs_interval(self, logs, begin, end):
		l = {}
		counter = 0
		for log in logs:
			if logs[log] >= begin and logs[log] <= end + 'z':
				l[counter] = logs[log]
				counter += 1

		return l

	def filter_regex(self, logs, expression):
		l = {}
		counter = 0
		for log in logs:
			if re.search(expression, logs[log]):
				l[counter] = logs[log]
				counter += 1

		return l

	def filter_values(self, logs, position):
		v = []
		for log in logs:
			values = re.findall(r'\d+', logs[log])
			value = values[position-1]
			if value:
				v.append(float(value))
			else:
				raise ValueError('Couldn\'t filter value')

		return v