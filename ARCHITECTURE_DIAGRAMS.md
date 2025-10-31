# 🏛️ Catering App - Architecture Diagrams

## 📐 Clean Architecture Layers

```
┌─────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐ │
│  │   Pages     │  │   Widgets   │  │  BLoC (State Mgmt)     │ │
│  │  (UI Screens) │  │ (UI Components)│ │ Events → States      │ │
│  └─────────────┘  └─────────────┘  └─────────────────────────┘ │
└────────────────────────────┬────────────────────────────────────┘
                             │ Uses
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                         DOMAIN LAYER                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐ │
│  │  Entities   │  │ Use Cases   │  │  Repository Interfaces │ │
│  │(Pure Objects)│  │(Business Logic)│ │  (Contracts)         │ │
│  └─────────────┘  └─────────────┘  └─────────────────────────┘ │
└────────────────────────────┬────────────────────────────────────┘
                             │ Implements
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                          DATA LAYER                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐ │
│  │   Models    │  │ Repositories │  │   Data Sources         │ │
│  │(Data Objects)│  │(Implementation)│ │ (Firebase, Local)    │ │
│  └─────────────┘  └─────────────┘  └─────────────────────────┘ │
└────────────────────────────┬────────────────────────────────────┘
                             │ Connects to
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                       EXTERNAL SERVICES                          │
│          Firebase (Firestore, Auth, Storage, Messaging)         │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔄 Data Flow Example: User Orders a Dish

```
┌──────────┐
│  USER    │ Taps "Order" button
└────┬─────┘
     │
     ▼
┌────────────────────────────┐
│  OrderButton Widget        │ Dispatches event
│  (Presentation Layer)      │
└────────┬───────────────────┘
         │
         │ OrderEvent.createOrder
         ▼
┌────────────────────────────┐
│  OrderBloc                 │ Receives event
│  (Presentation Layer)      │
└────────┬───────────────────┘
         │
         │ Calls
         ▼
┌────────────────────────────┐
│  CreateOrderUseCase        │ Business logic validation
│  (Domain Layer)            │
└────────┬───────────────────┘
         │
         │ Calls
         ▼
┌────────────────────────────┐
│  OrderRepository Interface │ Abstract contract
│  (Domain Layer)            │
└────────┬───────────────────┘
         │
         │ Implemented by
         ▼
┌────────────────────────────┐
│  OrderRepositoryImpl       │ Actual implementation
│  (Data Layer)              │
└────────┬───────────────────┘
         │
         │ Uses
         ▼
┌────────────────────────────┐
│  OrderRemoteDataSource     │ Firebase operations
│  (Data Layer)              │
└────────┬───────────────────┘
         │
         │ Saves to
         ▼
┌────────────────────────────┐
│  Firebase Firestore        │ Database
│  (External Service)        │
└────────┬───────────────────┘
         │
         │ Returns result
         ▼
┌────────────────────────────┐
│  OrderBloc                 │ Emits new state
│  (Presentation Layer)      │
└────────┬───────────────────┘
         │
         │ OrderState.success
         ▼
┌────────────────────────────┐
│  OrderPage Widget          │ Rebuilds UI
│  (Presentation Layer)      │
└────────┬───────────────────┘
         │
         ▼
┌──────────┐
│  USER    │ Sees success message
└──────────┘
```

---

## 👥 User Roles & Access Flow

```
                    ┌─────────────┐
                    │   Login     │
                    └──────┬──────┘
                           │
                    ┌──────▼──────────┐
                    │ Authentication  │
                    │   (Firebase)    │
                    └──────┬──────────┘
                           │
                    ┌──────▼──────────┐
                    │  Get User Role  │
                    └──────┬──────────┘
                           │
        ┌──────────────────┼──────────────────┬──────────────┬──────────────┐
        │                  │                  │              │              │
   ┌────▼────┐      ┌──────▼─────┐     ┌─────▼──────┐  ┌───▼─────┐  ┌─────▼──────┐
   │  Admin  │      │ Production │     │ Logistics  │  │Accountancy│ │  Customer  │
   └────┬────┘      └──────┬─────┘     └─────┬──────┘  └───┬─────┘  └─────┬──────┘
        │                  │                  │              │              │
        │                  │                  │              │              │
   ┌────▼─────────────────────────────────────────────────────────────────────┐
   │ • Customers CRUD                                                          │
   │ • Dishes CRUD                                                             │
   │ • All Finance Access                                                      │
   │ • System Settings                                                         │
   └───────────────────────────────────────────────────────────────────────────┘
                           │
                      ┌────▼─────────────────────────────────────────────┐
                      │ • View Production Plans                          │
                      │ • View Cooking Requirements                      │
                      │ • Update Production Status                       │
                      └──────────────────────────────────────────────────┘
                                         │
                           ┌─────────────▼─────────────────────────────┐
                           │ • View Purchase Requirements              │
                           │ • Create Purchase Orders                  │
                           │ • Manage Inventory                        │
                           └───────────────────────────────────────────┘
                                                   │
                                    ┌──────────────▼─────────────────────────┐
                                    │ • View All Transactions                │
                                    │ • Generate Financial Reports           │
                                    │ • View Provider Balances               │
                                    │ • View Customer Balances               │
                                    └────────────────────────────────────────┘
                                                            │
                                             ┌──────────────▼────────────────┐
                                             │ • View/Edit Profile           │
                                             │ • Browse Dishes               │
                                             │ • Create Orders               │
                                             │ • Make Payments               │
                                             │ • View Order History          │
                                             │ • Check Balance               │
                                             └───────────────────────────────┘
