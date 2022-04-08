import 'package:dashboard/app.dart';
import 'package:dashboard/blocs/authentication/authentication_bloc.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/providers/authentication_provider.dart';
import 'package:dashboard/providers/bank_provider.dart';
import 'package:dashboard/providers/business_account_provider.dart';
import 'package:dashboard/providers/business_provider.dart';
import 'package:dashboard/providers/geo_account_provider.dart';
import 'package:dashboard/providers/hours_provider.dart';
import 'package:dashboard/providers/message_provider.dart';
import 'package:dashboard/providers/owner_provider.dart';
import 'package:dashboard/providers/photos_provider.dart';
import 'package:dashboard/providers/profile_provider.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:dashboard/repositories/bank_repository.dart';
import 'package:dashboard/repositories/business_account_repository.dart';
import 'package:dashboard/repositories/business_repository.dart';
import 'package:dashboard/repositories/geo_account_repository.dart';
import 'package:dashboard/repositories/hours_repository.dart';
import 'package:dashboard/repositories/message_repository.dart';
import 'package:dashboard/repositories/owner_repository.dart';
import 'package:dashboard/repositories/photo_picker_repository.dart';
import 'package:dashboard/repositories/photos_repository.dart';
import 'package:dashboard/repositories/profile_repository.dart';
import 'package:dashboard/repositories/token_repository.dart';
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
import 'package:google_maps_webservice/places.dart';

import '../dev_keys.dart';


class AppRouter {

  Route goTo({required BuildContext context, required RouteSettings settings}) {
    final RouteData _routeData = RouteData.init(settings: settings);
    Route route;

    switch (_routeData.route) {
      case Routes.app:
        route = _createRoute(screen: const App(), name: _routeData.route);
        break;
      case Routes.login:
        route = _createRoute(screen: LoginScreen(
          authenticationRepository: AuthenticationRepository(tokenRepository: TokenRepository(), authenticationProvider: AuthenticationProvider()),
          authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
        ),
        name: _routeData.route);
        break;
      case Routes.register:
        route = _createRoute(screen: RegisterScreen(
          authenticationRepository: AuthenticationRepository(tokenRepository: TokenRepository(), authenticationProvider: AuthenticationProvider()),
          authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
        ), name: _routeData.route);
        break;
      case Routes.onboard:
        route = _createRoute(screen: OnboardScreen(
          accountStatus: BlocProvider.of<BusinessBloc>(context).business.accounts.accountStatus,
        ),
        name: _routeData.route);
        break;
      case Routes.onboardProfile:
      case Routes.editProfile:
        route = _createRoute(screen: ProfileScreen(
          profileRepository: ProfileRepository(profileProvider: ProfileProvider()),
          profile: BlocProvider.of<BusinessBloc>(context).business.profile,
          businessBloc: BlocProvider.of<BusinessBloc>(context),
          places: GoogleMapsPlaces(
            apiKey: DevKeys.googleKey,
            baseUrl: 'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api'
          ),
        ),
        name: _routeData.route);
        break;
      case Routes.onboardLocation:
      case Routes.editLocation:
        route = _createRoute(screen: GeoAccountScreen(
          geoAccountRepository: GeoAccountRepository(geoAccountProvider: GeoAccountProvider()),
          businessBloc: BlocProvider.of<BusinessBloc>(context),
          location: BlocProvider.of<BusinessBloc>(context).business.location,
          isEdit: _routeData.route == Routes.editLocation
        ),
        name: _routeData.route);
        break;
      case Routes.onboardBusinessAccount:
      case Routes.editBusinessAccount:
        route = _createRoute(
          screen: BusinessAccountScreen(
            businessAccount: BlocProvider.of<BusinessBloc>(context).business.accounts.businessAccount,
            accountRepository: BusinessAccountRepository(accountProvider: BusinessAccountProvider()),
            businessBloc: BlocProvider.of<BusinessBloc>(context),
          ),
          name: _routeData.route);
        break;
      case Routes.onboardOwners:
      case Routes.editOwners:
        route = _createRoute(screen: OwnersScreen(
          ownerRepository: OwnerRepository(ownerProvider: OwnerProvider()),
          businessBloc: BlocProvider.of<BusinessBloc>(context),
          ownerAccounts: BlocProvider.of<BusinessBloc>(context).business.accounts.ownerAccounts,
        ),
        name: _routeData.route);
        break;
      case Routes.onboardPhotos:
      case Routes.editPhotos:
        route = _createRoute(screen: PhotosScreen(
          photoPickerRepository: PhotoPickerRepository(),
          photosRepository: PhotosRepository(photosProvider: PhotosProvider()),
          businessBloc: BlocProvider.of<BusinessBloc>(context),
          photos: BlocProvider.of<BusinessBloc>(context).business.photos,
          profileIdentifier: BlocProvider.of<BusinessBloc>(context).business.profile.identifier,
        ),
        name: _routeData.route);
        break;
      case Routes.onboardBank:
      case Routes.editBank:
        route = _createRoute(
          screen: BankScreen(
            bankAccount: BlocProvider.of<BusinessBloc>(context).business.accounts.bankAccount,
            bankRepository: BankRepository(bankProvider: BankProvider()),
            businessBloc: BlocProvider.of<BusinessBloc>(context),
          ),
          name: _routeData.route
        );
        break;
      case Routes.onboardHours:
        route = _createRoute(screen: HoursScreen(
          hoursRepository: HoursRepository(hoursProvider: HoursProvider()),
          businessBloc: BlocProvider.of<BusinessBloc>(context),
          hours: BlocProvider.of<BusinessBloc>(context).business.profile.hours,
        ),
        name: _routeData.route);
        break;
      case Routes.editHours:
        route = _createRoute(screen: EditHoursScreen(
          hoursRepository:  HoursRepository(hoursProvider: HoursProvider()),
          businessBloc: BlocProvider.of<BusinessBloc>(context),
          hours: BlocProvider.of<BusinessBloc>(context).business.profile.hours,
        ), 
        name: _routeData.route);
        break;
      case Routes.settings:
        route = _createRoute(screen: SettingsScreen(
          authenticationRepository: AuthenticationRepository(tokenRepository: TokenRepository(), authenticationProvider: AuthenticationProvider()),
          businessBloc: BlocProvider.of<BusinessBloc>(context),
          businessRepository: BusinessRepository(businessProvider: BusinessProvider(), tokenRepository: TokenRepository()),
        ),
        name: _routeData.route);
        break;
      case Routes.messages:
        route = _createRoute(screen: MessageListScreen(messageRepository: MessageRepository(messageProvider: MessageProvider()),), name: _routeData.route);
        break;
      case Routes.resetPassword:
        route = _createRoute(screen: ResetPasswordScreen(
          authenticationRepository: AuthenticationRepository(tokenRepository: TokenRepository(), authenticationProvider: AuthenticationProvider()),
          token: _routeData['token']
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