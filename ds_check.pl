#!/usr/bin/python
import subprocess
from time import sleep
import time
import datetime

# print("dispatcher:{}".format(dlist))

# URI: sip:14.75.69.51:5072
#0 FLAGS: AP
#1 PRIORITY: 12
#2 ATTRS: {
#3 	BODY: weight=50;rweight=50
#4 	DUID: 
#5 	MAXLOAD: 0
#6 	WEIGHT: 50
#7 	RWEIGHT: 50
#8 	SOCKET: 
#9 }
#10 LATENCY: {
#11 	AVG: 0.745000
#12 	STD: 0.677000
#13 	EST: 0.096000
#14 	MAX: 342
#15 	TIMEOUT: 0
#16 }

def server_stats(ip,res):
   idx = -1
   for line in dlist.splitlines():
      if idx == 0:
         d, f =  line.split(" ")
         f = f.strip();
      if idx == 5:
         est_latency = line.strip()
      if idx == 15:
         timeout = line.strip()
      if idx == 7:
         d,rweight = line.split(":")
         rweight = rweight.strip()
         if f == "IP":
            rweight = 0
         res = "{},{},{},{}".format(res, ip, f, rweight)
         rw_list.append(int(rweight))
      if idx >= 0:
         idx = idx + 1
      if line.find("URI: sip:{}".format(ip)) > 0:
         idx = 0

   if timeout[:9] == "TIMEOUT: ":
      timeout_count = timeout[9:]
   if est_latency[:5] == "EST: ":
      latency = est_latency[5:]
   return res, rw_list

servers = ["14.75.69.51:5072", "14.75.69.51:5073", "14.75.88.181:5072", "14.75.88.181:5073"]
interval = 10
it = 0
while 1:
   ts = time.time()
   currentDT = datetime.datetime.now().strftime('%H:%M:%S')
   next_ts = ts + 10
   it = it + 1
   res = "{}".format(ts)
   dlist = subprocess.check_output(["kamcmd","dispatcher.list"])
   rw_list = []
   for ip in servers:
      res, l = server_stats(ip,res)
   total_w = 0
   res= str(currentDT)
   for e in l:
      total_w = total_w + e;
   for e in l:
      if total_w == 0:
         res = "{},0".format(res)
      else:
         res = "{},{}".format(res, int(100*e/float(total_w)))
   print("{}".format(res))
   ts = time.time()
   sleep(1)

