# PolyWine

## 📌 Description

**PolyWine** is a mobile application developed with **Flutter** and a **Flask API**, designed to manage a **smart wine cellar**. The application runs on **iOS and Android** and integrates with a physical wine cellar connected via a **Raspberry Pi** in bluetooth🛜.

[![polywine demo](front/lib/assets/img/miniature.png)](https://www.youtube.com/watch?v=yAzsr4N954w)

## 🎨 UI Design (Figma)

[View Figma Designs](https://www.figma.com/proto/3vyjWRazGmI9xCGPG7ij4v?node-id=0-1&t=0FpNm5Ffpij5tY2E-6)

## 🚀 Installation & Setup

### 📦 **Docker Setup**
#### Ensure you have **Docker** installed and run the following command:
```bash
docker-compose up --build
```

#### if port **error** `3306`:
` ERROR: for mysql  Cannot start service mysql: driver failed programming external connectivity on endpoint mysql`

Do next commands:

```bash
sudo service mysql stop 
sudo lsof -i :5000
sudo kill -9 PID processus_on_port 3306
sudo docker-compose restart
sudo docker-compose up
```

### 🚀 Flutter Setup

#### Check Flutter SDK
```bash
flutter doctor
```

#### Run the application
```bash
flutter run ./front/lib/main.dart
```

#### Si erreur de dépendance : que flutter ne trouve pas les paquets (exemple: provider)
```bash
cd front
flutter clean
flutter pub get
```
#### flutter http 🔗 api flask
*change the url in the file `front/lib/pages/fetch/url.dart`*
```
final String url = 'http://my_ip:5001/';
```

   
