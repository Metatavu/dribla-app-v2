# dribla_api.model.UserProfile

## Load the model package
```dart
import 'package:dribla_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | Users keycloak id (Taken from authentication token) | [optional] 
**characterType** | **int** |  | [optional] 
**characterOutfitType** | **int** |  | [optional] 
**characterShoesType** | **int** |  | [optional] 
**subscriptionStatus** | **bool** | Updated by background payment system | [optional] 
**ownedAppCodes** | **BuiltList&lt;String&gt;** | List of user owned app codes | [optional] 
**appCode** | **String** |  | [optional] 
**createdAt** | [**DateTime**](DateTime.md) | Created date | [optional] 
**modifiedAt** | [**DateTime**](DateTime.md) | Date modified | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


