# Flutter Catering Application - Project Architecture & Setup Guide

## 📋 Project Overview

A cross-platform (iOS, Android, Web) catering management application with role-based access control and modular architecture.

---

## 🎯 Core Requirements Summary

### User Roles & Permissions
1. **Admin**: Full CRUD for customers, dishes, system configuration
2. **Production**: View cooking requirements, recipes
3. **Logistics**: View purchasing requirements, inventory
4. **Accountancy**: Finance reports, balances, transactions
5. **Customer/User**: Profile management, ordering, payments, balance tracking

---

## 🏗️ Project Architecture

### Architecture Pattern: Clean Architecture + Feature-First

```
lib/
├── main.dart                          # App entry point
├── firebase_options.dart              # Firebase configuration
│
├── core/                              # Core functionality (shared across features)
│   ├── constants/
│   │   ├── app_constants.dart
│   │   ├── firebase_constants.dart
│   │   └── route_constants.dart
│   │
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── colors.dart
│   │   └── text_styles.dart
│   │
│   ├── utils/
│   │   ├── validators.dart
│   │   ├── formatters.dart
│   │   ├── date_utils.dart
│   │   └── currency_utils.dart
│   │
│   ├── services/
│   │   ├── firebase_service.dart
│   │   ├── storage_service.dart
│   │   └── notification_service.dart
│   │
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   │
│   └── network/
│       ├── network_info.dart
│       └── api_response.dart
│
├── shared/                            # Shared widgets and models
│   ├── widgets/
│   │   ├── custom_button.dart
│   │   ├── custom_text_field.dart
│   │   ├── loading_indicator.dart
│   │   ├── error_widget.dart
│   │   ├── custom_app_bar.dart
│   │   └── role_based_widget.dart
│   │
│   ├── models/
│   │   ├── user_role.dart
│   │   └── api_response_model.dart
│   │
│   └── extensions/
│       ├── context_extensions.dart
│       ├── string_extensions.dart
│       └── datetime_extensions.dart
│
├── features/                          # Feature modules (each self-contained)
│   │
│   ├── authentication/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository_impl.dart
│   │   │   └── datasources/
│   │   │       └── auth_remote_datasource.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       ├── logout_usecase.dart
│   │   │       ├── register_usecase.dart
│   │   │       └── reset_password_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   ├── register_page.dart
│   │       │   └── forgot_password_page.dart
│   │       └── widgets/
│   │           ├── login_form.dart
│   │           └── social_login_buttons.dart
│   │
│   ├── profile/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── profile_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── profile_repository_impl.dart
│   │   │   └── datasources/
│   │   │       └── profile_remote_datasource.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── profile_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── profile_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_profile_usecase.dart
│   │   │       └── update_profile_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── profile_bloc.dart
│   │       │   ├── profile_event.dart
│   │       │   └── profile_state.dart
│   │       ├── pages/
│   │       │   ├── profile_page.dart
│   │       │   └── edit_profile_page.dart
│   │       └── widgets/
│   │           ├── profile_header.dart
│   │           └── profile_info_card.dart
│   │
│   ├── dishes/                        # Menu/Dishes management
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── dish_model.dart
│   │   │   │   └── category_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── dishes_repository_impl.dart
│   │   │   └── datasources/
│   │   │       └── dishes_remote_datasource.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── dish_entity.dart
│   │   │   │   └── category_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── dishes_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_dishes_usecase.dart
│   │   │       ├── add_dish_usecase.dart
│   │   │       ├── update_dish_usecase.dart
│   │   │       ├── delete_dish_usecase.dart
│   │   │       └── get_categories_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── dishes_bloc.dart
│   │       │   ├── dishes_event.dart
│   │       │   └── dishes_state.dart
│   │       ├── pages/
│   │       │   ├── dishes_list_page.dart
│   │       │   ├── dish_detail_page.dart
│   │       │   ├── add_dish_page.dart
│   │       │   └── edit_dish_page.dart
│   │       └── widgets/
│   │           ├── dish_card.dart
│   │           ├── dish_filter.dart
│   │           └── category_selector.dart
│   │
│   ├── orders/                        # Order management
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── order_model.dart
│   │   │   │   └── order_item_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── orders_repository_impl.dart
│   │   │   └── datasources/
│   │   │       └── orders_remote_datasource.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── order_entity.dart
│   │   │   │   └── order_item_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── orders_repository.dart
│   │   │   └── usecases/
│   │   │       ├── create_order_usecase.dart
│   │   │       ├── get_orders_usecase.dart
│   │   │       ├── get_order_detail_usecase.dart
│   │   │       ├── update_order_status_usecase.dart
│   │   │       └── cancel_order_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── orders_bloc.dart
│   │       │   ├── orders_event.dart
│   │       │   ├── orders_state.dart
│   │       │   ├── cart_bloc.dart
│   │       │   ├── cart_event.dart
│   │       │   └── cart_state.dart
│   │       ├── pages/
│   │       │   ├── orders_page.dart
│   │       │   ├── order_detail_page.dart
│   │       │   ├── cart_page.dart
│   │       │   └── checkout_page.dart
│   │       └── widgets/
│   │           ├── order_card.dart
│   │           ├── order_status_badge.dart
│   │           ├── cart_item.dart
│   │           └── order_summary.dart
│   │
│   ├── customers/                     # Customer management (Admin)
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── customer_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── customers_repository_impl.dart
│   │   │   └── datasources/
│   │   │       └── customers_remote_datasource.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── customer_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── customers_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_customers_usecase.dart
│   │   │       ├── add_customer_usecase.dart
│   │   │       ├── update_customer_usecase.dart
│   │   │       └── delete_customer_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── customers_bloc.dart
│   │       │   ├── customers_event.dart
│   │       │   └── customers_state.dart
│   │       ├── pages/
│   │       │   ├── customers_list_page.dart
│   │       │   ├── add_customer_page.dart
│   │       │   └── edit_customer_page.dart
│   │       └── widgets/
│   │           ├── customer_card.dart
│   │           └── customer_search.dart
│   │
│   ├── production/                    # Production planning
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── production_plan_model.dart
│   │   │   │   └── recipe_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── production_repository_impl.dart
│   │   │   └── datasources/
│   │   │       └── production_remote_datasource.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── production_plan_entity.dart
│   │   │   │   └── recipe_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── production_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_production_plan_usecase.dart
│   │   │       ├── calculate_ingredients_usecase.dart
│   │   │       └── update_production_status_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── production_bloc.dart
│   │       │   ├── production_event.dart
│   │       │   └── production_state.dart
│   │       ├── pages/
│   │       │   ├── production_dashboard_page.dart
│   │       │   └── cooking_schedule_page.dart
│   │       └── widgets/
│   │           ├── production_summary.dart
│   │           └── ingredient_list.dart
│   │
│   ├── logistics/                     # Logistics and purchasing
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── purchase_order_model.dart
│   │   │   │   └── inventory_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── logistics_repository_impl.dart
│   │   │   └── datasources/
│   │   │       └── logistics_remote_datasource.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── purchase_order_entity.dart
│   │   │   │   └── inventory_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── logistics_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_purchase_requirements_usecase.dart
│   │   │       ├── create_purchase_order_usecase.dart
│   │   │       └── get_inventory_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── logistics_bloc.dart
│   │       │   ├── logistics_event.dart
│   │       │   └── logistics_state.dart
│   │       ├── pages/
│   │       │   ├── logistics_dashboard_page.dart
│   │       │   ├── purchase_orders_page.dart
│   │       │   └── inventory_page.dart
│   │       └── widgets/
│   │           ├── purchase_requirements_card.dart
│   │           └── inventory_item.dart
│   │
│   ├── finance/                       # Finance and accounting
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── transaction_model.dart
│   │   │   │   ├── balance_model.dart
│   │   │   │   └── financial_report_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── finance_repository_impl.dart
│   │   │   └── datasources/
│   │   │       └── finance_remote_datasource.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── transaction_entity.dart
│   │   │   │   ├── balance_entity.dart
│   │   │   │   └── financial_report_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── finance_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_transactions_usecase.dart
│   │   │       ├── get_balances_usecase.dart
│   │   │       ├── generate_report_usecase.dart
│   │   │       └── process_payment_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── finance_bloc.dart
│   │       │   ├── finance_event.dart
│   │       │   └── finance_state.dart
│   │       ├── pages/
│   │       │   ├── finance_dashboard_page.dart
│   │       │   ├── transactions_page.dart
│   │       │   ├── balances_page.dart
│   │       │   └── reports_page.dart
│   │       └── widgets/
│   │           ├── transaction_card.dart
│   │           ├── balance_summary.dart
│   │           ├── financial_chart.dart
│   │           └── report_filter.dart
│   │
│   ├── payments/                      # Payment processing
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── payment_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── payment_repository_impl.dart
│   │   │   └── datasources/
│   │   │       └── payment_remote_datasource.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── payment_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── payment_repository.dart
│   │   │   └── usecases/
│   │   │       ├── process_payment_usecase.dart
│   │   │       └── get_payment_methods_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── payment_bloc.dart
│   │       │   ├── payment_event.dart
│   │       │   └── payment_state.dart
│   │       ├── pages/
│   │       │   └── payment_page.dart
│   │       └── widgets/
│   │           ├── payment_method_selector.dart
│   │           └── payment_summary.dart
│   │
│   ├── notifications/                 # Notifications
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── notification_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── notifications_repository_impl.dart
│   │   │   └── datasources/
│   │   │       └── notifications_remote_datasource.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── notification_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── notifications_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_notifications_usecase.dart
│   │   │       └── mark_as_read_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── notifications_bloc.dart
│   │       │   ├── notifications_event.dart
│   │       │   └── notifications_state.dart
│   │       ├── pages/
│   │       │   └── notifications_page.dart
│   │       └── widgets/
│   │           └── notification_card.dart
│   │
│   └── dashboard/                     # Role-based dashboards
│       ├── presentation/
│       │   ├── pages/
│       │   │   ├── admin_dashboard_page.dart
│       │   │   ├── production_dashboard_page.dart
│       │   │   ├── logistics_dashboard_page.dart
│       │   │   ├── finance_dashboard_page.dart
│       │   │   └── user_dashboard_page.dart
│       │   └── widgets/
│       │       ├── dashboard_card.dart
│       │       ├── stats_widget.dart
│       │       └── quick_actions.dart
│       └── data/
│           └── repositories/
│               └── dashboard_repository.dart
│
├── routes/                            # Navigation
│   ├── app_router.dart
│   ├── route_guards.dart
│   └── routes.dart
│
└── di/                                # Dependency Injection
    ├── injection_container.dart
    └── modules/
        ├── auth_module.dart
        ├── profile_module.dart
        ├── dishes_module.dart
        ├── orders_module.dart
        ├── customers_module.dart
        ├── production_module.dart
        ├── logistics_module.dart
        └── finance_module.dart
```

