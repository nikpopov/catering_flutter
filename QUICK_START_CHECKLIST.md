# 🚀 Catering App - Quick Start Checklist

## ✅ Prerequisites Installation

### 1. Install Flutter
- [ ] Download and install Flutter SDK from https://flutter.dev
- [ ] Add Flutter to your PATH
- [ ] Run `flutter doctor` to verify installation
- [ ] Fix any issues reported by flutter doctor

### 2. Install IDE
- [ ] Install VS Code OR Android Studio
- [ ] Install Flutter and Dart plugins/extensions

### 3. Install Firebase CLI
```bash
npm install -g firebase-tools
```
- [ ] Run `firebase login`

### 4. Platform-Specific Setup

**For Android:**
- [ ] Install Android Studio
- [ ] Install Android SDK
- [ ] Create Android emulator or connect physical device

**For iOS (macOS only):**
- [ ] Install Xcode from App Store
- [ ] Install Xcode command-line tools: `xcode-select --install`
- [ ] Install CocoaPods: `sudo gem install cocoapods`
- [ ] Create iOS simulator or connect physical device

**For Web:**
- [ ] Chrome browser installed (for testing)

---

## 📦 Project Setup

### 1. Create Flutter Project
```bash
flutter create catering_app
cd catering_app
```
- [ ] Project created successfully
- [ ] Test run: `flutter run -d chrome`

### 2. Create Project Structure
Option A: Use the setup script (Linux/macOS):
```bash
chmod +x setup_project.sh
./setup_project.sh
```

Option B: Create folders manually (refer to architecture.md)

- [ ] All folders created
- [ ] .gitignore updated

### 3. Configure Dependencies
- [ ] Copy contents from `pubspec.yaml.template` to your `pubspec.yaml`
- [ ] Run `flutter pub get`
- [ ] Verify no errors

---

## 🔥 Firebase Setup

### 1. Create Firebase Project
- [ ] Go to https://console.firebase.google.com/
- [ ] Click "Add project"
- [ ] Enter name: "catering-app"
- [ ] Disable Google Analytics (optional)
- [ ] Create project

### 2. Register Apps

**Android:**
- [ ] Click Android icon in Firebase Console
- [ ] Package name: `com.yourcompany.catering_app`
- [ ] Download `google-services.json`
- [ ] Place file in `android/app/`

**iOS:**
- [ ] Click iOS icon in Firebase Console
- [ ] Bundle ID: `com.yourcompany.cateringApp`
- [ ] Download `GoogleService-Info.plist`
- [ ] Place file in `ios/Runner/`
- [ ] Add to Xcode project

**Web:**
- [ ] Click Web icon in Firebase Console
- [ ] Register web app
- [ ] Note the Firebase config values

### 3. Configure FlutterFire
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```
- [ ] Select your Firebase project
- [ ] Select all platforms (Android, iOS, Web)
- [ ] Verify `firebase_options.dart` was created

### 4. Enable Firebase Services

In Firebase Console:
- [ ] **Authentication** → Sign-in method → Enable Email/Password
- [ ] **Firestore Database** → Create database → Start in production mode
- [ ] **Storage** → Get started → Start in production mode
- [ ] **Cloud Messaging** → Enable

### 5. Setup Security Rules
- [ ] Copy Firestore security rules from architecture.md
- [ ] Paste in Firebase Console → Firestore Database → Rules
- [ ] Publish rules

---

## 🏗️ Initial Code Setup

### 1. Create Core Files

- [ ] `lib/core/constants/app_constants.dart`
- [ ] `lib/core/constants/firebase_constants.dart`
- [ ] `lib/core/theme/app_theme.dart`
- [ ] `lib/di/injection_container.dart`
- [ ] `lib/routes/app_router.dart`

### 2. Update main.dart
- [ ] Initialize Firebase in main()
- [ ] Setup dependency injection
- [ ] Configure routing

### 3. Create Assets Folders
```bash
mkdir -p assets/images
mkdir -p assets/icons
mkdir -p assets/fonts
```
- [ ] Update pubspec.yaml with assets paths

---

## 🧪 Verify Setup

### 1. Run Tests
```bash
flutter test
```
- [ ] Tests pass (even if empty)

### 2. Build & Run
```bash
# Web
flutter run -d chrome

