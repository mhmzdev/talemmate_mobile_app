import 'package:firebase_ai/firebase_ai.dart';

class AgentTools {
  AgentTools._();

  static final _instance = AgentTools._();
  static AgentTools get ins => _instance;

  /// Schema for dream refinement based on [chat_sys_prompt.md]
  /// This will only be used to write a dream refinement prompt for another LLM
  /// to generate an image based on the refined prompt
  Schema get chatSchema => Schema(
    SchemaType.object,
    properties: {
      'responseMessage': Schema(
        SchemaType.string,
        description:
            'A full sentence response to the user\'s original message, incorporating the refined prompt and tags',
        nullable: false,
      ),
      'error': Schema(
        SchemaType.string,
        description: 'Error message if the refinement failed',
        nullable: true,
      ),
    },
  );
}
