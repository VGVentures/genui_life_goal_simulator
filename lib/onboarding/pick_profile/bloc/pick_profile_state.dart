part of 'pick_profile_cubit.dart';

final class PickProfileState extends Equatable {
  const PickProfileState({this.selectedProfile});

  final ProfileType? selectedProfile;

  bool get hasSelection => selectedProfile != null;

  @override
  List<Object?> get props => [selectedProfile];
}