---

## 🗄️ Firebase Database Structure

```
firestore/
├── users/
│   └── {userId}
│       ├── email: string
│       ├── name: string
│       ├── phone: string
│       ├── role: string (admin, production, logistics, accountancy, user)
│       ├── balance: number
│       ├── address: map
│       ├── createdAt: timestamp
│       └── updatedAt: timestamp
│
├── customers/ (managed by admin)
│   └── {customerId}
│       ├── name: string
│       ├── email: string
│       ├── phone: string
│       ├── address: map
│       ├── balance: number
│       ├── status: string (active, inactive)
│       ├── createdAt: timestamp
│       └── updatedAt: timestamp
│
├── dishes/
│   └── {dishId}
│       ├── name: string
│       ├── description: string
│       ├── categoryId: string
│       ├── price: number
│       ├── imageUrl: string
│       ├── ingredients: array
│       │   └── {ingredientId, name, quantity, unit}
│       ├── preparationTime: number (minutes)
│       ├── isAvailable: boolean
│       ├── createdAt: timestamp
│       └── updatedAt: timestamp
│
├── categories/
│   └── {categoryId}
│       ├── name: string
│       ├── description: string
│       ├── imageUrl: string
│       └── order: number
│
├── orders/
│   └── {orderId}
│       ├── userId: string
│       ├── orderNumber: string
│       ├── items: array
│       │   └── {dishId, dishName, quantity, price, totalPrice}
│       ├── totalAmount: number
│       ├── status: string (pending, confirmed, preparing, ready, delivered, cancelled)
│       ├── deliveryAddress: map
│       ├── deliveryDate: timestamp
│       ├── isPaid: boolean
│       ├── paymentMethod: string
│       ├── notes: string
│       ├── createdAt: timestamp
│       └── updatedAt: timestamp
│
├── productionPlans/
│   └── {planId}
│       ├── date: timestamp
│       ├── dishes: array
│       │   └── {dishId, dishName, quantity, status}
│       ├── totalQuantity: number
│       ├── status: string (pending, in_progress, completed)
│       ├── createdAt: timestamp
│       └── updatedAt: timestamp
│
├── purchaseOrders/
│   └── {purchaseOrderId}
│       ├── orderNumber: string
│       ├── supplierId: string
│       ├── supplierName: string
│       ├── items: array
│       │   └── {ingredientId, name, quantity, unit, pricePerUnit, totalPrice}
│       ├── totalAmount: number
│       ├── status: string (draft, ordered, received, paid)
│       ├── expectedDelivery: timestamp
│       ├── createdAt: timestamp
│       └── updatedAt: timestamp
│
├── inventory/
│   └── {ingredientId}
│       ├── name: string
│       ├── currentStock: number
│       ├── unit: string
│       ├── minStock: number
│       ├── lastRestocked: timestamp
│       └── updatedAt: timestamp
│
├── transactions/
│   └── {transactionId}
│       ├── type: string (order_payment, purchase, refund, deposit)
│       ├── userId: string (optional)
│       ├── orderId: string (optional)
│       ├── purchaseOrderId: string (optional)
│       ├── amount: number
│       ├── balanceBefore: number
│       ├── balanceAfter: number
│       ├── description: string
│       ├── createdBy: string
│       ├── createdAt: timestamp
│       └── status: string (pending, completed, failed)
│
├── suppliers/
│   └── {supplierId}
│       ├── name: string
│       ├── contact: string
│       ├── email: string
│       ├── phone: string
│       ├── balance: number
│       ├── products: array
│       └── createdAt: timestamp
│
└── financialReports/
    └── {reportId}
        ├── period: map {startDate, endDate}
        ├── totalRevenue: number
        ├── totalExpenses: number
        ├── netProfit: number
        ├── orderCount: number
        ├── topDishes: array
        ├── supplierBalances: map
        ├── customerBalances: map
        ├── createdBy: string
        └── createdAt: timestamp
```

