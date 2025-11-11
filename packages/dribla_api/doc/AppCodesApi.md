# dribla_api.api.AppCodesApi

## Load the API package
```dart
import 'package:dribla_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createAppCodes**](AppCodesApi.md#createappcodes) | **POST** /v1/appCodes/{userProfileId}/create | Create app codes using subscription id
[**registerAppCode**](AppCodesApi.md#registerappcode) | **POST** /v1/appCodes/{userProfileId}/register | Registers app code for user


# **createAppCodes**
> UserProfile createAppCodes(userProfileId, appCodeCreationRequest)

Create app codes using subscription id

Create app codes using subscription id

### Example
```dart
import 'package:dribla_api/api.dart';

final api = DriblaApi().getAppCodesApi();
final String userProfileId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Users keycloak id
final AppCodeCreationRequest appCodeCreationRequest = ; // AppCodeCreationRequest | Payload

try {
    final response = api.createAppCodes(userProfileId, appCodeCreationRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AppCodesApi->createAppCodes: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userProfileId** | **String**| Users keycloak id | 
 **appCodeCreationRequest** | [**AppCodeCreationRequest**](AppCodeCreationRequest.md)| Payload | 

### Return type

[**UserProfile**](UserProfile.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **registerAppCode**
> UserProfile registerAppCode(userProfileId, appCodeRegistrationRequest)

Registers app code for user

Registers app code for user

### Example
```dart
import 'package:dribla_api/api.dart';

final api = DriblaApi().getAppCodesApi();
final String userProfileId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Users keycloak id
final AppCodeRegistrationRequest appCodeRegistrationRequest = ; // AppCodeRegistrationRequest | Payload

try {
    final response = api.registerAppCode(userProfileId, appCodeRegistrationRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AppCodesApi->registerAppCode: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userProfileId** | **String**| Users keycloak id | 
 **appCodeRegistrationRequest** | [**AppCodeRegistrationRequest**](AppCodeRegistrationRequest.md)| Payload | 

### Return type

[**UserProfile**](UserProfile.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

