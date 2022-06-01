import 'package:dashboard/app.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/repositories/bank_repository.dart';
import 'package:dashboard/repositories/business_account_repository.dart';
import 'package:dashboard/repositories/business_repository.dart';
import 'package:dashboard/repositories/geo_account_repository.dart';
import 'package:dashboard/repositories/google_places_repository.dart';
import 'package:dashboard/repositories/hours_repository.dart';
import 'package:dashboard/repositories/message_repository.dart';
import 'package:dashboard/repositories/owner_repository.dart';
import 'package:dashboard/repositories/photo_picker_repository.dart';
import 'package:dashboard/repositories/photos_repository.dart';
import 'package:dashboard/repositories/profile_repository.dart';
import 'package:dashboard/routing/route_data.dart';
import 'package:dashboard/routing/routes.dart';
import 'package:dashboard/screens/bank_screen/bank_screen.dart';
import 'package:dashboard/screens/business_account_screen/business_account_screen.dart';
import 'package:dashboard/screens/edit_hours_screen/edit_hours_screen.dart';
import 'package:dashboard/screens/geo_account_screen/geo_account_screen.dart';
import 'package:dashboard/screens/hours_screen/hours_screen.dart';
import 'package:dashboard/screens/login_screen/login_screen.dart';
import 'package:dashboard/screens/message_list_screen/message_list_screen.dart';
import 'package:dashboard/screens/onboard_screen/onboard_screen.dart';
import 'package:dashboard/screens/owners_screen/owners_screen.dart';
import 'package:dashboard/screens/photos_screen/photos_screen.dart';
import 'package:dashboard/screens/profile_screen/profile_screen.dart';
import 'package:dashboard/screens/register_screen/register_screen.dart';
import 'package:dashboard/screens/reset_password_screen/reset_password_screen.dart';
import 'package:dashboard/screens/settings_screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {

  const AppRouter();

  Route goTo({required BuildContext context, required RouteSettings settings}) {
    final RouteData _routeData = RouteData.init(settings: settings);
    Route route;

    switch (_routeData.route) {
      case Routes.app:
        route = _createRoute(
          screen: const App(), 
        
        name: _routeData.route);
        break;
      case Routes.login:
        route = _createRoute(
          screen: RepositoryProvider(
            create: (_) => const AuthenticationRepository(),
            child: const LoginScreen(),
          ),

        name: _routeData.route);
        break;
      case Routes.register:
        route = _createRoute(
          screen: RepositoryProvider(
            create: (_) => const AuthenticationRepository(),
            child: const RegisterScreen(),
          ),
        
        name: _routeData.route);
        break;
      case Routes.onboard:
        route = _createRoute(
          screen: const OnboardScreen(),

        name: _routeData.route);
        break;
      case Routes.onboardProfile:
      case Routes.editProfile:
        route = _createRoute(
          screen: MultiRepositoryProvider(
            providers: [
              RepositoryProvider(
                create: (_) => const ProfileRepository()
              ),

              RepositoryProvider(
                create: (_) => const GooglePlacesRepository()
              ),
            ],
            child: const ProfileScreen(),
          ),

        name: _routeData.route);
        break;
      case Routes.onboardLocation:
      case Routes.editLocation:
        route = _createRoute(
          screen: RepositoryProvider(
            create: (_) => const GeoAccountRepository(),
            child: _routeData.route == Routes.editLocation
              ? const GeoAccountScreen.edit()
              : const GeoAccountScreen.new(),
          ),

        name: _routeData.route);
        break;
      case Routes.onboardBusinessAccount:
      case Routes.editBusinessAccount:
        route = _createRoute(
          screen: RepositoryProvider(
            create: (_) => const BusinessAccountRepository(),
            child: const BusinessAccountScreen(),
          ),
        
        name: _routeData.route);
        break;
      case Routes.onboardOwners:
      case Routes.editOwners:
        route = _createRoute(
          screen: RepositoryProvider(
            create: (_) => const OwnerRepository(),
            child: const OwnersScreen(),
          ),

        name: _routeData.route);
        break;
      case Routes.onboardPhotos:
      case Routes.editPhotos:
        route = _createRoute(
          screen: MultiRepositoryProvider(
            providers: [
              RepositoryProvider(
                create: (_) => const PhotoPickerRepository(),
              ),

              RepositoryProvider(
                create: (_) => const PhotosRepository()
              )
            ],
            child: const PhotosScreen()
          ),

        name: _routeData.route);
        break;
      case Routes.onboardBank:
      case Routes.editBank:
        route = _createRoute(
          screen: RepositoryProvider(
            create: (_) => const BankRepository(),
            child: const BankScreen(),
          ),

        name: _routeData.route);
        break;
      case Routes.onboardHours:
        route = _createRoute(
          screen: RepositoryProvider(
            create: (_) => const HoursRepository(),
            child: const HoursScreen(),
          ),

        name: _routeData.route);
        break;
      case Routes.editHours:
        route = _createRoute(
          screen: RepositoryProvider(
            create: (_) => const HoursRepository(),
            child: const EditHoursScreen(),
          ),

        name: _routeData.route);
        break;
      case Routes.settings:
        route = _createRoute(
          screen: MultiRepositoryProvider(
            providers: [
              RepositoryProvider(
                create: (_) => const AuthenticationRepository()
              ),
              RepositoryProvider(
                create: (_) => const BusinessRepository()
              )
            ],
            child: const SettingsScreen()
          ),
          
        name: _routeData.route);
        break;
      case Routes.messages:
        route = _createRoute(
          screen: RepositoryProvider(
            create: (_) => const MessageRepository(),
            child: const MessageListScreen(),
          ),
        
        name: _routeData.route);
        break;
      case Routes.resetPassword:
        route = _createRoute(
          screen: RepositoryProvider(
            create: (_) => const AuthenticationRepository(),
            child: ResetPasswordScreen(token: _routeData['token']),
          ),

        name: _routeData.route);
        break;
      default:
        route = _createRoute(screen: const App(), name: '/');
    }
    return route;
  }

  MaterialPageRoute _createRoute({required Widget screen, required String name}) {
    return MaterialPageRoute(
      builder: (_) => screen,
      settings: RouteSettings(name: name)
    );
  }
}