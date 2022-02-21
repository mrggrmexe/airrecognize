#include <Wire.h>
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>
#include <NTPClient.h>
#include <WiFiUdp.h>
#include <Adafruit_BMP085.h>
 
Adafruit_BMP085 bmp;

WiFiUDP ntpUDP;
const long utcOffsetInSeconds = 10800;
NTPClient timeClient(ntpUDP, "pool.ntp.org", utcOffsetInSeconds);
unsigned long epochTime = timeClient.getEpochTime();
struct tm *ptm = gmtime ((time_t *)&epochTime);

//wifi data
const char* ssid = "имя сети";
const char* password = "пароль от сети";

ESP8266WebServer server(80);

////////////////////////////////////////
String SendHTML(int TemperatureWeb,int PressureWeb, int CoWeb);
void handle_OnConnect();
void handle_NotFound();

int Temperature;
int Pressure;
String formattedTime;
String Date;
int Day;
int Month;
int Year;
int Co;
/////////////////////////////////////////

//int limit;
int value1;
float value2;
float value3;
 
void setup() {
  Serial.begin(115200);
  if (!bmp.begin()) 
  {
    Serial.println("Could not find BMP180 or BMP085 sensor");
    while (1) {}
  }
  /////////////////////////////////////////////////////
  Serial.println("Connecting to ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
  delay(1000);
  Serial.print(".");
  } 
  Serial.println("");
  Serial.println("Connected to WiFi");
  Serial.print("IP: ");  Serial.println(WiFi.localIP());

  server.on("/", handle_OnConnect);
  server.onNotFound(handle_NotFound);
  server.begin();
  timeClient.begin();
  //////////////////////////////////////////////////////////
}
 
void loop() {
  //////////////////////////////////////////////////////////
  server.handleClient();
  //////////////////////////////////////////////////////////
  
  value2 = bmp.readTemperature();
  Serial.print("Temperature = ");
  Serial.print(value2);
  Serial.println(" С");

  value3 = bmp.readPressure()/133.32;
  Serial.print("Pressure = ");
  Serial.print(value3);
  Serial.println(" мм.рт.ст");

  value1 = analogRead(A0);
  Serial.print("CO value: ");
  Serial.print(value1);
  Serial.println();
  delay(5000);
}


void handle_OnConnect() {
  Temperature = int(value2);
  Pressure = int(value3);
  Co = value1;
  server.send(200, "application/json", SendHTML(Temperature,Pressure, Co)); 
}

void handle_NotFound(){
  server.send(404, "text/plain", "Not found");
}

String SendHTML(int TemperatureWeb,int PressureWeb, int CoWeb){
  String response = "";
  response += "[";
  response += "{";
  response += "\"temperature\":";
  response += TemperatureWeb;
  response += ",";
  response += "\"pressure\":";
  response += "0";
  response += ",";
  response += "\"co2\":";
  response += "0";
  response += "}";
  response += ",";
  response += "";
  response += "{";
  response += "\"temperature\":";
  response += "0";
  response += ",";
  response += "\"pressure\":";
  response += PressureWeb;
  response += ",";
  response += "\"co2\":";
  response += "0";
  response += "}";
  response += ",";
  response += "";
  response += "{";
  response += "\"temperature\":";
  response += "0";
  response += ",";
  response += "\"pressure\":";
  response += "0";
  response += ",";
  response += "\"co2\":";
  response += CoWeb;
  response += "}";
  response += "]";
  return response;
}
