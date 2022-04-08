import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'accounts.dart';
import 'location.dart';
import 'photos.dart';
import 'pos_account.dart';
import 'profile.dart';

@immutable
class Business extends Equatable {
  final String identifier;
  final String email;
  final Profile profile;
  final Photos photos;
  final Accounts accounts;
  final Location location;
  final PosAccount posAccount;

  const Business({
    required this.identifier,
    required this.email,
    required this.profile,
    required this.photos,
    required this.accounts,
    required this.location,
    required this.posAccount
  });

  Business.fromJson({required Map<String, dynamic> json})
    : identifier = json['identifier']!,
      email = json['email']!,
      profile = json['profile'] != null 
        ? Profile.fromJson(json: json['profile']) 
        : Profile.empty(),
      photos = json['photos'] != null 
        ? Photos.fromJson(json: json['photos'])
        : Photos.empty(),
      accounts = json['accounts'] != null
        ? Accounts.fromJson(json: json['accounts'])
        : Accounts.empty(),
      location = json['location'] != null 
        ? Location.fromJson(json: json['location']) 
        : Location.empty(),
      posAccount = json['pos_account'] != null 
        ? PosAccount.fromJson(json: json['pos_account'])
        : PosAccount.empty();

  Business update({
    String? identifier,
    String? email,
    Profile? profile,
    Photos? photos,
    Accounts? accounts,
    Location? location,
    PosAccount? posAccount
  }) {
    return Business(
      identifier: identifier ?? this.identifier, 
      email: email ?? this.email, 
      profile: profile ?? this.profile, 
      photos: photos ?? this.photos, 
      accounts: accounts ?? this.accounts, 
      location: location ?? this.location, 
      posAccount: posAccount ?? this.posAccount
    );
  }

  @override
  List<Object> get props => [
    identifier,
    email,
    profile,
    photos,
    accounts,
    location,
    posAccount
  ];

  @override
  String toString() => '''Business {
    identifier: $identifier,
    email: $email,
    profile: $profile,
    photos: $photos,
    accounts: $accounts,
    location: $location,
    posAccount: $posAccount
  }''';
}