```

---

## 📱 App Navigation Structure

```
                    ┌────────────────┐
                    │  Splash Screen │
                    └────────┬───────┘
                             │
                    ┌────────▼─────────┐
                    │ Is Authenticated?│
                    └────┬─────────┬───┘
                         │         │
                    NO   │         │  YES
                         │         │
                ┌────────▼──┐  ┌───▼────────────┐
                │   Login   │  │  Role-Based    │
                │   Page    │  │  Dashboard     │
                └────────┬──┘  └───┬────────────┘
                         │         │
                         │         ├──────────────┐
                         │         │              │
                    ┌────▼─────────▼────┐    ┌────▼──────────────┐
                    │  Admin Dashboard  │    │ User Dashboard    │
                    │  ┌──────────────┐ │    │ ┌───────────────┐ │
                    │  │• Customers   │ │    │ │• My Profile   │ │
                    │  │• Dishes      │ │    │ │• Browse Dishes│ │
                    │  │• Orders      │ │    │ │• My Orders    │ │
                    │  │• Finance     │ │    │ │• Cart         │ │
                    │  │• Reports     │ │    │ │• Payments     │ │
                    │  └──────────────┘ │    │ │• Balance      │ │
                    └───────────────────┘    │ └───────────────┘ │
                                              └───────────────────┘
                         │
                         ├──────────────────┬──────────────────┐
                         │                  │                  │
               ┌─────────▼────────┐  ┌──────▼────────┐  ┌─────▼───────────┐
               │ Production       │  │ Logistics     │  │ Accountancy     │
               │ Dashboard        │  │ Dashboard     │  │ Dashboard       │
               │ ┌──────────────┐ │  │ ┌───────────┐ │  │ ┌─────────────┐ │
               │ │• Cooking     │ │  │ │• Purchase │ │  │ │• Trans-     │ │
               │ │  Schedule    │ │  │ │  Orders   │ │  │ │  actions    │ │
               │ │• Ingredients │ │  │ │• Inventory│ │  │ │• Balances   │ │
               │ │• Recipes     │ │  │ │• Suppliers│ │  │ │• Reports    │ │
               │ └──────────────┘ │  │ └───────────┘ │  │ └─────────────┘ │
               └──────────────────┘  └───────────────┘  └─────────────────┘
```

---

## 🔥 Firebase Integration Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Flutter App                               │
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐  │
│  │ Presentation │  │   Domain     │  │      Data Layer      │  │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────────────┘  │
│         │                 │                  │                   │
└─────────┼─────────────────┼──────────────────┼───────────────────┘
          │                 │                  │
          │                 │                  │
          │                 │        ┌─────────▼───────────┐
          │                 │        │ Firebase Services   │
          │                 │        │   (Data Sources)    │
          │                 │        └─────────┬───────────┘
          │                 │                  │
          └─────────────────┴──────────────────┤
                                               │
                    ┌──────────────────────────┼────────────────────────┐
                    │                          │                        │
          ┌─────────▼─────────┐    ┌──────────▼─────────┐   ┌─────────▼────────┐
          │ Firebase Auth     │    │ Cloud Firestore    │   │ Firebase Storage │
          │                   │    │                    │   │                  │
          │ • Email/Password  │    │ • users/           │   │ • dish_images/   │
          │ • Google Sign-In  │    │ • dishes/          │   │ • profile_pics/  │
          │ • Role Management │    │ • orders/          │   │ • receipts/      │
          │ • Session Mgmt    │    │ • transactions/    │   │                  │
          └───────────────────┘    │ • customers/       │   └──────────────────┘
                                   │ • inventory/       │
                                   │ • etc...           │
                                   └────────────────────┘
                                            │
                                   ┌────────▼──────────┐
                                   │ Security Rules    │
                                   │                   │
                                   │ • Role-based      │
                                   │ • Data validation │
                                   │ • Access control  │
                                   └───────────────────┘
                                            │
                                   ┌────────▼──────────┐
                                   │ Firebase Cloud    │
                                   │ Messaging (FCM)   │
                                   │                   │
                                   │ • Push            │
                                   │   Notifications   │
                                   └───────────────────┘
```