---

## 📦 Required Packages

### Core Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Firebase
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  cloud_firestore: ^5.4.4
  firebase_storage: ^12.3.4
  firebase_messaging: ^15.1.3
  
  # State Management
  flutter_bloc: ^8.1.6
  equatable: ^2.0.5
  
  # Dependency Injection
  get_it: ^8.0.0
  injectable: ^2.4.4
  
  # Navigation
  go_router: ^14.6.1
  
  # Network
  connectivity_plus: ^6.0.5
  internet_connection_checker: ^2.0.0
  
  # Local Storage
  shared_preferences: ^2.3.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # UI Components
  flutter_svg: ^2.0.10+1
  cached_network_image: ^3.4.1
  shimmer: ^3.0.0
  flutter_spinkit: ^5.2.1
  
  # Forms & Validation
  formz: ^0.7.0
  mask_text_input_formatter: ^2.9.0
  
  # Date & Time
  intl: ^0.19.0
  timeago: ^3.7.0
  
  # Charts & Analytics
  fl_chart: ^0.69.0
  syncfusion_flutter_charts: ^27.1.58
  
  # PDF Generation
  pdf: ^3.11.1
  printing: ^5.13.2
  
  # Image Processing
  image_picker: ^1.1.2
  image_cropper: ^8.0.2
  
  # Payments (example - choose based on your needs)
  stripe_platform_interface: ^11.2.0
  # pay: ^2.0.0  # Google Pay / Apple Pay
  
  # QR Code
  qr_flutter: ^4.1.0
  qr_code_scanner: ^1.0.1
  
  # Utilities
  uuid: ^4.5.1
  logger: ^2.4.0
  dartz: ^0.10.1  # Functional programming (Either)
  rxdart: ^0.28.0
  
  # Permissions
  permission_handler: ^11.3.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Code Generation
  build_runner: ^2.4.13
  injectable_generator: ^2.6.2
  hive_generator: ^2.0.1
  json_serializable: ^6.8.0
  
  # Testing
  bloc_test: ^9.1.7
  mocktail: ^1.0.4
  fake_cloud_firestore: ^3.0.3
  
  # Linting
  flutter_lints: ^5.0.0
  very_good_analysis: ^6.0.0
