#define SENSORPIN A0
#define NEXT_TIME_FACTOR 1000
#define BROKEN_THREASHOLD 200

void pushSerial();

int sensorValue = 0;
char dataString[50] = {0};
int length; 
unsigned long nextTime = 0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  sensorValue += analogRead(SENSORPIN);
  unsigned long currentTime = millis();
  ++length;
  if(nextTime <= currentTime){
    pushSerial();
    nextTime = currentTime + NEXT_TIME_FACTOR;  
    length = 0;
    sensorValue = 0;
  }
  delay(100);
}

void pushSerial(){
  sensorValue = sensorValue / length;
  Serial.println(sensorValue);
  if(sensorValue < BROKEN_THREASHOLD){
    sensorValue = 0;
  }
  //sprintf(dataString,"%02X", sensorValue);
  Serial.println(sensorValue);    
  
}