---

## 🎯 Dependency Injection Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                        main.dart                                 │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  await di.init();  // Initialize all dependencies           │ │
│  └────────────────────────────────────────────────────────────┘ │
└─────────────┬───────────────────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────────────────────┐
│                   injection_container.dart                       │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  final sl = GetIt.instance;  // Service Locator            │ │
│  └────────────────────────────────────────────────────────────┘ │
└─────────────┬───────────────────────────────────────────────────┘
              │
              ├─────────────────┬─────────────────┬────────────────┐
              │                 │                 │                │
    ┌─────────▼────────┐  ┌────▼──────────┐  ┌──▼──────────┐  ┌──▼──────────┐
    │ Core Services    │  │ Data Sources  │  │ Repositories│  │ Use Cases   │
    │                  │  │               │  │             │  │             │
    │ • Firebase       │  │ • Auth Remote │  │ • Auth Repo │  │ • Login     │
    │ • Storage        │  │ • Dish Remote │  │ • Dish Repo │  │ • Register  │
    │ • Network        │  │ • Order Remote│  │ • Order Repo│  │ • GetDishes │
    └──────────────────┘  └───────────────┘  └─────────────┘  └─────────────┘
              │                 │                 │                │
              └─────────────────┴─────────────────┴────────────────┘
                                      │
                              ┌───────▼────────┐
                              │     BLoCs      │
                              │                │
                              │ • AuthBloc     │
                              │ • DishesBloc   │
                              │ • OrdersBloc   │
                              │ • etc...       │
                              └────────────────┘
                                      │
                              ┌───────▼────────┐
                              │  Presentation  │
                              │   (Widgets)    │
                              └────────────────┘

Usage in Widget:
  final authBloc = sl<AuthBloc>();
  or
  BlocProvider(create: (_) => sl<AuthBloc>())
```

---

## 💰 Payment Processing Flow

```
┌──────────┐
│  USER    │ Initiates payment
└────┬─────┘
     │
     ▼
┌────────────────────────────────┐
│  Cart/Checkout Page            │
│  Shows order summary & total   │
└────────┬───────────────────────┘
         │
         │ Selects payment method
         ▼
┌────────────────────────────────┐
│  Payment Page                  │
│  • Credit Card                 │
│  • Balance (if sufficient)     │
│  • Cash on Delivery            │
└────────┬───────────────────────┘
         │
         │ Confirms payment
         ▼
┌────────────────────────────────┐
│  PaymentBloc                   │
│  Validates & processes         │
└────────┬───────────────────────┘
         │
    ┌────┴─────────────────┐
    │                      │
    ▼                      ▼
┌──────────────┐    ┌─────────────────┐
│ Balance      │    │ External Payment│
│ Payment      │    │ Gateway         │
│              │    │ (Stripe/etc)    │
└────┬─────────┘    └────┬────────────┘
     │                   │
     │ Creates Transaction Records
     │                   │
     └────────┬──────────┘
              ▼
┌─────────────────────────────────┐
│  Firebase Transaction Write     │
│  • Update user balance          │
│  • Create transaction record    │
│  • Update order status          │
│  • Send notification            │
└─────────────┬───────────────────┘
              │
              ▼
┌─────────────────────────────────┐
│  Success/Failure State          │
│  • Emit to UI                   │
│  • Show confirmation            │
│  • Navigate to order detail     │
└─────────────────────────────────┘
```

---

## 📊 Financial Reporting Data Aggregation

```
Admin/Accountancy requests report for Date Range
                    │
                    ▼