```

---

## 🛠️ Setup Instructions

### 1. Prerequisites

#### Install Required Software:
- **Flutter SDK** (latest stable): https://flutter.dev/docs/get-started/install
- **Dart SDK** (comes with Flutter)
- **Android Studio** (for Android development)
- **Xcode** (for iOS development, macOS only)
- **VS Code** or **Android Studio** with Flutter plugins
- **Firebase CLI**: `npm install -g firebase-tools`
- **Git**

#### Verify Installation:
```bash
flutter doctor -v
firebase --version
```

### 2. Create Flutter Project

```bash
# Create project
flutter create catering_app

cd catering_app

# Enable web support (if not already enabled)
flutter config --enable-web

# Test run
flutter run -d chrome  # For web
flutter run            # For mobile (with device/emulator connected)
```

### 3. Firebase Setup

#### Step 1: Create Firebase Project
1. Go to https://console.firebase.google.com/
2. Click "Add Project"
3. Enter project name: "catering-app"
4. Enable Google Analytics (optional)
5. Create project

#### Step 2: Register Apps
Register each platform (Android, iOS, Web):

**For Android:**
1. Click Android icon
2. Package name: `com.yourcompany.catering_app`
3. Download `google-services.json`
4. Place in `android/app/`

**For iOS:**
1. Click iOS icon
2. Bundle ID: `com.yourcompany.cateringApp`
3. Download `GoogleService-Info.plist`
4. Place in `ios/Runner/`

**For Web:**
1. Click Web icon
2. App nickname: "Catering App Web"
3. Copy Firebase config

#### Step 3: Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli

# Configure Firebase for your Flutter project
flutterfire configure
```

