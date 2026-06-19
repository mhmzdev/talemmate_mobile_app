import 'package:firebase_ai/firebase_ai.dart';

class AgentTools {
  AgentTools._();

  static final _instance = AgentTools._();
  static AgentTools get ins => _instance;

  /// Structured-output schema for the grounded tutor chat (see
  /// [chat_sys_prompt.md]). Maps 1:1 onto `TutorMessage`: a markdown [text]
  /// answer, the [citations] that back it (referencing the student's library
  /// items by id), suggested [followUpPoints], and an optional
  /// [kickerQuestion]. Fed to `GenerationConfig.responseSchema` so Gemini
  /// always returns parseable JSON.
  Schema get chatSchema => Schema.object(
    properties: {
      'text': Schema.string(
        description:
            "The tutor's answer in markdown, written in the student's "
            'language (Urdu / English / Roman Urdu).',
      ),
      'citations': Schema.array(
        description:
            "Sources from the student's own materials that support the "
            'answer. Empty when the answer comes from general knowledge — '
            'never fabricate a citation.',
        items: Schema.object(
          properties: {
            'source': Schema.string(
              description: 'Human-readable name of the cited material.',
            ),
            'libraryItemId': Schema.string(
              nullable: true,
              description:
                  'The id of the grounded library item, taken from its '
                  '[id | name] tag. Null if not from the materials.',
            ),
            'pageReference': Schema.string(
              nullable: true,
              description: 'Page or section reference, if known.',
            ),
          },
          optionalProperties: ['libraryItemId', 'pageReference'],
        ),
      ),
      'followUpPoints': Schema.array(
        description: 'Up to 3 suggested follow-up explorations.',
        items: Schema.object(
          properties: {
            'label': Schema.string(
              description: 'Short tappable chip label (2-4 words).',
            ),
            'body': Schema.string(
              description: 'The full follow-up question sent if tapped.',
            ),
          },
        ),
      ),
      'kickerQuestion': Schema.string(
        nullable: true,
        description:
            'An optional single question that checks understanding. Null '
            'for simple factual replies.',
      ),
    },
    optionalProperties: ['kickerQuestion'],
  );

  /// Structured-output schema for weekly study-plan generation (see
  /// [plan_sys_prompt.md]). Mirrors `WeekPlan` → `DayPlan` → `StudyBlock`,
  /// omitting the fields the app fills itself (id / scheduleId / dayOfWeek /
  /// status / isAIGenerated / topicId). Fed to `GenerationConfig.responseSchema`
  /// so Gemini always returns parseable JSON.
  Schema get planSchema => Schema.object(
    properties: {
      'aiReasoning': Schema.string(
        description:
            "One short paragraph explaining the week's strategy, in the "
            "student's language (Urdu / English / Roman Urdu).",
      ),
      'days': Schema.array(
        description:
            'Up to 7 day entries covering the week range. Days with no study '
            'are allowed to be omitted.',
        items: Schema.object(
          properties: {
            'date': Schema.string(description: 'ISO-8601 date (yyyy-MM-dd).'),
            'blocks': Schema.array(
              items: Schema.object(
                properties: {
                  'startTime': Schema.string(
                    description: '24h HH:mm, inside an enabled window.',
                  ),
                  'durationMinutes': Schema.integer(
                    description: 'Block length, 20–90.',
                  ),
                  'subjectId': Schema.string(
                    description: 'One of the provided subject ids.',
                  ),
                  'title': Schema.string(
                    description: 'Concise topic/goal for the block.',
                  ),
                  'activities': Schema.string(
                    description: 'Short method line, e.g. "Read + summarize".',
                  ),
                  'aiInsight': Schema.string(
                    nullable: true,
                    description:
                        'Optional gold note for a high-impact block.',
                  ),
                },
                optionalProperties: ['aiInsight'],
              ),
            ),
          },
        ),
      ),
    },
  );

  /// Structured-output schema for the narrow "Why this plan" reasoning rewrite
  /// (see [plan_reason_sys_prompt.md]). A single short paragraph that replaces
  /// `Schedule.aiReasoning` after a block is rescheduled — no day/block payload.
  Schema get reasonSchema => Schema.object(
    properties: {
      'aiReasoning': Schema.string(
        description:
            'One short paragraph: why the plan still works after the change, '
            "in the student's language (Urdu / English / Roman Urdu).",
      ),
    },
  );

  /// Structured-output schema for single-answer MCQ quiz generation (see
  /// [quiz_sys_prompt.md]). Maps onto `Quiz` → `QuizQuestion`, omitting the
  /// fields the app fills itself (id / quizId / index / type / markValue). Fed to
  /// `GenerationConfig.responseSchema` so Gemini always returns parseable JSON.
  Schema get quizSchema => Schema.object(
    properties: {
      'sourceLabel': Schema.string(
        nullable: true,
        description:
            'Short basis label, e.g. "Generated from Lec 12" when grounded on a '
            'material, else the subject name.',
      ),
      'questions': Schema.array(
        description: 'Exactly the requested number of single-answer MCQs.',
        items: Schema.object(
          properties: {
            'text': Schema.string(description: 'The question stem.'),
            'options': Schema.array(
              description: 'Exactly 4 answer options.',
              items: Schema.string(),
            ),
            'correctAnswerIndex': Schema.integer(
              description: 'Index (0–3) of the single correct option.',
            ),
            'explanation': Schema.string(
              description:
                  'Why the correct option is right (and others wrong), '
                  "in the student's language.",
            ),
            'citation': Schema.string(
              nullable: true,
              description:
                  'Source ref (material name + locator) when grounded; '
                  'omit when not grounded.',
            ),
          },
          optionalProperties: ['citation'],
        ),
      ),
    },
    optionalProperties: ['sourceLabel'],
  );

  /// Structured-output schema for the exam-readiness assessment (see
  /// [progress_sys_prompt.md]). One entry per subject (readiness + predicted
  /// band + momentum + a per-subject note) plus one global study insight. Maps
  /// onto `ProgressMetric` (per subject) and the cubit-held `studyInsight`. Fed
  /// to `GenerationConfig.responseSchema` so Gemini always returns parseable
  /// JSON.
  Schema get progressSchema => Schema.object(
    properties: {
      'subjects': Schema.array(
        description: 'One entry per input subject, keyed by its exact id.',
        items: Schema.object(
          properties: {
            'subjectId': Schema.string(
              description: 'One of the provided subject ids.',
            ),
            'readinessScore': Schema.integer(
              description: '0–100 estimate of exam preparedness.',
            ),
            'predictedScoreMin': Schema.integer(
              description: 'Low end of the predicted exam score band (0–100).',
            ),
            'predictedScoreMax': Schema.integer(
              description: 'High end of the predicted exam score band (0–100).',
            ),
            'weeklyGain': Schema.integer(
              description: 'Signed week-over-week momentum, roughly -10..+10.',
            ),
            'aiInsight': Schema.string(
              description:
                  'One short, concrete, encouraging per-subject note in the '
                  "student's language.",
            ),
          },
        ),
      ),
      'studyInsight': Schema.string(
        description:
            'One short global study-pattern / retention insight in the '
            "student's language.",
      ),
    },
  );
}
