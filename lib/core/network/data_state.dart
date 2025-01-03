import 'dart:convert';
import 'dart:io';

import 'package:kasirku_flutter/core/network/base_response.dart';
import 'package:retrofit/dio.dart';
import 'package:dio/dio.dart';

class DataState<T> extends BaseResponse {
  final T? data;
  DataState({required super.success, required super.message, this.data});

  factory DataState.fromJson(Map<String, dynamic> json) => DataState(
      success: json['success'] ?? false, 
      message: json['message']?.toString() ?? 'No message', 
      data: json['data']);
}

class SuccessState<T> extends DataState<T> {
  SuccessState({super.data, super.message = 'Success'})
      : super(success: true);
}

class ErrorState<T> extends DataState<T> {
  ErrorState(String message) : super(success: false, message: message);
  factory ErrorState.fromJson(Map<String, dynamic> json) =>
      ErrorState(json['message']);
}

Future<DataState<T>> handleResponse<T>(
    Future<HttpResponse<DataState>> Function() apiCall,
    T Function(dynamic) mapDataSuccess) async {
  try {
    final HttpResponse<DataState> httpResponse = await apiCall();
    if (httpResponse.response.statusCode == HttpStatus.ok) {
      final response = httpResponse.data;
      if (response.success) {
        return SuccessState(
            data: mapDataSuccess(response.data), message: response.message);
      } else {
        return ErrorState(response.message);
      }
    } else {
      return ErrorState(
          '${httpResponse.response.statusCode} : ${httpResponse.response.statusMessage}');
    }
  } on DioException catch (e) {
    try {
      final response = ErrorState.fromJson(jsonDecode(e.response.toString()));
      return ErrorState(
          '${e.response?.statusCode ?? ''} : ${response.message}');
    } catch (e1) {
      return ErrorState(
        '${e.response?.statusCode ?? ''} : ${e.response?.statusMessage ?? ''}',
      );
    }
  } catch (e) {
    return ErrorState(e.toString());
  }
}