This will:
- Create `firebase_options.dart`
- Configure all platforms automatically

#### Step 4: Enable Firebase Services

In Firebase Console, enable:
- **Authentication**: Email/Password, Google Sign-In
- **Firestore Database**: Start in production mode
- **Storage**: For images
- **Cloud Messaging**: For notifications

#### Step 5: Firestore Security Rules (Initial)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function getUserRole() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role;
    }
    
    function isAdmin() {
      return isAuthenticated() && getUserRole() == 'admin';
    }
    
    function isAccountancy() {
      return isAuthenticated() && (getUserRole() == 'accountancy' || isAdmin());
    }
    
    function isProduction() {
      return isAuthenticated() && (getUserRole() == 'production' || isAdmin());
    }
    
    function isLogistics() {
      return isAuthenticated() && (getUserRole() == 'logistics' || isAdmin());
    }
    
    // Users collection
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow write: if isAuthenticated() && (request.auth.uid == userId || isAdmin());
    }
    
    // Customers collection
    match /customers/{customerId} {
      allow read: if isAuthenticated();
      allow write: if isAdmin();
    }
    
    // Dishes collection
    match /dishes/{dishId} {
      allow read: if isAuthenticated();
      allow write: if isAdmin();
    }
    
    // Categories collection
    match /categories/{categoryId} {
      allow read: if isAuthenticated();
      allow write: if isAdmin();
    }
    
    // Orders collection
    match /orders/{orderId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated();
      allow update: if isAuthenticated() && (resource.data.userId == request.auth.uid || isAdmin());
      allow delete: if isAdmin();
    }
    
    // Production plans
    match /productionPlans/{planId} {
      allow read: if isProduction();
      allow write: if isProduction();
    }
    
    // Purchase orders
    match /purchaseOrders/{orderId} {
      allow read: if isLogistics();
      allow write: if isLogistics();
    }
    
    // Inventory
    match /inventory/{ingredientId} {
      allow read: if isAuthenticated();
      allow write: if isLogistics() || isProduction();
    }
    
    // Transactions
    match /transactions/{transactionId} {
      allow read: if isAccountancy() || (isAuthenticated() && resource.data.userId == request.auth.uid);
      allow write: if isAccountancy();
    }
    
    // Suppliers
    match /suppliers/{supplierId} {
      allow read: if isAuthenticated();
      allow write: if isLogistics() || isAdmin();
    }
    
    // Financial reports
    match /financialReports/{reportId} {
      allow read: if isAccountancy();
      allow write: if isAccountancy();
    }
  }
}
```

### 4. Project Configuration

#### pubspec.yaml
Update your `pubspec.yaml` with the dependencies listed above.

#### main.dart (Initial Setup)
```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize dependency injection
  await di.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catering App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const Placeholder(), // Will be replaced with proper routing
    );
  }
}
```

### 5. Development Environment Setup

#### VS Code Extensions (Recommended):
- Flutter
- Dart
- Flutter Widget Snippets
- Bloc
- Awesome Flutter Snippets
- Firebase Explorer

#### Android Studio Plugins:
- Flutter
- Dart
- Firebase Services

### 6. Version Control

```bash
# Initialize git repository
git init

