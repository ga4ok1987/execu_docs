import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class FolderCubit extends HydratedCubit<FolderState> {
  FolderCubit() : super(const FolderState());

  void setFolder1(String path) => emit(state.copyWith(path1: path));
  void setFolder2(String path) => emit(state.copyWith(path2: path));

  @override
  FolderState? fromJson(Map<String, dynamic> json) =>
      FolderState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(FolderState state) => state.toJson();
}

class FolderState {
  final String? path1;
  final String? path2;

  const FolderState({this.path1, this.path2});

  Map<String, dynamic> toJson() => {
    'path1': path1,
    'path2': path2,
  };

  factory FolderState.fromJson(Map<String, dynamic> json) => FolderState(
    path1: json['path1'] as String?,
    path2: json['path2'] as String?,
  );

  FolderState copyWith({String? path1, String? path2}) =>
      FolderState(path1: path1 ?? this.path1, path2: path2 ?? this.path2);
}

