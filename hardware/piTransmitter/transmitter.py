import requests
import serial
import json
import uuid

serialArduino = serial.Serial('/dev/ttyACM0', 9600)
URL = "http://18.222.169.179:3000/flow"
mac = (['{:02x}'.format((uuid.getnode() >> ele) & 0xff)
        for ele in range(0, 8 * 6, 8)][::-1])
mac = str(mac)
print(mac)

a = 0

while True:
    dat = serialArduino.readline()
    print(int(dat))
    data = json.dumps({"flow": int(dat)})
    r = requests.post(url=URL, data={"flow": int(dat),
                                     "mac": mac})
    printable = json.loads(data)
    print (printable)