# Create .gitignore
flutter create --project-name catering_app .

# Initial commit
git add .
git commit -m "Initial project setup"
```

### 7. Development Commands

```bash
# Get dependencies
flutter pub get

# Run code generation
flutter pub run build_runner build --delete-conflicting-outputs

# Run on different platforms
flutter run -d chrome          # Web
flutter run -d android          # Android
flutter run -d ios              # iOS
flutter run                     # Default device

# Build for production
flutter build apk              # Android APK
flutter build appbundle        # Android App Bundle
flutter build ios              # iOS
flutter build web              # Web

# Analyze code
flutter analyze

# Run tests
flutter test
```

---

## 🎯 Next Steps - Development Order

### Phase 1: Core Foundation (Week 1-2)
1. Setup project structure (folders as shown above)
2. Configure Firebase
3. Implement dependency injection (get_it)
4. Create core utilities and constants
5. Setup routing (go_router)
6. Create shared widgets

### Phase 2: Authentication (Week 2)
1. Implement authentication feature
2. Login/Register screens
3. Role-based access control
4. User profile management

### Phase 3: Dishes Management (Week 3)
1. Implement dishes feature
2. CRUD operations for dishes
3. Category management
4. Image upload

### Phase 4: Orders System (Week 3-4)
1. Shopping cart
2. Order placement
3. Order history
4. Order status tracking

### Phase 5: Production & Logistics (Week 4-5)
1. Production planning module
2. Ingredient calculations
3. Purchase order management
4. Inventory tracking

### Phase 6: Finance Module (Week 5-6)
1. Transaction management
2. Balance tracking
3. Financial reports
4. Payment processing

### Phase 7: Admin & Customer Management (Week 6)
1. Customer CRUD operations
2. Admin dashboard
3. Role-based dashboards

### Phase 8: Testing & Optimization (Week 7)
1. Unit tests
2. Widget tests
3. Integration tests
4. Performance optimization

### Phase 9: Deployment (Week 8)
1. Build and test on all platforms
2. Deploy to Firebase Hosting (web)
3. Submit to Play Store (Android)
4. Submit to App Store (iOS)

---

## 📝 Coding Standards

1. **Follow Flutter & Dart style guide**
2. **Use meaningful variable and function names**
3. **Keep functions small and focused (single responsibility)**
4. **Document complex logic with comments**
5. **Use const constructors where possible**
6. **Implement proper error handling**
7. **Write tests for business logic**
8. **Use dependency injection**
9. **Keep UI and business logic separated**
10. **Use BLoC pattern consistently**

---

## 🔐 Security Considerations

1. **Never store sensitive data in client code**
2. **Use Firebase security rules properly**
3. **Validate all inputs on both client and server**
4. **Use HTTPS for all communications**
5. **Implement proper authentication and authorization**
6. **Use environment variables for API keys**
7. **Regularly update dependencies**
8. **Implement rate limiting on Firebase**

---

## 📊 Performance Optimization

1. **Use lazy loading for lists**
2. **Implement pagination for large datasets**
3. **Cache network images**
4. **Use const widgets where possible**
5. **Minimize rebuilds with proper BLoC usage**
6. **Use Firebase offline persistence**
7. **Optimize images before upload**
8. **Use indexes in Firestore queries**

---

Ready to start building! Let me know which phase you'd like to begin with, and I'll help you implement it step by step.
