# dribla_api.api.UserProfilesApi

## Load the API package
```dart
import 'package:dribla_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**findUserProfile**](UserProfilesApi.md#finduserprofile) | **GET** /v1/userProfiles/{userProfileId} | Find user profile
[**upsertUserProfile**](UserProfilesApi.md#upsertuserprofile) | **PUT** /v1/userProfiles/{userProfileId} | Updates or creates user profile


# **findUserProfile**
> UserProfile findUserProfile(userProfileId)

Find user profile

Finds a user profile by id

### Example
```dart
import 'package:dribla_api/api.dart';

final api = DriblaApi().getUserProfilesApi();
final String userProfileId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Users keycloak id

try {
    final response = api.findUserProfile(userProfileId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling UserProfilesApi->findUserProfile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userProfileId** | **String**| Users keycloak id | 

### Return type

[**UserProfile**](UserProfile.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **upsertUserProfile**
> UserProfile upsertUserProfile(userProfileId, userProfile)

Updates or creates user profile

Updates or creates user profile

### Example
```dart
import 'package:dribla_api/api.dart';

final api = DriblaApi().getUserProfilesApi();
final String userProfileId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Users keycloak id
final UserProfile userProfile = ; // UserProfile | Payload

try {
    final response = api.upsertUserProfile(userProfileId, userProfile);
    print(response);
} catch on DioException (e) {
    print('Exception when calling UserProfilesApi->upsertUserProfile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userProfileId** | **String**| Users keycloak id | 
 **userProfile** | [**UserProfile**](UserProfile.md)| Payload | 

### Return type

[**UserProfile**](UserProfile.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

