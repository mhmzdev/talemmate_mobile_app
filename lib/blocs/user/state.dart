part of 'cubit.dart';

@immutable
class UserState extends Equatable {
  // --- nested states --- //
  final BlocState<UserData> init;
  final BlocState<UserData> login;
  final BlocState<UserData> update;
  final BlocState<UserData> fetch;
  final BlocState<UserData> forgot;
  final BlocState<UserData> logout;
  final BlocState<UserData> deleteAccount;

  // --- state data --- //

  const UserState({
    required this.init,
    required this.login,
    required this.update,
    required this.fetch,
    required this.forgot,
    required this.logout,
    required this.deleteAccount,
  });

  UserState.def()
    : // root-def-constructor
      init = BlocState(),
      login = BlocState(),
      update = BlocState(),
      fetch = BlocState(),
      forgot = BlocState(),
      logout = BlocState(),
      deleteAccount = BlocState();

  UserState copyWith({
    BlocState<UserData>? init,
    BlocState<UserData>? login,
    BlocState<UserData>? update,
    BlocState<UserData>? fetch,
    BlocState<UserData>? forgot,
    BlocState<UserData>? logout,
    BlocState<UserData>? deleteAccount,
  }) {
    return UserState(
      init: init ?? this.init,
      login: login ?? this.login,
      update: update ?? this.update,
      fetch: fetch ?? this.fetch,
      forgot: forgot ?? this.forgot,
      logout: logout ?? this.logout,
      deleteAccount: deleteAccount ?? this.deleteAccount,
    );
  }

  @override
  List<Object?> get props => [
    // root-state-props
    init,
    login,
    update,
    fetch,
    forgot,
    logout,
    deleteAccount,
  ];
}
