import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starz/api/api_service.dart';

final phoneNumbersProvider = FutureProvider.autoDispose((ref) {
  final apiServices = ref.watch(apiService);

  return apiServices.getPhoneNumber();
});
