# dribla_api.api.SystemApi

## Load the API package
```dart
import 'package:dribla_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**ping**](SystemApi.md#ping) | **GET** /v1/system/ping | Replies with pong


# **ping**
> String ping()

Replies with pong

Replies ping with pong

### Example
```dart
import 'package:dribla_api/api.dart';

final api = DriblaApi().getSystemApi();

try {
    final response = api.ping();
    print(response);
} catch on DioException (e) {
    print('Exception when calling SystemApi->ping: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

**String**

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

