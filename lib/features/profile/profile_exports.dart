/// Profile feature exports
///
/// This file provides a single import point for all profile feature components
/// following the clean architecture pattern.
///
/// Usage:
/// ```dart
/// import 'package:catering_app/features/profile/profile_exports.dart';
/// ```

// Domain Layer
export 'domain/entities/user_profile.dart';
export 'domain/repositories/profile_repository.dart';
export 'domain/usecases/get_current_profile.dart';
export 'domain/usecases/update_profile.dart';
export 'domain/usecases/upload_profile_image.dart';
export 'domain/usecases/change_password.dart';

// Data Layer
export 'data/models/user_profile_model.dart';
export 'data/repositories/profile_repository_impl.dart';
export 'data/datasources/profile_remote_datasource.dart';
export 'data/datasources/profile_local_datasource.dart';

// Presentation Layer - BLoC
export 'presentation/bloc/profile_bloc.dart';
export 'presentation/bloc/profile_event.dart';
export 'presentation/bloc/profile_state.dart';

// Presentation Layer - Screens
export 'presentation/screens/profile_screen.dart';
export 'presentation/screens/edit_profile_screen.dart';

// Presentation Layer - Widgets
export 'presentation/widgets/profile_header.dart';
export 'presentation/widgets/profile_info_card.dart';
export 'presentation/widgets/profile_menu_item.dart';
export 'presentation/widgets/profile_image_picker.dart';
