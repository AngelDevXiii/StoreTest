import 'package:equatable/equatable.dart';

class Response<T> extends Equatable {
  final T data;
  final bool success;
  final String errorMessage;

  const Response({
    required this.data,
    this.success = true,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [data, success, errorMessage];
}
