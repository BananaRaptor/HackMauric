import requests
import serial
import json

serialArduino = serial.Serial('/dev/ttyACM0', 9600)
URL = "http://18.222.169.179:3000/test"

a = 0

while True:
    dat = serialArduino.readline()
    print(int(dat))
    data = json.dumps({"TEST": int(dat)})
    r = requests.post(url=URL, data={"TEST": int(dat)})
    printable = json.loads(data)
    print (printable)
