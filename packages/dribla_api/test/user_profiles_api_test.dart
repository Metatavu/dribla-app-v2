import 'package:test/test.dart';
import 'package:dribla_api/dribla_api.dart';

/// tests for UserProfilesApi
void main() {
  final instance = DriblaApi().getUserProfilesApi();

  group(UserProfilesApi, () {
    // Find user profile
    //
    // Finds a user profile by id
    //
    //Future<UserProfile> findUserProfile(String userProfileId) async
    test('test findUserProfile', () async {
      // TODO
    });

    // Updates or creates user profile
    //
    // Updates or creates user profile
    //
    //Future<UserProfile> upsertUserProfile(String userProfileId, UserProfile userProfile) async
    test('test upsertUserProfile', () async {
      // TODO
    });
  });
}
