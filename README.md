# Channeler App
Flutter Client for Image Board Socials.

<img alt="Channeler App Logo" src="./assets/icon/icon_border.png" width="120" height="120"/>

## Releases
Please check the releases section for downloading the apk for the app. If you rather build

## Building
- Download and extract the zip or git clone the repository
- Download the dependencies by running the following command in the root of project directory:
  ```sh
  flutter pub get
  ```
### Run on current OS:
- Run the following command in the root of project directory:
  ```sh
  flutter run lib/main.dart
  ```

### Android APK
- If you want lightweight apk files and you know the abi:
  ```sh
  flutter build apk --split-per-abi --release
  ```

- Else you can run this instead to get one single apk:
  ```sh
  flutter build apk --release
  ```
- Then copy and install the apk inside build/app/outputs/flutter-apk

### Other platforms (iOS, Linux, Windows, Web)
Please check the page [Flutter Deployment](https://docs.flutter.dev/deployment) for instructions on how to build for your platform

## Notices
All the data shown inside the app is fetched from 4chan.org. We do not own or control any data.We only provide a frontend client for image board sites. For any complaints regarding the data shown in the app, please contact the admins of 4chan.org.

## License for Logos and other Graphical Assets
All Graphical Assets were created by [Aravind I M](https://gitlab.com/AravindIM) and [Love Kush Pranu](https://github.com/lutherleo) under the following license:

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.
