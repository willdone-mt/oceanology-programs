//CODE FOR DHT SENSOR

#define BLYNK_TEMPLATE_ID "TMPL60Nl5a3sk"
#define BLYNK_TEMPLATE_NAME "Kelembapan dan Suhu Udara Test"
#define BLYNK_AUTH_TOKEN "lyYYY5fslaEOZ1wrSsEYkD2I3u48vHPx"

#include <RTClib.h>
#include <DHT.h>
#include <SPI.h>
#include <SD.h>
#include <BlynkSimpleEsp8266.h>

#define DHT_SENSOR_PIN D4
#define DHT_SENSOR_TYPE DHT22

DHT dht_sensor(DHT_SENSOR_PIN, DHT_SENSOR_TYPE);
RTC_DS1307 rtc;

const char* ssid = "UDA";
const char* password = "furries267";

char filename[] = "dhtsensor.csv";
char daysOfTheWeek[7][12] = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" };

void setup() {

  Serial.begin(9600);

  dht_sensor.begin();

#ifndef ESP8266
  while (!Serial)
    ;
#endif

  if (!rtc.begin()) {
    Serial.println("Couldn't find RTC");
    Serial.flush();
  }

  if (!rtc.isrunning()) {
    Serial.println("RTC is NOT running, let's set the time!");
    rtc.adjust(DateTime(2024, 11, 20, 15, 00, 0));
    //DateTime now = DateTime(F(__DATE__), F(__TIME__));



    //rtc.adjust(DateTime(F(DATE), F(TIME)));
  }

  rtc.adjust(DateTime(2024, 11, 20, 15, 0, 0));

  if (!SD.begin(D7)) {
    Serial.println("SD Card initialization failed!");
  }

  Serial.println("SD Card initialized.");

  Blynk.begin(BLYNK_AUTH_TOKEN, ssid, password);
}

void loop() {

  //Pengambilan waktu
  DateTime now = rtc.now();

  //Kirim serial waktu
  Serial.print("(");
  Serial.print(daysOfTheWeek[now.dayOfTheWeek()]);
  Serial.print(") ");
  Serial.print(now.day(), DEC);
  Serial.print('/');
  Serial.print(now.month(), DEC);
  Serial.print('/');
  Serial.print(now.year(), DEC);
  Serial.print(" ");
  Serial.print(now.hour(), DEC);
  Serial.print(':');
  Serial.print(now.minute(), DEC);
  Serial.print(':');
  Serial.print(now.second(), DEC);
  Serial.println();

  //Pengambilan nilai suhu
  float humi = dht_sensor.readHumidity();
  float temperature_C = dht_sensor.readTemperature();
  float temperature_F = dht_sensor.readTemperature(true);

  //Validasi nilai suhu
  if (isnan(temperature_C) || isnan(temperature_F) || isnan(humi)) {
    Serial.println("Failed to read from DHT sensor!");

  } else {
    //Kirim serial suhu
    Serial.print("Humidity: ");
    Serial.print(humi);
    Serial.print("%  |  Temperature: ");
    Serial.print(temperature_C);
    Serial.print("°C  ~  ");
    Serial.print(temperature_F);
    Serial.println("°F");

    //Pengaksesan file
    File myFile = SD.open(filename, FILE_WRITE);

    //Pemasukan data ke file
    if (myFile) {
      myFile.print(daysOfTheWeek[now.dayOfTheWeek()]);
      myFile.print(", ");

      myFile.print(now.day());
      myFile.print('/');
      myFile.print(now.month());
      myFile.print('/');
      myFile.print(now.year());
      myFile.print(", ");

      myFile.print(now.hour());
      myFile.print(':');
      myFile.print(now.minute());
      myFile.print(':');
      myFile.print(now.second());
      myFile.print(", ");

      myFile.print(humi);
      myFile.print(", ");
      myFile.println(temperature_C);

      //Penyimpanan dan penutupan file
      myFile.close();

      Serial.println("Data logged to SD card.");

    } else {
      Serial.println("Failed to save data to SD card");
    }

    //Penghubungan data ke blynk dengan jalur/datastream
    Blynk.virtualWrite(V0, temperature_C);
    Blynk.virtualWrite(V1, humi);
    Blynk.virtualWrite(V2, String(now.day()) + "/" + String(now.month()) + "/" + String(now.year()));
    Blynk.virtualWrite(V3, String(now.hour()) + ":" + String(now.minute()) + ":" + String(now.second()));
  }

  delay(10000);
  //ESP.deepSleep(10*1000000);
}