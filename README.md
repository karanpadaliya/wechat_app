<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>

<h1>WeChat App (Firebase Miner)</h1>

<h2>Project Description</h2>
<p><strong>Firebase Miner (Chat App)</strong> is a secure and user-friendly mobile application developed using Flutter. This app facilitates seamless two-way communication by leveraging Firebase Authentication and Firestore for real-time data synchronization. It includes multiple sign-in options, user profile management, themes, and individual chat pages.</p>

<h2>Features</h2>
<ul>
    <li><strong>Firebase Authentication</strong>: Supports Google Sign-in, Guest Sign-in, and Email/Password authentication.</li>
    <li><strong>User Profile Management</strong>: Allows users to update and manage their profiles.</li>
    <li><strong>Light & Dark Themes</strong>: Users can switch between themes based on preferences.</li>
    <li><strong>Splash Screen</strong>: A welcoming splash screen upon launching the app.</li>
    <li><strong>Chat Pages</strong>: Real-time chat for each user.</li>
    <li><strong>Media Support</strong>: The app supports sending and receiving media like images.</li>
</ul>

<h2>Libraries Used</h2>
<pre>
<code>
dependencies:
  cupertino_icons: ^1.0.6
  firebase_core: ^3.2.0
  firebase_auth: ^5.1.2
  google_sign_in: ^6.1.6
  cloud_firestore: ^5.0.2
  firebase_messaging: ^15.0.4
  firebase_storage: ^12.1.1
  image_picker: ^1.1.2
  emoji_picker_flutter: ^2.2.0
  cached_network_image: ^3.3.1
  connectivity_plus: ^6.0.5
</code>
</pre>

<h2>File Structure</h2>
<pre>
<code>
lib/
├── components/
│   ├── dialogs.dart
│   └── my_data_util.dart
├── dialog/
│   └── profile_dialog.dart
├── generated/
│   └── assets.dart
├── helper/
│   └── firebase_helper.dart
├── model/
│   ├── chat_user.dart
│   └── message.dart
├── screen/
│   ├── auth/
│   │   └── login_screen.dart
│   ├── chat_page.dart
│   ├── home_page.dart
│   ├── profile_screen.dart
│   ├── splash_screen.dart
│   └── view_profile_screen.dart
├── widgets/
│   └── firebase_options.dart
└── main.dart
</code>
</pre>

<h2>Project Objectives</h2>
<ul>
    <li><strong>Firebase Authentication</strong>: Provides multiple sign-in methods including Google, Guest, and Email/Password.</li>
    <li><strong>Profile Management</strong>: Users can update their display name, profile picture, and other details.</li>
    <li><strong>Themes</strong>: Users can switch between light and dark themes.</li>
    <li><strong>Splash Screen</strong>: A custom splash screen greets users at launch.</li>
    <li><strong>Chat Pages</strong>: Real-time chat interface for users.</li>
</ul>

<h2>Technologies Used</h2>
<ul>
    <li><strong>Language</strong>: Dart</li>
    <li><strong>Framework</strong>: Flutter</li>
    <li><strong>Architecture</strong>: MVC with Provider/GetX</li>
    <li><strong>Database</strong>: Firebase Firestore</li>
    <li><strong>Authentication</strong>: Firebase Authentication</li>
</ul>