# Android
flutter run -d android

# iOS (macOS only)
flutter run -d ios
```
- [ ] App builds successfully
- [ ] App runs without errors
- [ ] Firebase connects successfully

### 3. Check Analysis
```bash
flutter analyze
```
- [ ] No critical issues

---

## 📝 Development Ready Checklist

Before starting development:
- [ ] All prerequisites installed
- [ ] Project structure created
- [ ] Firebase configured and connected
- [ ] Dependencies installed
- [ ] App runs on at least one platform
- [ ] Git repository initialized
- [ ] Architecture documentation reviewed

---

## 🎯 Next Development Steps

### Phase 1: Core Setup (Start Here)
- [ ] Setup dependency injection (GetIt)
- [ ] Create app theme
- [ ] Setup routing (GoRouter)
- [ ] Create reusable widgets
- [ ] Setup constants

### Phase 2: Authentication
- [ ] Create User model
- [ ] Implement Firebase Authentication
- [ ] Create Login screen
- [ ] Create Registration screen
- [ ] Create Role-based access control

### Phase 3: Start Building Features
- [ ] Choose first feature (recommend: Dishes)
- [ ] Implement data layer
- [ ] Implement domain layer
- [ ] Implement presentation layer
- [ ] Test feature end-to-end

---

## 📚 Helpful Commands

```bash
# Install dependencies
flutter pub get

# Run code generation
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes (auto-generate)
flutter pub run build_runner watch --delete-conflicting-outputs

# Clean and rebuild
flutter clean
flutter pub get
flutter run

# Create new feature structure
mkdir -p lib/features/feature_name/{data,domain,presentation}/{models,repositories,usecases,bloc,pages,widgets}

# Run on specific device
flutter devices  # List devices
flutter run -d device_id

# Build for production
flutter build apk --release
flutter build appbundle --release
flutter build ios --release
flutter build web --release

# Check for updates
flutter upgrade
flutter pub upgrade --major-versions
```

---

## 🆘 Troubleshooting

### Common Issues:

**1. Flutter Doctor Issues**
```bash
flutter doctor -v
# Follow the instructions for each issue
```

**2. Firebase Connection Issues**
- Verify `google-services.json` is in `android/app/`
- Verify `GoogleService-Info.plist` is in `ios/Runner/`
- Rebuild the app completely: `flutter clean && flutter run`

**3. Dependency Conflicts**
```bash
flutter clean
rm pubspec.lock
flutter pub get
```

**4. iOS Build Issues**
```bash
cd ios
pod install --repo-update
cd ..
flutter run
```

**5. Android Build Issues**
- Check Android SDK is installed
- Check `android/app/build.gradle` minSdkVersion (should be 21+)
- Sync Gradle files

**6. Web CORS Issues**
- Run: `flutter run -d chrome --web-browser-flag "--disable-web-security"`
- For production, configure Firebase CORS properly

---

## 🔗 Important Links

- **Flutter Documentation**: https://docs.flutter.dev/
- **Firebase Documentation**: https://firebase.google.com/docs
- **FlutterFire Documentation**: https://firebase.flutter.dev/
- **BLoC Documentation**: https://bloclibrary.dev/
- **GetIt Documentation**: https://pub.dev/packages/get_it
- **GoRouter Documentation**: https://pub.dev/packages/go_router

---

## 💡 Tips

1. **Use Hot Reload**: Press `r` in terminal while app is running
2. **Use Hot Restart**: Press `R` for full restart
3. **VS Code Shortcuts**:
   - `Ctrl/Cmd + .` for quick fixes
   - `F2` to rename
   - `Ctrl/Cmd + Space` for autocomplete
4. **Keep dependencies updated**: Run `flutter pub upgrade --major-versions` monthly
5. **Write tests as you go**: Don't wait until the end
6. **Commit frequently**: Small, focused commits are better
7. **Read architecture.md carefully**: Understand the structure before coding

---

## 🎉 You're Ready!

Once all checkboxes are marked, you're ready to start building the catering app!

**Recommended First Task**: Implement the Authentication feature, as all other features depend on it.

Need help with any step? Refer back to `catering_app_architecture.md` for detailed explanations.

Good luck! 🚀
