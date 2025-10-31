#!/bin/bash

# Catering App - Quick Setup Script
# This script will help you set up the project structure

echo "🚀 Setting up Catering App Project Structure..."

# Create main project directory
PROJECT_NAME="catering_app"

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "Visit: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter is installed"

# Create Flutter project
echo "📦 Creating Flutter project..."
flutter create $PROJECT_NAME
cd $PROJECT_NAME

# Create folder structure
echo "📁 Creating folder structure..."

# Core folders
mkdir -p lib/core/{constants,theme,utils,services,errors,network}
mkdir -p lib/shared/{widgets,models,extensions}

# Feature folders
mkdir -p lib/features/authentication/{data/{models,repositories,datasources},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}
mkdir -p lib/features/profile/{data/{models,repositories,datasources},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}
mkdir -p lib/features/dishes/{data/{models,repositories,datasources},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}
mkdir -p lib/features/orders/{data/{models,repositories,datasources},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}
mkdir -p lib/features/customers/{data/{models,repositories,datasources},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}
mkdir -p lib/features/production/{data/{models,repositories,datasources},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}
mkdir -p lib/features/logistics/{data/{models,repositories,datasources},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}
mkdir -p lib/features/finance/{data/{models,repositories,datasources},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}
mkdir -p lib/features/payments/{data/{models,repositories,datasources},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}
mkdir -p lib/features/notifications/{data/{models,repositories,datasources},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}
mkdir -p lib/features/dashboard/{data/repositories,presentation/{pages,widgets}}

# Routes and DI
mkdir -p lib/routes
mkdir -p lib/di/modules

echo "✅ Folder structure created"

# Create .gitignore additions
echo "📝 Updating .gitignore..."
cat >> .gitignore << 'EOF'

# Firebase
firebase_options.dart
google-services.json
GoogleService-Info.plist

# Environment variables
.env
.env.local

# Generated files
*.g.dart
*.freezed.dart

# IDE
.vscode/
.idea/

# Build
build/
.dart_tool/
EOF

echo "✅ .gitignore updated"

# Create README
echo "📝 Creating README..."
cat > README.md << 'EOF'
# Catering App

A comprehensive Flutter application for catering company management with role-based access control.

## Features

- 📱 Cross-platform (iOS, Android, Web)
- 🔐 Role-based authentication
- 🍽️ Dish and menu management
- 📦 Order processing
- 🏭 Production planning
- 🚚 Logistics management
- 💰 Financial reporting
- 👥 Customer management

## Getting Started

### Prerequisites

- Flutter SDK (latest stable)
- Firebase project configured
- Dart SDK

### Installation

1. Clone the repository
2. Run `flutter pub get`
3. Configure Firebase (see SETUP.md)
4. Run `flutter run`

## Project Structure

See `architecture.md` for detailed project structure.

## Development

- Use BLoC pattern for state management
- Follow clean architecture principles
- Write tests for business logic
- Use dependency injection

## License

Private - All rights reserved
EOF

echo "✅ README created"

# Create analysis_options.yaml
echo "📝 Creating analysis_options.yaml..."
cat > analysis_options.yaml << 'EOF'
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - always_declare_return_types
    - always_put_required_named_parameters_first
    - avoid_print
    - avoid_unnecessary_containers
    - avoid_web_libraries_in_flutter
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_const_literals_to_create_immutables
    - prefer_final_fields
    - prefer_final_locals
    - require_trailing_commas
    - sort_child_properties_last
    - use_key_in_widget_constructors

analyzer:
  errors:
    missing_required_param: error
    missing_return: error
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
EOF

echo "✅ analysis_options.yaml created"

echo ""
echo "🎉 Project structure created successfully!"
echo ""
echo "📋 Next steps:"
echo "1. cd $PROJECT_NAME"
echo "2. Update pubspec.yaml with required dependencies"
echo "3. Run: flutter pub get"
echo "4. Configure Firebase: flutterfire configure"
echo "5. Start building features!"
echo ""
echo "📚 Read catering_app_architecture.md for complete setup guide"