┌─────────────────────────────────────────────┐
│  GenerateReportUseCase                      │
│  Validates date range & permissions         │
└──────────────┬──────────────────────────────┘
               │
               ├──────────┬──────────┬──────────┐
               │          │          │          │
    ┌──────────▼───┐  ┌───▼─────┐ ┌─▼──────┐ ┌─▼───────────┐
    │ Orders       │  │Purchase │ │Customer│ │  Supplier   │
    │ Collection   │  │ Orders  │ │Balances│ │  Balances   │
    │ Query        │  │ Query   │ │ Query  │ │  Query      │
    └──────┬───────┘  └────┬────┘ └───┬────┘ └─────┬───────┘
           │               │          │            │
           └───────────────┴──────────┴────────────┘
                           │
                    ┌──────▼──────────┐
                    │  Aggregate Data │
                    │  • Total Revenue│
                    │  • Total Costs  │
                    │  • Net Profit   │
                    │  • Top Products │
                    │  • Balances     │
                    └──────┬──────────┘
                           │
                    ┌──────▼──────────────┐
                    │ Generate Report PDF │
                    │ or                  │
                    │ Return Data Object  │
                    └──────┬──────────────┘
                           │
                    ┌──────▼──────────────┐
                    │ Display/Download    │
                    │ • Charts            │
                    │ • Tables            │
                    │ • Summary           │
                    └─────────────────────┘
```

---

## 🍽️ Production Planning Data Flow

```
Daily at midnight (or manually triggered)
                    │
                    ▼
┌─────────────────────────────────────────────┐
│  Calculate Production Requirements          │
│  Query all orders for tomorrow              │
└──────────────┬──────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────┐
│  Group by Dish                              │
│  • Dish A: 50 portions                      │
│  • Dish B: 30 portions                      │
│  • Dish C: 20 portions                      │
└──────────────┬──────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────┐
│  For each dish, get recipe                  │
│  Calculate total ingredients needed         │
│                                             │
│  Example:                                   │
│  Dish A (50 portions):                      │
│  • Chicken: 50 × 200g = 10kg               │
│  • Rice: 50 × 150g = 7.5kg                 │
│  • Vegetables: 50 × 100g = 5kg             │
└──────────────┬──────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────┐
│  Create Production Plan Document            │
│  Save to Firebase                           │
└──────────────┬──────────────────────────────┘
               │
               ├────────────────┬──────────────┐
               │                │              │
    ┌──────────▼────┐   ┌───────▼──────┐  ┌───▼──────────┐
    │ Production     │   │ Logistics    │  │ Notifications│
    │ Dashboard      │   │ Dashboard    │  │ to Staff     │
    │ (View plan)    │   │ (Purchase    │  │              │
    │                │   │  requirements)│  │              │
    └────────────────┘   └──────────────┘  └──────────────┘
```

---

## 🔒 Security & Authentication Flow

```
┌───────────────────────────────────────────────────────────────┐
│                    App Launch                                  │
└────────────────────────┬──────────────────────────────────────┘
                         │
                         ▼
┌───────────────────────────────────────────────────────────────┐
│  Check Authentication State (Firebase Auth)                   │
└────────┬────────────────────────────────────┬─────────────────┘
         │                                    │
    NO   │                               YES  │
         ▼                                    ▼
┌──────────────────┐              ┌───────────────────────────┐
│  Login Screen    │              │ Fetch User Profile        │
└──────┬───────────┘              │ from Firestore           │
       │                          └───────┬───────────────────┘
       │ Enter credentials                │
       ▼                                  ▼
┌──────────────────┐              ┌───────────────────────────┐
│ Firebase Auth    │              │ Check User Role           │
│ signInWith...    │              │ • Admin                   │
└──────┬───────────┘              │ • Production              │
       │                          │ • Logistics               │
       │ Success                  │ • Accountancy             │
       ▼                          │ • Customer                │
┌──────────────────┐              └───────┬───────────────────┘
│ Save Auth Token  │                      │
│ to Local Storage │                      │
└──────┬───────────┘                      │
       │                                  │
       └──────────────┬───────────────────┘
                      │
                      ▼
┌───────────────────────────────────────────────────────────────┐
│  Navigate to Role-Based Dashboard                             │
│  • Setup Route Guards                                         │
│  • Apply Role-based UI visibility                             │
│  • Initialize role-specific data streams                      │
└───────────────────────────────────────────────────────────────┘
                      │
         ┌────────────┴────────────┐
         │                         │
         ▼                         ▼
┌──────────────────┐      ┌──────────────────┐
│ Every Request:   │      │ Session Mgmt:    │
│ • Include token  │      │ • Token refresh  │
│ • Check roles    │      │ • Auto logout    │
│ • Validate perms │      │ • Remember me    │
└──────────────────┘      └──────────────────┘
```

---

These diagrams provide a visual understanding of how the application is structured and how data flows through different layers. Use them as reference when implementing features!
