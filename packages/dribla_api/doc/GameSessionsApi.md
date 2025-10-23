# dribla_api.api.GameSessionsApi

## Load the API package
```dart
import 'package:dribla_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**creategameSession**](GameSessionsApi.md#creategamesession) | **POST** /v1/gameSessions | Create a gameSession.
[**getGameSessionsSummary**](GameSessionsApi.md#getgamesessionssummary) | **GET** /v1/gameSessions/summary | Creates summary of game sessions
[**listgameSessions**](GameSessionsApi.md#listgamesessions) | **GET** /v1/gameSessions | Lists gameSessions.


# **creategameSession**
> GameSession creategameSession(gameSession)

Create a gameSession.

Creates a new gameSession.

### Example
```dart
import 'package:dribla_api/api.dart';

final api = DriblaApi().getGameSessionsApi();
final GameSession gameSession = ; // GameSession | Payload

try {
    final response = api.creategameSession(gameSession);
    print(response);
} catch on DioException (e) {
    print('Exception when calling GameSessionsApi->creategameSession: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **gameSession** | [**GameSession**](GameSession.md)| Payload | 

### Return type

[**GameSession**](GameSession.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getGameSessionsSummary**
> GameSessionSummary getGameSessionsSummary(createdBefore, createdAfter, userId, game)

Creates summary of game sessions

Creates summary of game sessions

### Example
```dart
import 'package:dribla_api/api.dart';

final api = DriblaApi().getGameSessionsApi();
final DateTime createdBefore = 2013-10-20T19:20:30+01:00; // DateTime | Filter results created before specified time
final DateTime createdAfter = 2013-10-20T19:20:30+01:00; // DateTime | Filter results created after specified time
final String userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Filter gameSessions by userId
final String game = game_example; // String | Filter gameSessions by game

try {
    final response = api.getGameSessionsSummary(createdBefore, createdAfter, userId, game);
    print(response);
} catch on DioException (e) {
    print('Exception when calling GameSessionsApi->getGameSessionsSummary: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createdBefore** | **DateTime**| Filter results created before specified time | 
 **createdAfter** | **DateTime**| Filter results created after specified time | 
 **userId** | **String**| Filter gameSessions by userId | [optional] 
 **game** | **String**| Filter gameSessions by game | [optional] 

### Return type

[**GameSessionSummary**](GameSessionSummary.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listgameSessions**
> BuiltList<GameSession> listgameSessions(userId, game, createdBefore, createdAfter, sortBy, sortOrder, page, pageSize)

Lists gameSessions.

Lists gameSessions.

### Example
```dart
import 'package:dribla_api/api.dart';

final api = DriblaApi().getGameSessionsApi();
final String userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Filter gameSessions by userId
final String game = game_example; // String | Filter gameSessions by game
final DateTime createdBefore = 2013-10-20T19:20:30+01:00; // DateTime | Filter results created before specified time
final DateTime createdAfter = 2013-10-20T19:20:30+01:00; // DateTime | Filter results created after specified time
final String sortBy = sortBy_example; // String | Sort results by specific field. (Default to created_at)
final String sortOrder = sortOrder_example; // String | Sort order (Default to ASC)
final int page = 56; // int | Page number. Defaults to 0
final int pageSize = 56; // int | Page size. Defaults to 10

try {
    final response = api.listgameSessions(userId, game, createdBefore, createdAfter, sortBy, sortOrder, page, pageSize);
    print(response);
} catch on DioException (e) {
    print('Exception when calling GameSessionsApi->listgameSessions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**| Filter gameSessions by userId | [optional] 
 **game** | **String**| Filter gameSessions by game | [optional] 
 **createdBefore** | **DateTime**| Filter results created before specified time | [optional] 
 **createdAfter** | **DateTime**| Filter results created after specified time | [optional] 
 **sortBy** | **String**| Sort results by specific field. (Default to created_at) | [optional] 
 **sortOrder** | **String**| Sort order (Default to ASC) | [optional] 
 **page** | **int**| Page number. Defaults to 0 | [optional] 
 **pageSize** | **int**| Page size. Defaults to 10 | [optional] 

### Return type

[**BuiltList&lt;GameSession&gt;**](GameSession.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

