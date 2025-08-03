import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FolderCubit extends HydratedCubit<String?> {
  FolderCubit() : super(null);

  void setFolder(String path) => emit(path);

  @override
  String? fromJson(Map<String, dynamic> json) => json['path'] as String?;

  @override
  Map<String, dynamic>? toJson(String? state) => {'path': state};
}