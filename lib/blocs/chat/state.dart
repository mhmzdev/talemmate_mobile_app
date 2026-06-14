part of 'cubit.dart';

@immutable
class ChatState extends Equatable {
  // --- nested states --- //
  final BlocState<TutorMessage> send;
  final BlocState<TutorSettings> settings;

  // --- state data --- //
  final String? userId;
  final List<TutorConversation> conversations;
  final TutorConversation? active;
  final List<TutorMessage> messages;

  const ChatState({
    required this.send,
    required this.settings,
    this.userId,
    this.conversations = const [],
    this.active,
    this.messages = const [],
  });

  ChatState.def()
    : // root-def-constructor
      send = BlocState(),
      settings = BlocState(),
      userId = null,
      conversations = const [],
      active = null,
      messages = const [];

  ChatState copyWith({
    BlocState<TutorMessage>? send,
    BlocState<TutorSettings>? settings,
    String? userId,
    List<TutorConversation>? conversations,
    TutorConversation? active,
    List<TutorMessage>? messages,
  }) {
    return ChatState(
      send: send ?? this.send,
      settings: settings ?? this.settings,
      userId: userId ?? this.userId,
      conversations: conversations ?? this.conversations,
      active: active ?? this.active,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [
    // root-state-props
    send,
    settings,
    userId,
    conversations,
    active,
    messages,
  ];
}