<h2>Screenshots and GIFs</h2>
<img src="https://github.com/user-attachments/assets/73672f4c-e856-4fe9-ac5c-cee9335fa7f1" alt="1" style="width: 200px; height: 450px;"></li> <li><img src="https://github.com/user-attachments/assets/f9b977a4-3be5-4dc3-8819-90f4648b4bf0" alt="2" style="width: 200px; height: 450px;"></li> <li><img src="https://github.com/user-attachments/assets/00102cb2-bdfb-48bd-b31e-c0763047ff6d" alt="3" style="width: 200px; height: 450px;"></li> <li><img src="https://github.com/user-attachments/assets/708fe360-1664-48dc-a633-1a935bc86e6d" alt="4" style="width: 200px; height: 450px;"></li> <li><img src="https://github.com/user-attachments/assets/0e5eb197-ed0e-4bb0-8541-8da44f09e983" alt="5" style="width: 200px; height: 450px;"></li> <li><img src="https://github.com/user-attachments/assets/fb86442e-d95f-479a-ac52-eef8ab8d5906" alt="6" style="width: 200px; height: 450px;"></li> <li><img src="https://github.com/user-attachments/assets/a42c24b6-2e5a-4893-8f69-55440de79444" alt="7" style="width: 200px; height: 450px;"></li> <li><img src="https://github.com/user-attachments/assets/c2670d1a-57ce-45a1-80a3-4eb93d78f0d8" alt="8" style="width: 200px; height: 450px;"></li> <li><img src="https://github.com/user-attachments/assets/c691a40b-75e9-44f1-a269-380081c8c5bf" alt="9" style="width: 200px; height: 450px;"></li> <li><img src="https://github.com/user-attachments/assets/4333a0aa-a995-4e3b-aaff-e9371134c66d" alt="10" style="width: 200px; height: 450px;"></li> <li><img src="https://github.com/user-attachments/assets/f109a601-690c-4576-9a24-34ed8461f744" alt="11" style="width: 200px; height: 450px;"></li> <li><img src="https://github.com/user-attachments/assets/de9fac0c-6640-49e1-863f-15985b553aca" alt="12" style="width: 200px; height: 450px;"></li> <li><img src="https://github.com/user-attachments/assets/0ac3649a-d04f-4877-b3da-753735ecb1da" alt="13" style="width: 200px; height: 450px;"></li> <li><img src="https://github.com/user-attachments/assets/b4505333-bb88-41fc-8cd4-62a053a7ba5b" alt="14" style="width: 200px; height: 450px;"></li> <li><img src="https://github.com/user-attachments/assets/aa34f79d-dc14-4f4a-a0df-897031508ed8" alt="15" style="width: 200px; height: 450px;"></li> <li><img src="https://github.com/user-attachments/assets/8a2807de-33c5-4e30-a7bf-34cccc339843" alt="16" style="width: 200px; height: 450px;"></li> <li><img src="https://github.com/user-attachments/assets/cfbe85b6-56d1-4771-ae08-6b87d3b4e849" alt="17" style="width: 200px; height: 450px;"></li> <li><img src="https://github.com/user-attachments/assets/61ab0082-a85a-4cd4-974c-6ddba203339b" alt="18" style="width: 200px; height: 450px;"></li> <li><img src="https://github.com/user-attachments/assets/43ecfbae-126d-464c-8222-b76341a25ac1" alt="19" style="width: 200px; height: 450px;"></li> <li><img src="https://github.com/user-attachments/assets/5fbf60f4-2e66-4337-94d4-ab748e2ff460" alt="20" style="width: 200px; height: 450px;">

<h2>Project Requirements</h2>
<ul>
    <li>Dart and Flutter development</li>
    <li>Firebase Firestore for real-time database management</li>
    <li>Firebase Authentication for secure login functionality</li>
    <li>Experience with mobile development tools like VS Code or Android Studio</li>
</ul>

<h2>How to Run</h2>
<ol>
    <li>Clone the repository:
        <pre><code>git clone https://github.com/yourusername/wechat_app.git
cd wechat_app</code></pre>
    </li>
    <li>Install dependencies:
        <pre><code>flutter pub get</code></pre>
    </li>
    <li>Run the app:
        <pre><code>flutter run</code></pre>
    </li>
</ol>

<p>Make sure that you have set up your Firebase project and added the necessary Firebase credentials in <code>firebase_options.dart</code>.</p>

<h2>Assumptions</h2>
<ul>
    <li>Firebase services have been correctly set up and initialized.</li>
    <li>Users are assumed to have a stable internet connection.</li>
</ul>

<h2>Conclusion</h2>
<p>This chat application offers a seamless and secure experience using Firebase services, ensuring that users can easily communicate with others. The flexible UI with light and dark themes enhances user satisfaction. Whether for personal or professional use, <strong>Firebase Miner (Chat App)</strong> brings reliability to instant messaging.</p>

</body>
</html>
