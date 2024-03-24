# employee_attendance_management

This project is a Flutter application designed to manage employee attendance. It provides features for employees to log in, check in/out their attendance, view their attendance history, and update their profile details.

# System Architecture
The system architecture of the Employee Attendance Management application follows a client-server model:
  # 1 Client Side (Mobile Application):
  The client side of the application is developed using the Flutter framework, allowing for cross-platform compatibility on both iOS    and Android devices.
  The client communicates with the server-side database to fetch and update employee data, attendance records, and other relevant       information.

  # 2 Server Side (Firebase Firestore):
  Firebase Firestore is utilized as the server-side database to store employee information, attendance records, and other relevant 
  data.
  The server-side logic is implemented using Firebase Authentication for user authentication and Firestore for data storage.
  Cloud Firestore's real-time synchronization capabilities ensure that data is updated in real time across all clients.

# Technologies Used

Flutter: A cross-platform mobile application framework developed by Google.

Firebase Authentication: Provides user authentication services for securely signing in and registering users.

Firebase Firestore: A flexible, scalable database for mobile, web, and server development. It's used for storing employee details, attendance records, and other data.

Shared Preferences: A local storage solution for storing small, simple data in key-value pairs persistently across app launches.

Dart: The programming language used for developing the Flutter application.

# Instructions for Running the Application
To run the Employee Attendance Management application locally, follow these steps:

Ensure you have Flutter installed on your development machine. If not, refer to the Flutter installation guide.

Clone this repository to your local machine using Git:
git clone https://github.com/vijaybiju/employee-attendance-management-sysytem.git

Navigate to the project directory:
cd employee-attendance-management-system

Run the following command to fetch the dependencies:
flutter pub get

Set up Firebase for the project:
  Create a new Firebase project on the Firebase Console.
  Add an Android and/or iOS app to your Firebase project and follow the setup instructions to integrate Firebase with your Flutter      app.
  Enable Firebase Authentication and Firestore for your project.

Update the Firebase configuration in the Flutter project:
  Replace the google-services.json file for Android or GoogleService-Info.plist file for iOS with the ones generated for your           Firebase project.

Run the app on your connected device or emulator using the following command:
  flutter run

Once the application is running, you can sign in with your credentials, check in/out your attendance, view attendance history, and update your profile details as needed.

# Contributing
Contributions to the Employee Attendance Management project are welcome! If you find any issues or have suggestions for improvements, please feel free to open an issue or submit a pull request.

# License
This project is licensed under the MIT License. Feel free to use and modify the code for your own purposes.

    
