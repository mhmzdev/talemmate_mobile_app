// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SubjectsTable extends Subjects
    with TableInfo<$SubjectsTable, SubjectRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confidenceLevelMeta = const VerificationMeta(
    'confidenceLevel',
  );
  @override
  late final GeneratedColumn<double> confidenceLevel = GeneratedColumn<double>(
    'confidence_level',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    code,
    name,
    colorHex,
    confidenceLevel,
    order,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subjects';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubjectRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    } else if (isInserting) {
      context.missing(_colorHexMeta);
    }
    if (data.containsKey('confidence_level')) {
      context.handle(
        _confidenceLevelMeta,
        confidenceLevel.isAcceptableOrUnknown(
          data['confidence_level']!,
          _confidenceLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_confidenceLevelMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubjectRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubjectRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      )!,
      confidenceLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence_level'],
      )!,
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
    );
  }

  @override
  $SubjectsTable createAlias(String alias) {
    return $SubjectsTable(attachedDatabase, alias);
  }
}

class SubjectRow extends DataClass implements Insertable<SubjectRow> {
  final String id;

  /// Owning user — subjects are per-account (ADR-014). Defaulted to '' so the
  /// v3→v4 `addColumn` migration is non-breaking; pre-existing rows orphan
  /// (match no real uid) rather than leaking across accounts.
  final String userId;
  final String code;
  final String name;
  final String colorHex;
  final double confidenceLevel;
  final int order;
  const SubjectRow({
    required this.id,
    required this.userId,
    required this.code,
    required this.name,
    required this.colorHex,
    required this.confidenceLevel,
    required this.order,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    map['color_hex'] = Variable<String>(colorHex);
    map['confidence_level'] = Variable<double>(confidenceLevel);
    map['order'] = Variable<int>(order);
    return map;
  }

  SubjectsCompanion toCompanion(bool nullToAbsent) {
    return SubjectsCompanion(
      id: Value(id),
      userId: Value(userId),
      code: Value(code),
      name: Value(name),
      colorHex: Value(colorHex),
      confidenceLevel: Value(confidenceLevel),
      order: Value(order),
    );
  }

  factory SubjectRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubjectRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      confidenceLevel: serializer.fromJson<double>(json['confidenceLevel']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'colorHex': serializer.toJson<String>(colorHex),
      'confidenceLevel': serializer.toJson<double>(confidenceLevel),
      'order': serializer.toJson<int>(order),
    };
  }

  SubjectRow copyWith({
    String? id,
    String? userId,
    String? code,
    String? name,
    String? colorHex,
    double? confidenceLevel,
    int? order,
  }) => SubjectRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    code: code ?? this.code,
    name: name ?? this.name,
    colorHex: colorHex ?? this.colorHex,
    confidenceLevel: confidenceLevel ?? this.confidenceLevel,
    order: order ?? this.order,
  );
  SubjectRow copyWithCompanion(SubjectsCompanion data) {
    return SubjectRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      confidenceLevel: data.confidenceLevel.present
          ? data.confidenceLevel.value
          : this.confidenceLevel,
      order: data.order.present ? data.order.value : this.order,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubjectRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('colorHex: $colorHex, ')
          ..write('confidenceLevel: $confidenceLevel, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, code, name, colorHex, confidenceLevel, order);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubjectRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.code == this.code &&
          other.name == this.name &&
          other.colorHex == this.colorHex &&
          other.confidenceLevel == this.confidenceLevel &&
          other.order == this.order);
}

class SubjectsCompanion extends UpdateCompanion<SubjectRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> code;
  final Value<String> name;
  final Value<String> colorHex;
  final Value<double> confidenceLevel;
  final Value<int> order;
  final Value<int> rowid;
  const SubjectsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.confidenceLevel = const Value.absent(),
    this.order = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubjectsCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    required String code,
    required String name,
    required String colorHex,
    required double confidenceLevel,
    this.order = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code),
       name = Value(name),
       colorHex = Value(colorHex),
       confidenceLevel = Value(confidenceLevel);
  static Insertable<SubjectRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? colorHex,
    Expression<double>? confidenceLevel,
    Expression<int>? order,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (colorHex != null) 'color_hex': colorHex,
      if (confidenceLevel != null) 'confidence_level': confidenceLevel,
      if (order != null) 'order': order,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubjectsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? code,
    Value<String>? name,
    Value<String>? colorHex,
    Value<double>? confidenceLevel,
    Value<int>? order,
    Value<int>? rowid,
  }) {
    return SubjectsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      code: code ?? this.code,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
      confidenceLevel: confidenceLevel ?? this.confidenceLevel,
      order: order ?? this.order,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (confidenceLevel.present) {
      map['confidence_level'] = Variable<double>(confidenceLevel.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('colorHex: $colorHex, ')
          ..write('confidenceLevel: $confidenceLevel, ')
          ..write('order: $order, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TopicsTable extends Topics with TableInfo<$TopicsTable, TopicRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TopicsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subjects (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _masteryPercentageMeta = const VerificationMeta(
    'masteryPercentage',
  );
  @override
  late final GeneratedColumn<int> masteryPercentage = GeneratedColumn<int>(
    'mastery_percentage',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TrendType, String> trend =
      GeneratedColumn<String>(
        'trend',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TrendType>($TopicsTable.$convertertrend);
  static const VerificationMeta _isWeakMeta = const VerificationMeta('isWeak');
  @override
  late final GeneratedColumn<bool> isWeak = GeneratedColumn<bool>(
    'is_weak',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_weak" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    subjectId,
    name,
    masteryPercentage,
    trend,
    isWeak,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'topics';
  @override
  VerificationContext validateIntegrity(
    Insertable<TopicRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('mastery_percentage')) {
      context.handle(
        _masteryPercentageMeta,
        masteryPercentage.isAcceptableOrUnknown(
          data['mastery_percentage']!,
          _masteryPercentageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_masteryPercentageMeta);
    }
    if (data.containsKey('is_weak')) {
      context.handle(
        _isWeakMeta,
        isWeak.isAcceptableOrUnknown(data['is_weak']!, _isWeakMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TopicRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TopicRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      masteryPercentage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mastery_percentage'],
      )!,
      trend: $TopicsTable.$convertertrend.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}trend'],
        )!,
      ),
      isWeak: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_weak'],
      )!,
    );
  }

  @override
  $TopicsTable createAlias(String alias) {
    return $TopicsTable(attachedDatabase, alias);
  }

  static TypeConverter<TrendType, String> $convertertrend =
      const EnumConverter<TrendType>(TrendType.values);
}

class TopicRow extends DataClass implements Insertable<TopicRow> {
  final String id;
  final String subjectId;
  final String name;
  final int masteryPercentage;
  final TrendType trend;
  final bool isWeak;
  const TopicRow({
    required this.id,
    required this.subjectId,
    required this.name,
    required this.masteryPercentage,
    required this.trend,
    required this.isWeak,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['subject_id'] = Variable<String>(subjectId);
    map['name'] = Variable<String>(name);
    map['mastery_percentage'] = Variable<int>(masteryPercentage);
    {
      map['trend'] = Variable<String>(
        $TopicsTable.$convertertrend.toSql(trend),
      );
    }
    map['is_weak'] = Variable<bool>(isWeak);
    return map;
  }

  TopicsCompanion toCompanion(bool nullToAbsent) {
    return TopicsCompanion(
      id: Value(id),
      subjectId: Value(subjectId),
      name: Value(name),
      masteryPercentage: Value(masteryPercentage),
      trend: Value(trend),
      isWeak: Value(isWeak),
    );
  }

  factory TopicRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TopicRow(
      id: serializer.fromJson<String>(json['id']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      name: serializer.fromJson<String>(json['name']),
      masteryPercentage: serializer.fromJson<int>(json['masteryPercentage']),
      trend: serializer.fromJson<TrendType>(json['trend']),
      isWeak: serializer.fromJson<bool>(json['isWeak']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subjectId': serializer.toJson<String>(subjectId),
      'name': serializer.toJson<String>(name),
      'masteryPercentage': serializer.toJson<int>(masteryPercentage),
      'trend': serializer.toJson<TrendType>(trend),
      'isWeak': serializer.toJson<bool>(isWeak),
    };
  }

  TopicRow copyWith({
    String? id,
    String? subjectId,
    String? name,
    int? masteryPercentage,
    TrendType? trend,
    bool? isWeak,
  }) => TopicRow(
    id: id ?? this.id,
    subjectId: subjectId ?? this.subjectId,
    name: name ?? this.name,
    masteryPercentage: masteryPercentage ?? this.masteryPercentage,
    trend: trend ?? this.trend,
    isWeak: isWeak ?? this.isWeak,
  );
  TopicRow copyWithCompanion(TopicsCompanion data) {
    return TopicRow(
      id: data.id.present ? data.id.value : this.id,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      name: data.name.present ? data.name.value : this.name,
      masteryPercentage: data.masteryPercentage.present
          ? data.masteryPercentage.value
          : this.masteryPercentage,
      trend: data.trend.present ? data.trend.value : this.trend,
      isWeak: data.isWeak.present ? data.isWeak.value : this.isWeak,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TopicRow(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('name: $name, ')
          ..write('masteryPercentage: $masteryPercentage, ')
          ..write('trend: $trend, ')
          ..write('isWeak: $isWeak')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, subjectId, name, masteryPercentage, trend, isWeak);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TopicRow &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.name == this.name &&
          other.masteryPercentage == this.masteryPercentage &&
          other.trend == this.trend &&
          other.isWeak == this.isWeak);
}

class TopicsCompanion extends UpdateCompanion<TopicRow> {
  final Value<String> id;
  final Value<String> subjectId;
  final Value<String> name;
  final Value<int> masteryPercentage;
  final Value<TrendType> trend;
  final Value<bool> isWeak;
  final Value<int> rowid;
  const TopicsCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.name = const Value.absent(),
    this.masteryPercentage = const Value.absent(),
    this.trend = const Value.absent(),
    this.isWeak = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TopicsCompanion.insert({
    required String id,
    required String subjectId,
    required String name,
    required int masteryPercentage,
    required TrendType trend,
    this.isWeak = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       subjectId = Value(subjectId),
       name = Value(name),
       masteryPercentage = Value(masteryPercentage),
       trend = Value(trend);
  static Insertable<TopicRow> custom({
    Expression<String>? id,
    Expression<String>? subjectId,
    Expression<String>? name,
    Expression<int>? masteryPercentage,
    Expression<String>? trend,
    Expression<bool>? isWeak,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (name != null) 'name': name,
      if (masteryPercentage != null) 'mastery_percentage': masteryPercentage,
      if (trend != null) 'trend': trend,
      if (isWeak != null) 'is_weak': isWeak,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TopicsCompanion copyWith({
    Value<String>? id,
    Value<String>? subjectId,
    Value<String>? name,
    Value<int>? masteryPercentage,
    Value<TrendType>? trend,
    Value<bool>? isWeak,
    Value<int>? rowid,
  }) {
    return TopicsCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      name: name ?? this.name,
      masteryPercentage: masteryPercentage ?? this.masteryPercentage,
      trend: trend ?? this.trend,
      isWeak: isWeak ?? this.isWeak,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (masteryPercentage.present) {
      map['mastery_percentage'] = Variable<int>(masteryPercentage.value);
    }
    if (trend.present) {
      map['trend'] = Variable<String>(
        $TopicsTable.$convertertrend.toSql(trend.value),
      );
    }
    if (isWeak.present) {
      map['is_weak'] = Variable<bool>(isWeak.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TopicsCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('name: $name, ')
          ..write('masteryPercentage: $masteryPercentage, ')
          ..write('trend: $trend, ')
          ..write('isWeak: $isWeak, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExamsTable extends Exams with TableInfo<$ExamsTable, ExamRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subjects (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, userId, subjectId, date, label];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exams';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExamRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExamRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExamRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      ),
    );
  }

  @override
  $ExamsTable createAlias(String alias) {
    return $ExamsTable(attachedDatabase, alias);
  }
}

class ExamRow extends DataClass implements Insertable<ExamRow> {
  final String id;

  /// Owning user — scoped alongside [Subjects] (ADR-014). See the note there.
  final String userId;
  final String subjectId;
  final DateTime date;
  final String? label;
  const ExamRow({
    required this.id,
    required this.userId,
    required this.subjectId,
    required this.date,
    this.label,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['subject_id'] = Variable<String>(subjectId);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    return map;
  }

  ExamsCompanion toCompanion(bool nullToAbsent) {
    return ExamsCompanion(
      id: Value(id),
      userId: Value(userId),
      subjectId: Value(subjectId),
      date: Value(date),
      label: label == null && nullToAbsent
          ? const Value.absent()
          : Value(label),
    );
  }

  factory ExamRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExamRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      date: serializer.fromJson<DateTime>(json['date']),
      label: serializer.fromJson<String?>(json['label']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'subjectId': serializer.toJson<String>(subjectId),
      'date': serializer.toJson<DateTime>(date),
      'label': serializer.toJson<String?>(label),
    };
  }

  ExamRow copyWith({
    String? id,
    String? userId,
    String? subjectId,
    DateTime? date,
    Value<String?> label = const Value.absent(),
  }) => ExamRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    subjectId: subjectId ?? this.subjectId,
    date: date ?? this.date,
    label: label.present ? label.value : this.label,
  );
  ExamRow copyWithCompanion(ExamsCompanion data) {
    return ExamRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      date: data.date.present ? data.date.value : this.date,
      label: data.label.present ? data.label.value : this.label,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExamRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('subjectId: $subjectId, ')
          ..write('date: $date, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, subjectId, date, label);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExamRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.subjectId == this.subjectId &&
          other.date == this.date &&
          other.label == this.label);
}

class ExamsCompanion extends UpdateCompanion<ExamRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> subjectId;
  final Value<DateTime> date;
  final Value<String?> label;
  final Value<int> rowid;
  const ExamsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.date = const Value.absent(),
    this.label = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExamsCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    required String subjectId,
    required DateTime date,
    this.label = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       subjectId = Value(subjectId),
       date = Value(date);
  static Insertable<ExamRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? subjectId,
    Expression<DateTime>? date,
    Expression<String>? label,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (subjectId != null) 'subject_id': subjectId,
      if (date != null) 'date': date,
      if (label != null) 'label': label,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExamsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? subjectId,
    Value<DateTime>? date,
    Value<String?>? label,
    Value<int>? rowid,
  }) {
    return ExamsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      subjectId: subjectId ?? this.subjectId,
      date: date ?? this.date,
      label: label ?? this.label,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('subjectId: $subjectId, ')
          ..write('date: $date, ')
          ..write('label: $label, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudyWindowsTable extends StudyWindows
    with TableInfo<$StudyWindowsTable, StudyWindowRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyWindowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    label,
    startTime,
    endTime,
    isEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_windows';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudyWindowRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudyWindowRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyWindowRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_time'],
      )!,
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
    );
  }

  @override
  $StudyWindowsTable createAlias(String alias) {
    return $StudyWindowsTable(attachedDatabase, alias);
  }
}

class StudyWindowRow extends DataClass implements Insertable<StudyWindowRow> {
  final String id;
  final String label;
  final String startTime;
  final String endTime;
  final bool isEnabled;
  const StudyWindowRow({
    required this.id,
    required this.label,
    required this.startTime,
    required this.endTime,
    required this.isEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    map['start_time'] = Variable<String>(startTime);
    map['end_time'] = Variable<String>(endTime);
    map['is_enabled'] = Variable<bool>(isEnabled);
    return map;
  }

  StudyWindowsCompanion toCompanion(bool nullToAbsent) {
    return StudyWindowsCompanion(
      id: Value(id),
      label: Value(label),
      startTime: Value(startTime),
      endTime: Value(endTime),
      isEnabled: Value(isEnabled),
    );
  }

  factory StudyWindowRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyWindowRow(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      startTime: serializer.fromJson<String>(json['startTime']),
      endTime: serializer.fromJson<String>(json['endTime']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'startTime': serializer.toJson<String>(startTime),
      'endTime': serializer.toJson<String>(endTime),
      'isEnabled': serializer.toJson<bool>(isEnabled),
    };
  }

  StudyWindowRow copyWith({
    String? id,
    String? label,
    String? startTime,
    String? endTime,
    bool? isEnabled,
  }) => StudyWindowRow(
    id: id ?? this.id,
    label: label ?? this.label,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    isEnabled: isEnabled ?? this.isEnabled,
  );
  StudyWindowRow copyWithCompanion(StudyWindowsCompanion data) {
    return StudyWindowRow(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyWindowRow(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('isEnabled: $isEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, label, startTime, endTime, isEnabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyWindowRow &&
          other.id == this.id &&
          other.label == this.label &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.isEnabled == this.isEnabled);
}

class StudyWindowsCompanion extends UpdateCompanion<StudyWindowRow> {
  final Value<String> id;
  final Value<String> label;
  final Value<String> startTime;
  final Value<String> endTime;
  final Value<bool> isEnabled;
  final Value<int> rowid;
  const StudyWindowsCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyWindowsCompanion.insert({
    required String id,
    required String label,
    required String startTime,
    required String endTime,
    this.isEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       label = Value(label),
       startTime = Value(startTime),
       endTime = Value(endTime);
  static Insertable<StudyWindowRow> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<String>? startTime,
    Expression<String>? endTime,
    Expression<bool>? isEnabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudyWindowsCompanion copyWith({
    Value<String>? id,
    Value<String>? label,
    Value<String>? startTime,
    Value<String>? endTime,
    Value<bool>? isEnabled,
    Value<int>? rowid,
  }) {
    return StudyWindowsCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isEnabled: isEnabled ?? this.isEnabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyWindowsCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SchedulesTable extends Schedules
    with TableInfo<$SchedulesTable, ScheduleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dailyTargetHoursMeta = const VerificationMeta(
    'dailyTargetHours',
  );
  @override
  late final GeneratedColumn<double> dailyTargetHours = GeneratedColumn<double>(
    'daily_target_hours',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  enabledWindowIds = GeneratedColumn<String>(
    'enabled_window_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<String>>($SchedulesTable.$converterenabledWindowIds);
  static const VerificationMeta _weekStartDateMeta = const VerificationMeta(
    'weekStartDate',
  );
  @override
  late final GeneratedColumn<DateTime> weekStartDate =
      GeneratedColumn<DateTime>(
        'week_start_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _aiReasoningMeta = const VerificationMeta(
    'aiReasoning',
  );
  @override
  late final GeneratedColumn<String> aiReasoning = GeneratedColumn<String>(
    'ai_reasoning',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAIGeneratedMeta = const VerificationMeta(
    'isAIGenerated',
  );
  @override
  late final GeneratedColumn<bool> isAIGenerated = GeneratedColumn<bool>(
    'is_a_i_generated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_a_i_generated" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    dailyTargetHours,
    enabledWindowIds,
    weekStartDate,
    aiReasoning,
    isAIGenerated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schedules';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScheduleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('daily_target_hours')) {
      context.handle(
        _dailyTargetHoursMeta,
        dailyTargetHours.isAcceptableOrUnknown(
          data['daily_target_hours']!,
          _dailyTargetHoursMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dailyTargetHoursMeta);
    }
    if (data.containsKey('week_start_date')) {
      context.handle(
        _weekStartDateMeta,
        weekStartDate.isAcceptableOrUnknown(
          data['week_start_date']!,
          _weekStartDateMeta,
        ),
      );
    }
    if (data.containsKey('ai_reasoning')) {
      context.handle(
        _aiReasoningMeta,
        aiReasoning.isAcceptableOrUnknown(
          data['ai_reasoning']!,
          _aiReasoningMeta,
        ),
      );
    }
    if (data.containsKey('is_a_i_generated')) {
      context.handle(
        _isAIGeneratedMeta,
        isAIGenerated.isAcceptableOrUnknown(
          data['is_a_i_generated']!,
          _isAIGeneratedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      dailyTargetHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}daily_target_hours'],
      )!,
      enabledWindowIds: $SchedulesTable.$converterenabledWindowIds.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}enabled_window_ids'],
        )!,
      ),
      weekStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}week_start_date'],
      ),
      aiReasoning: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_reasoning'],
      ),
      isAIGenerated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_a_i_generated'],
      )!,
    );
  }

  @override
  $SchedulesTable createAlias(String alias) {
    return $SchedulesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterenabledWindowIds =
      const StringListConverter();
}

class ScheduleRow extends DataClass implements Insertable<ScheduleRow> {
  final String id;
  final String userId;
  final double dailyTargetHours;
  final List<String> enabledWindowIds;
  final DateTime? weekStartDate;
  final String? aiReasoning;
  final bool isAIGenerated;
  const ScheduleRow({
    required this.id,
    required this.userId,
    required this.dailyTargetHours,
    required this.enabledWindowIds,
    this.weekStartDate,
    this.aiReasoning,
    required this.isAIGenerated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['daily_target_hours'] = Variable<double>(dailyTargetHours);
    {
      map['enabled_window_ids'] = Variable<String>(
        $SchedulesTable.$converterenabledWindowIds.toSql(enabledWindowIds),
      );
    }
    if (!nullToAbsent || weekStartDate != null) {
      map['week_start_date'] = Variable<DateTime>(weekStartDate);
    }
    if (!nullToAbsent || aiReasoning != null) {
      map['ai_reasoning'] = Variable<String>(aiReasoning);
    }
    map['is_a_i_generated'] = Variable<bool>(isAIGenerated);
    return map;
  }

  SchedulesCompanion toCompanion(bool nullToAbsent) {
    return SchedulesCompanion(
      id: Value(id),
      userId: Value(userId),
      dailyTargetHours: Value(dailyTargetHours),
      enabledWindowIds: Value(enabledWindowIds),
      weekStartDate: weekStartDate == null && nullToAbsent
          ? const Value.absent()
          : Value(weekStartDate),
      aiReasoning: aiReasoning == null && nullToAbsent
          ? const Value.absent()
          : Value(aiReasoning),
      isAIGenerated: Value(isAIGenerated),
    );
  }

  factory ScheduleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduleRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      dailyTargetHours: serializer.fromJson<double>(json['dailyTargetHours']),
      enabledWindowIds: serializer.fromJson<List<String>>(
        json['enabledWindowIds'],
      ),
      weekStartDate: serializer.fromJson<DateTime?>(json['weekStartDate']),
      aiReasoning: serializer.fromJson<String?>(json['aiReasoning']),
      isAIGenerated: serializer.fromJson<bool>(json['isAIGenerated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'dailyTargetHours': serializer.toJson<double>(dailyTargetHours),
      'enabledWindowIds': serializer.toJson<List<String>>(enabledWindowIds),
      'weekStartDate': serializer.toJson<DateTime?>(weekStartDate),
      'aiReasoning': serializer.toJson<String?>(aiReasoning),
      'isAIGenerated': serializer.toJson<bool>(isAIGenerated),
    };
  }

  ScheduleRow copyWith({
    String? id,
    String? userId,
    double? dailyTargetHours,
    List<String>? enabledWindowIds,
    Value<DateTime?> weekStartDate = const Value.absent(),
    Value<String?> aiReasoning = const Value.absent(),
    bool? isAIGenerated,
  }) => ScheduleRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    dailyTargetHours: dailyTargetHours ?? this.dailyTargetHours,
    enabledWindowIds: enabledWindowIds ?? this.enabledWindowIds,
    weekStartDate: weekStartDate.present
        ? weekStartDate.value
        : this.weekStartDate,
    aiReasoning: aiReasoning.present ? aiReasoning.value : this.aiReasoning,
    isAIGenerated: isAIGenerated ?? this.isAIGenerated,
  );
  ScheduleRow copyWithCompanion(SchedulesCompanion data) {
    return ScheduleRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      dailyTargetHours: data.dailyTargetHours.present
          ? data.dailyTargetHours.value
          : this.dailyTargetHours,
      enabledWindowIds: data.enabledWindowIds.present
          ? data.enabledWindowIds.value
          : this.enabledWindowIds,
      weekStartDate: data.weekStartDate.present
          ? data.weekStartDate.value
          : this.weekStartDate,
      aiReasoning: data.aiReasoning.present
          ? data.aiReasoning.value
          : this.aiReasoning,
      isAIGenerated: data.isAIGenerated.present
          ? data.isAIGenerated.value
          : this.isAIGenerated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('dailyTargetHours: $dailyTargetHours, ')
          ..write('enabledWindowIds: $enabledWindowIds, ')
          ..write('weekStartDate: $weekStartDate, ')
          ..write('aiReasoning: $aiReasoning, ')
          ..write('isAIGenerated: $isAIGenerated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    dailyTargetHours,
    enabledWindowIds,
    weekStartDate,
    aiReasoning,
    isAIGenerated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduleRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.dailyTargetHours == this.dailyTargetHours &&
          other.enabledWindowIds == this.enabledWindowIds &&
          other.weekStartDate == this.weekStartDate &&
          other.aiReasoning == this.aiReasoning &&
          other.isAIGenerated == this.isAIGenerated);
}

class SchedulesCompanion extends UpdateCompanion<ScheduleRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<double> dailyTargetHours;
  final Value<List<String>> enabledWindowIds;
  final Value<DateTime?> weekStartDate;
  final Value<String?> aiReasoning;
  final Value<bool> isAIGenerated;
  final Value<int> rowid;
  const SchedulesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.dailyTargetHours = const Value.absent(),
    this.enabledWindowIds = const Value.absent(),
    this.weekStartDate = const Value.absent(),
    this.aiReasoning = const Value.absent(),
    this.isAIGenerated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SchedulesCompanion.insert({
    required String id,
    required String userId,
    required double dailyTargetHours,
    required List<String> enabledWindowIds,
    this.weekStartDate = const Value.absent(),
    this.aiReasoning = const Value.absent(),
    this.isAIGenerated = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       dailyTargetHours = Value(dailyTargetHours),
       enabledWindowIds = Value(enabledWindowIds);
  static Insertable<ScheduleRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<double>? dailyTargetHours,
    Expression<String>? enabledWindowIds,
    Expression<DateTime>? weekStartDate,
    Expression<String>? aiReasoning,
    Expression<bool>? isAIGenerated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (dailyTargetHours != null) 'daily_target_hours': dailyTargetHours,
      if (enabledWindowIds != null) 'enabled_window_ids': enabledWindowIds,
      if (weekStartDate != null) 'week_start_date': weekStartDate,
      if (aiReasoning != null) 'ai_reasoning': aiReasoning,
      if (isAIGenerated != null) 'is_a_i_generated': isAIGenerated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SchedulesCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<double>? dailyTargetHours,
    Value<List<String>>? enabledWindowIds,
    Value<DateTime?>? weekStartDate,
    Value<String?>? aiReasoning,
    Value<bool>? isAIGenerated,
    Value<int>? rowid,
  }) {
    return SchedulesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dailyTargetHours: dailyTargetHours ?? this.dailyTargetHours,
      enabledWindowIds: enabledWindowIds ?? this.enabledWindowIds,
      weekStartDate: weekStartDate ?? this.weekStartDate,
      aiReasoning: aiReasoning ?? this.aiReasoning,
      isAIGenerated: isAIGenerated ?? this.isAIGenerated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (dailyTargetHours.present) {
      map['daily_target_hours'] = Variable<double>(dailyTargetHours.value);
    }
    if (enabledWindowIds.present) {
      map['enabled_window_ids'] = Variable<String>(
        $SchedulesTable.$converterenabledWindowIds.toSql(
          enabledWindowIds.value,
        ),
      );
    }
    if (weekStartDate.present) {
      map['week_start_date'] = Variable<DateTime>(weekStartDate.value);
    }
    if (aiReasoning.present) {
      map['ai_reasoning'] = Variable<String>(aiReasoning.value);
    }
    if (isAIGenerated.present) {
      map['is_a_i_generated'] = Variable<bool>(isAIGenerated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchedulesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('dailyTargetHours: $dailyTargetHours, ')
          ..write('enabledWindowIds: $enabledWindowIds, ')
          ..write('weekStartDate: $weekStartDate, ')
          ..write('aiReasoning: $aiReasoning, ')
          ..write('isAIGenerated: $isAIGenerated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudyBlocksTable extends StudyBlocks
    with TableInfo<$StudyBlocksTable, StudyBlockRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyBlocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduleIdMeta = const VerificationMeta(
    'scheduleId',
  );
  @override
  late final GeneratedColumn<String> scheduleId = GeneratedColumn<String>(
    'schedule_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES schedules (id)',
    ),
  );
  static const VerificationMeta _dayOfWeekMeta = const VerificationMeta(
    'dayOfWeek',
  );
  @override
  late final GeneratedColumn<int> dayOfWeek = GeneratedColumn<int>(
    'day_of_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subjects (id)',
    ),
  );
  static const VerificationMeta _topicIdMeta = const VerificationMeta(
    'topicId',
  );
  @override
  late final GeneratedColumn<String> topicId = GeneratedColumn<String>(
    'topic_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES topics (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activitiesMeta = const VerificationMeta(
    'activities',
  );
  @override
  late final GeneratedColumn<String> activities = GeneratedColumn<String>(
    'activities',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<BlockStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<BlockStatus>($StudyBlocksTable.$converterstatus);
  static const VerificationMeta _aiInsightMeta = const VerificationMeta(
    'aiInsight',
  );
  @override
  late final GeneratedColumn<String> aiInsight = GeneratedColumn<String>(
    'ai_insight',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAIGeneratedMeta = const VerificationMeta(
    'isAIGenerated',
  );
  @override
  late final GeneratedColumn<bool> isAIGenerated = GeneratedColumn<bool>(
    'is_a_i_generated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_a_i_generated" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    scheduleId,
    dayOfWeek,
    date,
    startTime,
    durationMinutes,
    subjectId,
    topicId,
    title,
    activities,
    status,
    aiInsight,
    isAIGenerated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_blocks';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudyBlockRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('schedule_id')) {
      context.handle(
        _scheduleIdMeta,
        scheduleId.isAcceptableOrUnknown(data['schedule_id']!, _scheduleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_scheduleIdMeta);
    }
    if (data.containsKey('day_of_week')) {
      context.handle(
        _dayOfWeekMeta,
        dayOfWeek.isAcceptableOrUnknown(data['day_of_week']!, _dayOfWeekMeta),
      );
    } else if (isInserting) {
      context.missing(_dayOfWeekMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('topic_id')) {
      context.handle(
        _topicIdMeta,
        topicId.isAcceptableOrUnknown(data['topic_id']!, _topicIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('activities')) {
      context.handle(
        _activitiesMeta,
        activities.isAcceptableOrUnknown(data['activities']!, _activitiesMeta),
      );
    } else if (isInserting) {
      context.missing(_activitiesMeta);
    }
    if (data.containsKey('ai_insight')) {
      context.handle(
        _aiInsightMeta,
        aiInsight.isAcceptableOrUnknown(data['ai_insight']!, _aiInsightMeta),
      );
    }
    if (data.containsKey('is_a_i_generated')) {
      context.handle(
        _isAIGeneratedMeta,
        isAIGenerated.isAcceptableOrUnknown(
          data['is_a_i_generated']!,
          _isAIGeneratedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudyBlockRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyBlockRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      scheduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schedule_id'],
      )!,
      dayOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_of_week'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_time'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_id'],
      )!,
      topicId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      activities: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activities'],
      )!,
      status: $StudyBlocksTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      aiInsight: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_insight'],
      ),
      isAIGenerated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_a_i_generated'],
      )!,
    );
  }

  @override
  $StudyBlocksTable createAlias(String alias) {
    return $StudyBlocksTable(attachedDatabase, alias);
  }

  static TypeConverter<BlockStatus, String> $converterstatus =
      const EnumConverter<BlockStatus>(BlockStatus.values);
}

class StudyBlockRow extends DataClass implements Insertable<StudyBlockRow> {
  final String id;
  final String scheduleId;
  final int dayOfWeek;
  final DateTime date;
  final String startTime;
  final int durationMinutes;
  final String subjectId;
  final String? topicId;
  final String title;
  final String activities;
  final BlockStatus status;
  final String? aiInsight;
  final bool isAIGenerated;
  const StudyBlockRow({
    required this.id,
    required this.scheduleId,
    required this.dayOfWeek,
    required this.date,
    required this.startTime,
    required this.durationMinutes,
    required this.subjectId,
    this.topicId,
    required this.title,
    required this.activities,
    required this.status,
    this.aiInsight,
    required this.isAIGenerated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['schedule_id'] = Variable<String>(scheduleId);
    map['day_of_week'] = Variable<int>(dayOfWeek);
    map['date'] = Variable<DateTime>(date);
    map['start_time'] = Variable<String>(startTime);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['subject_id'] = Variable<String>(subjectId);
    if (!nullToAbsent || topicId != null) {
      map['topic_id'] = Variable<String>(topicId);
    }
    map['title'] = Variable<String>(title);
    map['activities'] = Variable<String>(activities);
    {
      map['status'] = Variable<String>(
        $StudyBlocksTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || aiInsight != null) {
      map['ai_insight'] = Variable<String>(aiInsight);
    }
    map['is_a_i_generated'] = Variable<bool>(isAIGenerated);
    return map;
  }

  StudyBlocksCompanion toCompanion(bool nullToAbsent) {
    return StudyBlocksCompanion(
      id: Value(id),
      scheduleId: Value(scheduleId),
      dayOfWeek: Value(dayOfWeek),
      date: Value(date),
      startTime: Value(startTime),
      durationMinutes: Value(durationMinutes),
      subjectId: Value(subjectId),
      topicId: topicId == null && nullToAbsent
          ? const Value.absent()
          : Value(topicId),
      title: Value(title),
      activities: Value(activities),
      status: Value(status),
      aiInsight: aiInsight == null && nullToAbsent
          ? const Value.absent()
          : Value(aiInsight),
      isAIGenerated: Value(isAIGenerated),
    );
  }

  factory StudyBlockRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyBlockRow(
      id: serializer.fromJson<String>(json['id']),
      scheduleId: serializer.fromJson<String>(json['scheduleId']),
      dayOfWeek: serializer.fromJson<int>(json['dayOfWeek']),
      date: serializer.fromJson<DateTime>(json['date']),
      startTime: serializer.fromJson<String>(json['startTime']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      topicId: serializer.fromJson<String?>(json['topicId']),
      title: serializer.fromJson<String>(json['title']),
      activities: serializer.fromJson<String>(json['activities']),
      status: serializer.fromJson<BlockStatus>(json['status']),
      aiInsight: serializer.fromJson<String?>(json['aiInsight']),
      isAIGenerated: serializer.fromJson<bool>(json['isAIGenerated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'scheduleId': serializer.toJson<String>(scheduleId),
      'dayOfWeek': serializer.toJson<int>(dayOfWeek),
      'date': serializer.toJson<DateTime>(date),
      'startTime': serializer.toJson<String>(startTime),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'subjectId': serializer.toJson<String>(subjectId),
      'topicId': serializer.toJson<String?>(topicId),
      'title': serializer.toJson<String>(title),
      'activities': serializer.toJson<String>(activities),
      'status': serializer.toJson<BlockStatus>(status),
      'aiInsight': serializer.toJson<String?>(aiInsight),
      'isAIGenerated': serializer.toJson<bool>(isAIGenerated),
    };
  }

  StudyBlockRow copyWith({
    String? id,
    String? scheduleId,
    int? dayOfWeek,
    DateTime? date,
    String? startTime,
    int? durationMinutes,
    String? subjectId,
    Value<String?> topicId = const Value.absent(),
    String? title,
    String? activities,
    BlockStatus? status,
    Value<String?> aiInsight = const Value.absent(),
    bool? isAIGenerated,
  }) => StudyBlockRow(
    id: id ?? this.id,
    scheduleId: scheduleId ?? this.scheduleId,
    dayOfWeek: dayOfWeek ?? this.dayOfWeek,
    date: date ?? this.date,
    startTime: startTime ?? this.startTime,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    subjectId: subjectId ?? this.subjectId,
    topicId: topicId.present ? topicId.value : this.topicId,
    title: title ?? this.title,
    activities: activities ?? this.activities,
    status: status ?? this.status,
    aiInsight: aiInsight.present ? aiInsight.value : this.aiInsight,
    isAIGenerated: isAIGenerated ?? this.isAIGenerated,
  );
  StudyBlockRow copyWithCompanion(StudyBlocksCompanion data) {
    return StudyBlockRow(
      id: data.id.present ? data.id.value : this.id,
      scheduleId: data.scheduleId.present
          ? data.scheduleId.value
          : this.scheduleId,
      dayOfWeek: data.dayOfWeek.present ? data.dayOfWeek.value : this.dayOfWeek,
      date: data.date.present ? data.date.value : this.date,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
      title: data.title.present ? data.title.value : this.title,
      activities: data.activities.present
          ? data.activities.value
          : this.activities,
      status: data.status.present ? data.status.value : this.status,
      aiInsight: data.aiInsight.present ? data.aiInsight.value : this.aiInsight,
      isAIGenerated: data.isAIGenerated.present
          ? data.isAIGenerated.value
          : this.isAIGenerated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyBlockRow(')
          ..write('id: $id, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('date: $date, ')
          ..write('startTime: $startTime, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('subjectId: $subjectId, ')
          ..write('topicId: $topicId, ')
          ..write('title: $title, ')
          ..write('activities: $activities, ')
          ..write('status: $status, ')
          ..write('aiInsight: $aiInsight, ')
          ..write('isAIGenerated: $isAIGenerated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    scheduleId,
    dayOfWeek,
    date,
    startTime,
    durationMinutes,
    subjectId,
    topicId,
    title,
    activities,
    status,
    aiInsight,
    isAIGenerated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyBlockRow &&
          other.id == this.id &&
          other.scheduleId == this.scheduleId &&
          other.dayOfWeek == this.dayOfWeek &&
          other.date == this.date &&
          other.startTime == this.startTime &&
          other.durationMinutes == this.durationMinutes &&
          other.subjectId == this.subjectId &&
          other.topicId == this.topicId &&
          other.title == this.title &&
          other.activities == this.activities &&
          other.status == this.status &&
          other.aiInsight == this.aiInsight &&
          other.isAIGenerated == this.isAIGenerated);
}

class StudyBlocksCompanion extends UpdateCompanion<StudyBlockRow> {
  final Value<String> id;
  final Value<String> scheduleId;
  final Value<int> dayOfWeek;
  final Value<DateTime> date;
  final Value<String> startTime;
  final Value<int> durationMinutes;
  final Value<String> subjectId;
  final Value<String?> topicId;
  final Value<String> title;
  final Value<String> activities;
  final Value<BlockStatus> status;
  final Value<String?> aiInsight;
  final Value<bool> isAIGenerated;
  final Value<int> rowid;
  const StudyBlocksCompanion({
    this.id = const Value.absent(),
    this.scheduleId = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    this.date = const Value.absent(),
    this.startTime = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.topicId = const Value.absent(),
    this.title = const Value.absent(),
    this.activities = const Value.absent(),
    this.status = const Value.absent(),
    this.aiInsight = const Value.absent(),
    this.isAIGenerated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyBlocksCompanion.insert({
    required String id,
    required String scheduleId,
    required int dayOfWeek,
    required DateTime date,
    required String startTime,
    required int durationMinutes,
    required String subjectId,
    this.topicId = const Value.absent(),
    required String title,
    required String activities,
    required BlockStatus status,
    this.aiInsight = const Value.absent(),
    this.isAIGenerated = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       scheduleId = Value(scheduleId),
       dayOfWeek = Value(dayOfWeek),
       date = Value(date),
       startTime = Value(startTime),
       durationMinutes = Value(durationMinutes),
       subjectId = Value(subjectId),
       title = Value(title),
       activities = Value(activities),
       status = Value(status);
  static Insertable<StudyBlockRow> custom({
    Expression<String>? id,
    Expression<String>? scheduleId,
    Expression<int>? dayOfWeek,
    Expression<DateTime>? date,
    Expression<String>? startTime,
    Expression<int>? durationMinutes,
    Expression<String>? subjectId,
    Expression<String>? topicId,
    Expression<String>? title,
    Expression<String>? activities,
    Expression<String>? status,
    Expression<String>? aiInsight,
    Expression<bool>? isAIGenerated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scheduleId != null) 'schedule_id': scheduleId,
      if (dayOfWeek != null) 'day_of_week': dayOfWeek,
      if (date != null) 'date': date,
      if (startTime != null) 'start_time': startTime,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (subjectId != null) 'subject_id': subjectId,
      if (topicId != null) 'topic_id': topicId,
      if (title != null) 'title': title,
      if (activities != null) 'activities': activities,
      if (status != null) 'status': status,
      if (aiInsight != null) 'ai_insight': aiInsight,
      if (isAIGenerated != null) 'is_a_i_generated': isAIGenerated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudyBlocksCompanion copyWith({
    Value<String>? id,
    Value<String>? scheduleId,
    Value<int>? dayOfWeek,
    Value<DateTime>? date,
    Value<String>? startTime,
    Value<int>? durationMinutes,
    Value<String>? subjectId,
    Value<String?>? topicId,
    Value<String>? title,
    Value<String>? activities,
    Value<BlockStatus>? status,
    Value<String?>? aiInsight,
    Value<bool>? isAIGenerated,
    Value<int>? rowid,
  }) {
    return StudyBlocksCompanion(
      id: id ?? this.id,
      scheduleId: scheduleId ?? this.scheduleId,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      subjectId: subjectId ?? this.subjectId,
      topicId: topicId ?? this.topicId,
      title: title ?? this.title,
      activities: activities ?? this.activities,
      status: status ?? this.status,
      aiInsight: aiInsight ?? this.aiInsight,
      isAIGenerated: isAIGenerated ?? this.isAIGenerated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (scheduleId.present) {
      map['schedule_id'] = Variable<String>(scheduleId.value);
    }
    if (dayOfWeek.present) {
      map['day_of_week'] = Variable<int>(dayOfWeek.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (topicId.present) {
      map['topic_id'] = Variable<String>(topicId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (activities.present) {
      map['activities'] = Variable<String>(activities.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $StudyBlocksTable.$converterstatus.toSql(status.value),
      );
    }
    if (aiInsight.present) {
      map['ai_insight'] = Variable<String>(aiInsight.value);
    }
    if (isAIGenerated.present) {
      map['is_a_i_generated'] = Variable<bool>(isAIGenerated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyBlocksCompanion(')
          ..write('id: $id, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('date: $date, ')
          ..write('startTime: $startTime, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('subjectId: $subjectId, ')
          ..write('topicId: $topicId, ')
          ..write('title: $title, ')
          ..write('activities: $activities, ')
          ..write('status: $status, ')
          ..write('aiInsight: $aiInsight, ')
          ..write('isAIGenerated: $isAIGenerated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LibraryItemsTable extends LibraryItems
    with TableInfo<$LibraryItemsTable, LibraryItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LibraryItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ItemKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ItemKind>($LibraryItemsTable.$converterkind);
  static const VerificationMeta _fileSizeMeta = const VerificationMeta(
    'fileSize',
  );
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
    'file_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uploadedAtMeta = const VerificationMeta(
    'uploadedAt',
  );
  @override
  late final GeneratedColumn<DateTime> uploadedAt = GeneratedColumn<DateTime>(
    'uploaded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ProcessingStatus, String>
  processingStatus =
      GeneratedColumn<String>(
        'processing_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ProcessingStatus>(
        $LibraryItemsTable.$converterprocessingStatus,
      );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
    'subject_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subjects (id)',
    ),
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _indexedPageCountMeta = const VerificationMeta(
    'indexedPageCount',
  );
  @override
  late final GeneratedColumn<int> indexedPageCount = GeneratedColumn<int>(
    'indexed_page_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    name,
    kind,
    fileSize,
    uploadedAt,
    processingStatus,
    subjectId,
    metadata,
    colorHex,
    indexedPageCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'library_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<LibraryItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('file_size')) {
      context.handle(
        _fileSizeMeta,
        fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_fileSizeMeta);
    }
    if (data.containsKey('uploaded_at')) {
      context.handle(
        _uploadedAtMeta,
        uploadedAt.isAcceptableOrUnknown(data['uploaded_at']!, _uploadedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_uploadedAtMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    }
    if (data.containsKey('indexed_page_count')) {
      context.handle(
        _indexedPageCountMeta,
        indexedPageCount.isAcceptableOrUnknown(
          data['indexed_page_count']!,
          _indexedPageCountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LibraryItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LibraryItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: $LibraryItemsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      fileSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size'],
      )!,
      uploadedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}uploaded_at'],
      )!,
      processingStatus: $LibraryItemsTable.$converterprocessingStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}processing_status'],
        )!,
      ),
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_id'],
      ),
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      ),
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      ),
      indexedPageCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}indexed_page_count'],
      ),
    );
  }

  @override
  $LibraryItemsTable createAlias(String alias) {
    return $LibraryItemsTable(attachedDatabase, alias);
  }

  static TypeConverter<ItemKind, String> $converterkind =
      const EnumConverter<ItemKind>(ItemKind.values);
  static TypeConverter<ProcessingStatus, String> $converterprocessingStatus =
      const EnumConverter<ProcessingStatus>(ProcessingStatus.values);
}

class LibraryItemRow extends DataClass implements Insertable<LibraryItemRow> {
  final String id;
  final String userId;
  final String name;
  final ItemKind kind;
  final int fileSize;
  final DateTime uploadedAt;
  final ProcessingStatus processingStatus;
  final String? subjectId;
  final String? metadata;
  final String? colorHex;
  final int? indexedPageCount;
  const LibraryItemRow({
    required this.id,
    required this.userId,
    required this.name,
    required this.kind,
    required this.fileSize,
    required this.uploadedAt,
    required this.processingStatus,
    this.subjectId,
    this.metadata,
    this.colorHex,
    this.indexedPageCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    {
      map['kind'] = Variable<String>(
        $LibraryItemsTable.$converterkind.toSql(kind),
      );
    }
    map['file_size'] = Variable<int>(fileSize);
    map['uploaded_at'] = Variable<DateTime>(uploadedAt);
    {
      map['processing_status'] = Variable<String>(
        $LibraryItemsTable.$converterprocessingStatus.toSql(processingStatus),
      );
    }
    if (!nullToAbsent || subjectId != null) {
      map['subject_id'] = Variable<String>(subjectId);
    }
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    if (!nullToAbsent || colorHex != null) {
      map['color_hex'] = Variable<String>(colorHex);
    }
    if (!nullToAbsent || indexedPageCount != null) {
      map['indexed_page_count'] = Variable<int>(indexedPageCount);
    }
    return map;
  }

  LibraryItemsCompanion toCompanion(bool nullToAbsent) {
    return LibraryItemsCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      kind: Value(kind),
      fileSize: Value(fileSize),
      uploadedAt: Value(uploadedAt),
      processingStatus: Value(processingStatus),
      subjectId: subjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectId),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
      colorHex: colorHex == null && nullToAbsent
          ? const Value.absent()
          : Value(colorHex),
      indexedPageCount: indexedPageCount == null && nullToAbsent
          ? const Value.absent()
          : Value(indexedPageCount),
    );
  }

  factory LibraryItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LibraryItemRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      kind: serializer.fromJson<ItemKind>(json['kind']),
      fileSize: serializer.fromJson<int>(json['fileSize']),
      uploadedAt: serializer.fromJson<DateTime>(json['uploadedAt']),
      processingStatus: serializer.fromJson<ProcessingStatus>(
        json['processingStatus'],
      ),
      subjectId: serializer.fromJson<String?>(json['subjectId']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      colorHex: serializer.fromJson<String?>(json['colorHex']),
      indexedPageCount: serializer.fromJson<int?>(json['indexedPageCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<ItemKind>(kind),
      'fileSize': serializer.toJson<int>(fileSize),
      'uploadedAt': serializer.toJson<DateTime>(uploadedAt),
      'processingStatus': serializer.toJson<ProcessingStatus>(processingStatus),
      'subjectId': serializer.toJson<String?>(subjectId),
      'metadata': serializer.toJson<String?>(metadata),
      'colorHex': serializer.toJson<String?>(colorHex),
      'indexedPageCount': serializer.toJson<int?>(indexedPageCount),
    };
  }

  LibraryItemRow copyWith({
    String? id,
    String? userId,
    String? name,
    ItemKind? kind,
    int? fileSize,
    DateTime? uploadedAt,
    ProcessingStatus? processingStatus,
    Value<String?> subjectId = const Value.absent(),
    Value<String?> metadata = const Value.absent(),
    Value<String?> colorHex = const Value.absent(),
    Value<int?> indexedPageCount = const Value.absent(),
  }) => LibraryItemRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    fileSize: fileSize ?? this.fileSize,
    uploadedAt: uploadedAt ?? this.uploadedAt,
    processingStatus: processingStatus ?? this.processingStatus,
    subjectId: subjectId.present ? subjectId.value : this.subjectId,
    metadata: metadata.present ? metadata.value : this.metadata,
    colorHex: colorHex.present ? colorHex.value : this.colorHex,
    indexedPageCount: indexedPageCount.present
        ? indexedPageCount.value
        : this.indexedPageCount,
  );
  LibraryItemRow copyWithCompanion(LibraryItemsCompanion data) {
    return LibraryItemRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      uploadedAt: data.uploadedAt.present
          ? data.uploadedAt.value
          : this.uploadedAt,
      processingStatus: data.processingStatus.present
          ? data.processingStatus.value
          : this.processingStatus,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      indexedPageCount: data.indexedPageCount.present
          ? data.indexedPageCount.value
          : this.indexedPageCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LibraryItemRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('fileSize: $fileSize, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('processingStatus: $processingStatus, ')
          ..write('subjectId: $subjectId, ')
          ..write('metadata: $metadata, ')
          ..write('colorHex: $colorHex, ')
          ..write('indexedPageCount: $indexedPageCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    name,
    kind,
    fileSize,
    uploadedAt,
    processingStatus,
    subjectId,
    metadata,
    colorHex,
    indexedPageCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LibraryItemRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.fileSize == this.fileSize &&
          other.uploadedAt == this.uploadedAt &&
          other.processingStatus == this.processingStatus &&
          other.subjectId == this.subjectId &&
          other.metadata == this.metadata &&
          other.colorHex == this.colorHex &&
          other.indexedPageCount == this.indexedPageCount);
}

class LibraryItemsCompanion extends UpdateCompanion<LibraryItemRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> name;
  final Value<ItemKind> kind;
  final Value<int> fileSize;
  final Value<DateTime> uploadedAt;
  final Value<ProcessingStatus> processingStatus;
  final Value<String?> subjectId;
  final Value<String?> metadata;
  final Value<String?> colorHex;
  final Value<int?> indexedPageCount;
  final Value<int> rowid;
  const LibraryItemsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.uploadedAt = const Value.absent(),
    this.processingStatus = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.metadata = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.indexedPageCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LibraryItemsCompanion.insert({
    required String id,
    required String userId,
    required String name,
    required ItemKind kind,
    required int fileSize,
    required DateTime uploadedAt,
    required ProcessingStatus processingStatus,
    this.subjectId = const Value.absent(),
    this.metadata = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.indexedPageCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       name = Value(name),
       kind = Value(kind),
       fileSize = Value(fileSize),
       uploadedAt = Value(uploadedAt),
       processingStatus = Value(processingStatus);
  static Insertable<LibraryItemRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<int>? fileSize,
    Expression<DateTime>? uploadedAt,
    Expression<String>? processingStatus,
    Expression<String>? subjectId,
    Expression<String>? metadata,
    Expression<String>? colorHex,
    Expression<int>? indexedPageCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (fileSize != null) 'file_size': fileSize,
      if (uploadedAt != null) 'uploaded_at': uploadedAt,
      if (processingStatus != null) 'processing_status': processingStatus,
      if (subjectId != null) 'subject_id': subjectId,
      if (metadata != null) 'metadata': metadata,
      if (colorHex != null) 'color_hex': colorHex,
      if (indexedPageCount != null) 'indexed_page_count': indexedPageCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LibraryItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? name,
    Value<ItemKind>? kind,
    Value<int>? fileSize,
    Value<DateTime>? uploadedAt,
    Value<ProcessingStatus>? processingStatus,
    Value<String?>? subjectId,
    Value<String?>? metadata,
    Value<String?>? colorHex,
    Value<int?>? indexedPageCount,
    Value<int>? rowid,
  }) {
    return LibraryItemsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      fileSize: fileSize ?? this.fileSize,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      processingStatus: processingStatus ?? this.processingStatus,
      subjectId: subjectId ?? this.subjectId,
      metadata: metadata ?? this.metadata,
      colorHex: colorHex ?? this.colorHex,
      indexedPageCount: indexedPageCount ?? this.indexedPageCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $LibraryItemsTable.$converterkind.toSql(kind.value),
      );
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (uploadedAt.present) {
      map['uploaded_at'] = Variable<DateTime>(uploadedAt.value);
    }
    if (processingStatus.present) {
      map['processing_status'] = Variable<String>(
        $LibraryItemsTable.$converterprocessingStatus.toSql(
          processingStatus.value,
        ),
      );
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (indexedPageCount.present) {
      map['indexed_page_count'] = Variable<int>(indexedPageCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LibraryItemsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('fileSize: $fileSize, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('processingStatus: $processingStatus, ')
          ..write('subjectId: $subjectId, ')
          ..write('metadata: $metadata, ')
          ..write('colorHex: $colorHex, ')
          ..write('indexedPageCount: $indexedPageCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MaterialTextsTable extends MaterialTexts
    with TableInfo<$MaterialTextsTable, MaterialTextRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaterialTextsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES library_items (id)',
    ),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pageCountMeta = const VerificationMeta(
    'pageCount',
  );
  @override
  late final GeneratedColumn<int> pageCount = GeneratedColumn<int>(
    'page_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _charCountMeta = const VerificationMeta(
    'charCount',
  );
  @override
  late final GeneratedColumn<int> charCount = GeneratedColumn<int>(
    'char_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _extractedAtMeta = const VerificationMeta(
    'extractedAt',
  );
  @override
  late final GeneratedColumn<DateTime> extractedAt = GeneratedColumn<DateTime>(
    'extracted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    itemId,
    content,
    pageCount,
    charCount,
    extractedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'material_texts';
  @override
  VerificationContext validateIntegrity(
    Insertable<MaterialTextRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('page_count')) {
      context.handle(
        _pageCountMeta,
        pageCount.isAcceptableOrUnknown(data['page_count']!, _pageCountMeta),
      );
    }
    if (data.containsKey('char_count')) {
      context.handle(
        _charCountMeta,
        charCount.isAcceptableOrUnknown(data['char_count']!, _charCountMeta),
      );
    }
    if (data.containsKey('extracted_at')) {
      context.handle(
        _extractedAtMeta,
        extractedAt.isAcceptableOrUnknown(
          data['extracted_at']!,
          _extractedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_extractedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId};
  @override
  MaterialTextRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaterialTextRow(
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      pageCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_count'],
      )!,
      charCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}char_count'],
      )!,
      extractedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}extracted_at'],
      )!,
    );
  }

  @override
  $MaterialTextsTable createAlias(String alias) {
    return $MaterialTextsTable(attachedDatabase, alias);
  }
}

class MaterialTextRow extends DataClass implements Insertable<MaterialTextRow> {
  final String itemId;
  final String content;
  final int pageCount;
  final int charCount;
  final DateTime extractedAt;
  const MaterialTextRow({
    required this.itemId,
    required this.content,
    required this.pageCount,
    required this.charCount,
    required this.extractedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['content'] = Variable<String>(content);
    map['page_count'] = Variable<int>(pageCount);
    map['char_count'] = Variable<int>(charCount);
    map['extracted_at'] = Variable<DateTime>(extractedAt);
    return map;
  }

  MaterialTextsCompanion toCompanion(bool nullToAbsent) {
    return MaterialTextsCompanion(
      itemId: Value(itemId),
      content: Value(content),
      pageCount: Value(pageCount),
      charCount: Value(charCount),
      extractedAt: Value(extractedAt),
    );
  }

  factory MaterialTextRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaterialTextRow(
      itemId: serializer.fromJson<String>(json['itemId']),
      content: serializer.fromJson<String>(json['content']),
      pageCount: serializer.fromJson<int>(json['pageCount']),
      charCount: serializer.fromJson<int>(json['charCount']),
      extractedAt: serializer.fromJson<DateTime>(json['extractedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'content': serializer.toJson<String>(content),
      'pageCount': serializer.toJson<int>(pageCount),
      'charCount': serializer.toJson<int>(charCount),
      'extractedAt': serializer.toJson<DateTime>(extractedAt),
    };
  }

  MaterialTextRow copyWith({
    String? itemId,
    String? content,
    int? pageCount,
    int? charCount,
    DateTime? extractedAt,
  }) => MaterialTextRow(
    itemId: itemId ?? this.itemId,
    content: content ?? this.content,
    pageCount: pageCount ?? this.pageCount,
    charCount: charCount ?? this.charCount,
    extractedAt: extractedAt ?? this.extractedAt,
  );
  MaterialTextRow copyWithCompanion(MaterialTextsCompanion data) {
    return MaterialTextRow(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      content: data.content.present ? data.content.value : this.content,
      pageCount: data.pageCount.present ? data.pageCount.value : this.pageCount,
      charCount: data.charCount.present ? data.charCount.value : this.charCount,
      extractedAt: data.extractedAt.present
          ? data.extractedAt.value
          : this.extractedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaterialTextRow(')
          ..write('itemId: $itemId, ')
          ..write('content: $content, ')
          ..write('pageCount: $pageCount, ')
          ..write('charCount: $charCount, ')
          ..write('extractedAt: $extractedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(itemId, content, pageCount, charCount, extractedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaterialTextRow &&
          other.itemId == this.itemId &&
          other.content == this.content &&
          other.pageCount == this.pageCount &&
          other.charCount == this.charCount &&
          other.extractedAt == this.extractedAt);
}

class MaterialTextsCompanion extends UpdateCompanion<MaterialTextRow> {
  final Value<String> itemId;
  final Value<String> content;
  final Value<int> pageCount;
  final Value<int> charCount;
  final Value<DateTime> extractedAt;
  final Value<int> rowid;
  const MaterialTextsCompanion({
    this.itemId = const Value.absent(),
    this.content = const Value.absent(),
    this.pageCount = const Value.absent(),
    this.charCount = const Value.absent(),
    this.extractedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MaterialTextsCompanion.insert({
    required String itemId,
    required String content,
    this.pageCount = const Value.absent(),
    this.charCount = const Value.absent(),
    required DateTime extractedAt,
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId),
       content = Value(content),
       extractedAt = Value(extractedAt);
  static Insertable<MaterialTextRow> custom({
    Expression<String>? itemId,
    Expression<String>? content,
    Expression<int>? pageCount,
    Expression<int>? charCount,
    Expression<DateTime>? extractedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (content != null) 'content': content,
      if (pageCount != null) 'page_count': pageCount,
      if (charCount != null) 'char_count': charCount,
      if (extractedAt != null) 'extracted_at': extractedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MaterialTextsCompanion copyWith({
    Value<String>? itemId,
    Value<String>? content,
    Value<int>? pageCount,
    Value<int>? charCount,
    Value<DateTime>? extractedAt,
    Value<int>? rowid,
  }) {
    return MaterialTextsCompanion(
      itemId: itemId ?? this.itemId,
      content: content ?? this.content,
      pageCount: pageCount ?? this.pageCount,
      charCount: charCount ?? this.charCount,
      extractedAt: extractedAt ?? this.extractedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (pageCount.present) {
      map['page_count'] = Variable<int>(pageCount.value);
    }
    if (charCount.present) {
      map['char_count'] = Variable<int>(charCount.value);
    }
    if (extractedAt.present) {
      map['extracted_at'] = Variable<DateTime>(extractedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaterialTextsCompanion(')
          ..write('itemId: $itemId, ')
          ..write('content: $content, ')
          ..write('pageCount: $pageCount, ')
          ..write('charCount: $charCount, ')
          ..write('extractedAt: $extractedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuizzesTable extends Quizzes with TableInfo<$QuizzesTable, QuizRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizzesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subjects (id)',
    ),
  );
  static const VerificationMeta _topicIdMeta = const VerificationMeta(
    'topicId',
  );
  @override
  late final GeneratedColumn<String> topicId = GeneratedColumn<String>(
    'topic_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES topics (id)',
    ),
  );
  static const VerificationMeta _currentQuestionIndexMeta =
      const VerificationMeta('currentQuestionIndex');
  @override
  late final GeneratedColumn<int> currentQuestionIndex = GeneratedColumn<int>(
    'current_question_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceLabelMeta = const VerificationMeta(
    'sourceLabel',
  );
  @override
  late final GeneratedColumn<String> sourceLabel = GeneratedColumn<String>(
    'source_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAIGeneratedMeta = const VerificationMeta(
    'isAIGenerated',
  );
  @override
  late final GeneratedColumn<bool> isAIGenerated = GeneratedColumn<bool>(
    'is_a_i_generated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_a_i_generated" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    subjectId,
    topicId,
    currentQuestionIndex,
    sourceLabel,
    isAIGenerated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quizzes';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('topic_id')) {
      context.handle(
        _topicIdMeta,
        topicId.isAcceptableOrUnknown(data['topic_id']!, _topicIdMeta),
      );
    }
    if (data.containsKey('current_question_index')) {
      context.handle(
        _currentQuestionIndexMeta,
        currentQuestionIndex.isAcceptableOrUnknown(
          data['current_question_index']!,
          _currentQuestionIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentQuestionIndexMeta);
    }
    if (data.containsKey('source_label')) {
      context.handle(
        _sourceLabelMeta,
        sourceLabel.isAcceptableOrUnknown(
          data['source_label']!,
          _sourceLabelMeta,
        ),
      );
    }
    if (data.containsKey('is_a_i_generated')) {
      context.handle(
        _isAIGeneratedMeta,
        isAIGenerated.isAcceptableOrUnknown(
          data['is_a_i_generated']!,
          _isAIGeneratedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuizRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_id'],
      )!,
      topicId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic_id'],
      ),
      currentQuestionIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_question_index'],
      )!,
      sourceLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_label'],
      ),
      isAIGenerated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_a_i_generated'],
      )!,
    );
  }

  @override
  $QuizzesTable createAlias(String alias) {
    return $QuizzesTable(attachedDatabase, alias);
  }
}

class QuizRow extends DataClass implements Insertable<QuizRow> {
  final String id;
  final String subjectId;
  final String? topicId;
  final int currentQuestionIndex;
  final String? sourceLabel;
  final bool isAIGenerated;
  const QuizRow({
    required this.id,
    required this.subjectId,
    this.topicId,
    required this.currentQuestionIndex,
    this.sourceLabel,
    required this.isAIGenerated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['subject_id'] = Variable<String>(subjectId);
    if (!nullToAbsent || topicId != null) {
      map['topic_id'] = Variable<String>(topicId);
    }
    map['current_question_index'] = Variable<int>(currentQuestionIndex);
    if (!nullToAbsent || sourceLabel != null) {
      map['source_label'] = Variable<String>(sourceLabel);
    }
    map['is_a_i_generated'] = Variable<bool>(isAIGenerated);
    return map;
  }

  QuizzesCompanion toCompanion(bool nullToAbsent) {
    return QuizzesCompanion(
      id: Value(id),
      subjectId: Value(subjectId),
      topicId: topicId == null && nullToAbsent
          ? const Value.absent()
          : Value(topicId),
      currentQuestionIndex: Value(currentQuestionIndex),
      sourceLabel: sourceLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceLabel),
      isAIGenerated: Value(isAIGenerated),
    );
  }

  factory QuizRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizRow(
      id: serializer.fromJson<String>(json['id']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      topicId: serializer.fromJson<String?>(json['topicId']),
      currentQuestionIndex: serializer.fromJson<int>(
        json['currentQuestionIndex'],
      ),
      sourceLabel: serializer.fromJson<String?>(json['sourceLabel']),
      isAIGenerated: serializer.fromJson<bool>(json['isAIGenerated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subjectId': serializer.toJson<String>(subjectId),
      'topicId': serializer.toJson<String?>(topicId),
      'currentQuestionIndex': serializer.toJson<int>(currentQuestionIndex),
      'sourceLabel': serializer.toJson<String?>(sourceLabel),
      'isAIGenerated': serializer.toJson<bool>(isAIGenerated),
    };
  }

  QuizRow copyWith({
    String? id,
    String? subjectId,
    Value<String?> topicId = const Value.absent(),
    int? currentQuestionIndex,
    Value<String?> sourceLabel = const Value.absent(),
    bool? isAIGenerated,
  }) => QuizRow(
    id: id ?? this.id,
    subjectId: subjectId ?? this.subjectId,
    topicId: topicId.present ? topicId.value : this.topicId,
    currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
    sourceLabel: sourceLabel.present ? sourceLabel.value : this.sourceLabel,
    isAIGenerated: isAIGenerated ?? this.isAIGenerated,
  );
  QuizRow copyWithCompanion(QuizzesCompanion data) {
    return QuizRow(
      id: data.id.present ? data.id.value : this.id,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
      currentQuestionIndex: data.currentQuestionIndex.present
          ? data.currentQuestionIndex.value
          : this.currentQuestionIndex,
      sourceLabel: data.sourceLabel.present
          ? data.sourceLabel.value
          : this.sourceLabel,
      isAIGenerated: data.isAIGenerated.present
          ? data.isAIGenerated.value
          : this.isAIGenerated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizRow(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('topicId: $topicId, ')
          ..write('currentQuestionIndex: $currentQuestionIndex, ')
          ..write('sourceLabel: $sourceLabel, ')
          ..write('isAIGenerated: $isAIGenerated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    subjectId,
    topicId,
    currentQuestionIndex,
    sourceLabel,
    isAIGenerated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizRow &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.topicId == this.topicId &&
          other.currentQuestionIndex == this.currentQuestionIndex &&
          other.sourceLabel == this.sourceLabel &&
          other.isAIGenerated == this.isAIGenerated);
}

class QuizzesCompanion extends UpdateCompanion<QuizRow> {
  final Value<String> id;
  final Value<String> subjectId;
  final Value<String?> topicId;
  final Value<int> currentQuestionIndex;
  final Value<String?> sourceLabel;
  final Value<bool> isAIGenerated;
  final Value<int> rowid;
  const QuizzesCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.topicId = const Value.absent(),
    this.currentQuestionIndex = const Value.absent(),
    this.sourceLabel = const Value.absent(),
    this.isAIGenerated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuizzesCompanion.insert({
    required String id,
    required String subjectId,
    this.topicId = const Value.absent(),
    required int currentQuestionIndex,
    this.sourceLabel = const Value.absent(),
    this.isAIGenerated = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       subjectId = Value(subjectId),
       currentQuestionIndex = Value(currentQuestionIndex);
  static Insertable<QuizRow> custom({
    Expression<String>? id,
    Expression<String>? subjectId,
    Expression<String>? topicId,
    Expression<int>? currentQuestionIndex,
    Expression<String>? sourceLabel,
    Expression<bool>? isAIGenerated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (topicId != null) 'topic_id': topicId,
      if (currentQuestionIndex != null)
        'current_question_index': currentQuestionIndex,
      if (sourceLabel != null) 'source_label': sourceLabel,
      if (isAIGenerated != null) 'is_a_i_generated': isAIGenerated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuizzesCompanion copyWith({
    Value<String>? id,
    Value<String>? subjectId,
    Value<String?>? topicId,
    Value<int>? currentQuestionIndex,
    Value<String?>? sourceLabel,
    Value<bool>? isAIGenerated,
    Value<int>? rowid,
  }) {
    return QuizzesCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      topicId: topicId ?? this.topicId,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      sourceLabel: sourceLabel ?? this.sourceLabel,
      isAIGenerated: isAIGenerated ?? this.isAIGenerated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (topicId.present) {
      map['topic_id'] = Variable<String>(topicId.value);
    }
    if (currentQuestionIndex.present) {
      map['current_question_index'] = Variable<int>(currentQuestionIndex.value);
    }
    if (sourceLabel.present) {
      map['source_label'] = Variable<String>(sourceLabel.value);
    }
    if (isAIGenerated.present) {
      map['is_a_i_generated'] = Variable<bool>(isAIGenerated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizzesCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('topicId: $topicId, ')
          ..write('currentQuestionIndex: $currentQuestionIndex, ')
          ..write('sourceLabel: $sourceLabel, ')
          ..write('isAIGenerated: $isAIGenerated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuizQuestionsTable extends QuizQuestions
    with TableInfo<$QuizQuestionsTable, QuizQuestionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizQuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quizIdMeta = const VerificationMeta('quizId');
  @override
  late final GeneratedColumn<String> quizId = GeneratedColumn<String>(
    'quiz_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quizzes (id)',
    ),
  );
  static const VerificationMeta _indexMeta = const VerificationMeta('index');
  @override
  late final GeneratedColumn<int> index = GeneratedColumn<int>(
    'index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<QuestionType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<QuestionType>($QuizQuestionsTable.$convertertype);
  static const VerificationMeta _markValueMeta = const VerificationMeta(
    'markValue',
  );
  @override
  late final GeneratedColumn<int> markValue = GeneratedColumn<int>(
    'mark_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> options =
      GeneratedColumn<String>(
        'options',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($QuizQuestionsTable.$converteroptions);
  static const VerificationMeta _correctAnswerIndexMeta =
      const VerificationMeta('correctAnswerIndex');
  @override
  late final GeneratedColumn<int> correctAnswerIndex = GeneratedColumn<int>(
    'correct_answer_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeLimitMeta = const VerificationMeta(
    'timeLimit',
  );
  @override
  late final GeneratedColumn<int> timeLimit = GeneratedColumn<int>(
    'time_limit',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    quizId,
    index,
    content,
    type,
    markValue,
    options,
    correctAnswerIndex,
    timeLimit,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizQuestionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('quiz_id')) {
      context.handle(
        _quizIdMeta,
        quizId.isAcceptableOrUnknown(data['quiz_id']!, _quizIdMeta),
      );
    } else if (isInserting) {
      context.missing(_quizIdMeta);
    }
    if (data.containsKey('index')) {
      context.handle(
        _indexMeta,
        index.isAcceptableOrUnknown(data['index']!, _indexMeta),
      );
    } else if (isInserting) {
      context.missing(_indexMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('mark_value')) {
      context.handle(
        _markValueMeta,
        markValue.isAcceptableOrUnknown(data['mark_value']!, _markValueMeta),
      );
    } else if (isInserting) {
      context.missing(_markValueMeta);
    }
    if (data.containsKey('correct_answer_index')) {
      context.handle(
        _correctAnswerIndexMeta,
        correctAnswerIndex.isAcceptableOrUnknown(
          data['correct_answer_index']!,
          _correctAnswerIndexMeta,
        ),
      );
    }
    if (data.containsKey('time_limit')) {
      context.handle(
        _timeLimitMeta,
        timeLimit.isAcceptableOrUnknown(data['time_limit']!, _timeLimitMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuizQuestionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizQuestionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      quizId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quiz_id'],
      )!,
      index: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}index'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      type: $QuizQuestionsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      markValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mark_value'],
      )!,
      options: $QuizQuestionsTable.$converteroptions.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}options'],
        )!,
      ),
      correctAnswerIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_answer_index'],
      ),
      timeLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_limit'],
      ),
    );
  }

  @override
  $QuizQuestionsTable createAlias(String alias) {
    return $QuizQuestionsTable(attachedDatabase, alias);
  }

  static TypeConverter<QuestionType, String> $convertertype =
      const EnumConverter<QuestionType>(QuestionType.values);
  static TypeConverter<List<String>, String> $converteroptions =
      const StringListConverter();
}

class QuizQuestionRow extends DataClass implements Insertable<QuizQuestionRow> {
  final String id;
  final String quizId;
  final int index;
  final String content;
  final QuestionType type;
  final int markValue;
  final List<String> options;
  final int? correctAnswerIndex;
  final int? timeLimit;
  const QuizQuestionRow({
    required this.id,
    required this.quizId,
    required this.index,
    required this.content,
    required this.type,
    required this.markValue,
    required this.options,
    this.correctAnswerIndex,
    this.timeLimit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['quiz_id'] = Variable<String>(quizId);
    map['index'] = Variable<int>(index);
    map['content'] = Variable<String>(content);
    {
      map['type'] = Variable<String>(
        $QuizQuestionsTable.$convertertype.toSql(type),
      );
    }
    map['mark_value'] = Variable<int>(markValue);
    {
      map['options'] = Variable<String>(
        $QuizQuestionsTable.$converteroptions.toSql(options),
      );
    }
    if (!nullToAbsent || correctAnswerIndex != null) {
      map['correct_answer_index'] = Variable<int>(correctAnswerIndex);
    }
    if (!nullToAbsent || timeLimit != null) {
      map['time_limit'] = Variable<int>(timeLimit);
    }
    return map;
  }

  QuizQuestionsCompanion toCompanion(bool nullToAbsent) {
    return QuizQuestionsCompanion(
      id: Value(id),
      quizId: Value(quizId),
      index: Value(index),
      content: Value(content),
      type: Value(type),
      markValue: Value(markValue),
      options: Value(options),
      correctAnswerIndex: correctAnswerIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(correctAnswerIndex),
      timeLimit: timeLimit == null && nullToAbsent
          ? const Value.absent()
          : Value(timeLimit),
    );
  }

  factory QuizQuestionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizQuestionRow(
      id: serializer.fromJson<String>(json['id']),
      quizId: serializer.fromJson<String>(json['quizId']),
      index: serializer.fromJson<int>(json['index']),
      content: serializer.fromJson<String>(json['content']),
      type: serializer.fromJson<QuestionType>(json['type']),
      markValue: serializer.fromJson<int>(json['markValue']),
      options: serializer.fromJson<List<String>>(json['options']),
      correctAnswerIndex: serializer.fromJson<int?>(json['correctAnswerIndex']),
      timeLimit: serializer.fromJson<int?>(json['timeLimit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'quizId': serializer.toJson<String>(quizId),
      'index': serializer.toJson<int>(index),
      'content': serializer.toJson<String>(content),
      'type': serializer.toJson<QuestionType>(type),
      'markValue': serializer.toJson<int>(markValue),
      'options': serializer.toJson<List<String>>(options),
      'correctAnswerIndex': serializer.toJson<int?>(correctAnswerIndex),
      'timeLimit': serializer.toJson<int?>(timeLimit),
    };
  }

  QuizQuestionRow copyWith({
    String? id,
    String? quizId,
    int? index,
    String? content,
    QuestionType? type,
    int? markValue,
    List<String>? options,
    Value<int?> correctAnswerIndex = const Value.absent(),
    Value<int?> timeLimit = const Value.absent(),
  }) => QuizQuestionRow(
    id: id ?? this.id,
    quizId: quizId ?? this.quizId,
    index: index ?? this.index,
    content: content ?? this.content,
    type: type ?? this.type,
    markValue: markValue ?? this.markValue,
    options: options ?? this.options,
    correctAnswerIndex: correctAnswerIndex.present
        ? correctAnswerIndex.value
        : this.correctAnswerIndex,
    timeLimit: timeLimit.present ? timeLimit.value : this.timeLimit,
  );
  QuizQuestionRow copyWithCompanion(QuizQuestionsCompanion data) {
    return QuizQuestionRow(
      id: data.id.present ? data.id.value : this.id,
      quizId: data.quizId.present ? data.quizId.value : this.quizId,
      index: data.index.present ? data.index.value : this.index,
      content: data.content.present ? data.content.value : this.content,
      type: data.type.present ? data.type.value : this.type,
      markValue: data.markValue.present ? data.markValue.value : this.markValue,
      options: data.options.present ? data.options.value : this.options,
      correctAnswerIndex: data.correctAnswerIndex.present
          ? data.correctAnswerIndex.value
          : this.correctAnswerIndex,
      timeLimit: data.timeLimit.present ? data.timeLimit.value : this.timeLimit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizQuestionRow(')
          ..write('id: $id, ')
          ..write('quizId: $quizId, ')
          ..write('index: $index, ')
          ..write('content: $content, ')
          ..write('type: $type, ')
          ..write('markValue: $markValue, ')
          ..write('options: $options, ')
          ..write('correctAnswerIndex: $correctAnswerIndex, ')
          ..write('timeLimit: $timeLimit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    quizId,
    index,
    content,
    type,
    markValue,
    options,
    correctAnswerIndex,
    timeLimit,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizQuestionRow &&
          other.id == this.id &&
          other.quizId == this.quizId &&
          other.index == this.index &&
          other.content == this.content &&
          other.type == this.type &&
          other.markValue == this.markValue &&
          other.options == this.options &&
          other.correctAnswerIndex == this.correctAnswerIndex &&
          other.timeLimit == this.timeLimit);
}

class QuizQuestionsCompanion extends UpdateCompanion<QuizQuestionRow> {
  final Value<String> id;
  final Value<String> quizId;
  final Value<int> index;
  final Value<String> content;
  final Value<QuestionType> type;
  final Value<int> markValue;
  final Value<List<String>> options;
  final Value<int?> correctAnswerIndex;
  final Value<int?> timeLimit;
  final Value<int> rowid;
  const QuizQuestionsCompanion({
    this.id = const Value.absent(),
    this.quizId = const Value.absent(),
    this.index = const Value.absent(),
    this.content = const Value.absent(),
    this.type = const Value.absent(),
    this.markValue = const Value.absent(),
    this.options = const Value.absent(),
    this.correctAnswerIndex = const Value.absent(),
    this.timeLimit = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuizQuestionsCompanion.insert({
    required String id,
    required String quizId,
    required int index,
    required String content,
    required QuestionType type,
    required int markValue,
    required List<String> options,
    this.correctAnswerIndex = const Value.absent(),
    this.timeLimit = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       quizId = Value(quizId),
       index = Value(index),
       content = Value(content),
       type = Value(type),
       markValue = Value(markValue),
       options = Value(options);
  static Insertable<QuizQuestionRow> custom({
    Expression<String>? id,
    Expression<String>? quizId,
    Expression<int>? index,
    Expression<String>? content,
    Expression<String>? type,
    Expression<int>? markValue,
    Expression<String>? options,
    Expression<int>? correctAnswerIndex,
    Expression<int>? timeLimit,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (quizId != null) 'quiz_id': quizId,
      if (index != null) 'index': index,
      if (content != null) 'content': content,
      if (type != null) 'type': type,
      if (markValue != null) 'mark_value': markValue,
      if (options != null) 'options': options,
      if (correctAnswerIndex != null)
        'correct_answer_index': correctAnswerIndex,
      if (timeLimit != null) 'time_limit': timeLimit,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuizQuestionsCompanion copyWith({
    Value<String>? id,
    Value<String>? quizId,
    Value<int>? index,
    Value<String>? content,
    Value<QuestionType>? type,
    Value<int>? markValue,
    Value<List<String>>? options,
    Value<int?>? correctAnswerIndex,
    Value<int?>? timeLimit,
    Value<int>? rowid,
  }) {
    return QuizQuestionsCompanion(
      id: id ?? this.id,
      quizId: quizId ?? this.quizId,
      index: index ?? this.index,
      content: content ?? this.content,
      type: type ?? this.type,
      markValue: markValue ?? this.markValue,
      options: options ?? this.options,
      correctAnswerIndex: correctAnswerIndex ?? this.correctAnswerIndex,
      timeLimit: timeLimit ?? this.timeLimit,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (quizId.present) {
      map['quiz_id'] = Variable<String>(quizId.value);
    }
    if (index.present) {
      map['index'] = Variable<int>(index.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $QuizQuestionsTable.$convertertype.toSql(type.value),
      );
    }
    if (markValue.present) {
      map['mark_value'] = Variable<int>(markValue.value);
    }
    if (options.present) {
      map['options'] = Variable<String>(
        $QuizQuestionsTable.$converteroptions.toSql(options.value),
      );
    }
    if (correctAnswerIndex.present) {
      map['correct_answer_index'] = Variable<int>(correctAnswerIndex.value);
    }
    if (timeLimit.present) {
      map['time_limit'] = Variable<int>(timeLimit.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizQuestionsCompanion(')
          ..write('id: $id, ')
          ..write('quizId: $quizId, ')
          ..write('index: $index, ')
          ..write('content: $content, ')
          ..write('type: $type, ')
          ..write('markValue: $markValue, ')
          ..write('options: $options, ')
          ..write('correctAnswerIndex: $correctAnswerIndex, ')
          ..write('timeLimit: $timeLimit, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuizAttemptsTable extends QuizAttempts
    with TableInfo<$QuizAttemptsTable, QuizAttemptRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quizIdMeta = const VerificationMeta('quizId');
  @override
  late final GeneratedColumn<String> quizId = GeneratedColumn<String>(
    'quiz_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quizzes (id)',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
    'question_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quiz_questions (id)',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _selectedAnswerIndexMeta =
      const VerificationMeta('selectedAnswerIndex');
  @override
  late final GeneratedColumn<int> selectedAnswerIndex = GeneratedColumn<int>(
    'selected_answer_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCorrectMeta = const VerificationMeta(
    'isCorrect',
  );
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
    'is_correct',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_correct" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    quizId,
    userId,
    questionId,
    timestamp,
    selectedAnswerIndex,
    isCorrect,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_attempts';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizAttemptRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('quiz_id')) {
      context.handle(
        _quizIdMeta,
        quizId.isAcceptableOrUnknown(data['quiz_id']!, _quizIdMeta),
      );
    } else if (isInserting) {
      context.missing(_quizIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('selected_answer_index')) {
      context.handle(
        _selectedAnswerIndexMeta,
        selectedAnswerIndex.isAcceptableOrUnknown(
          data['selected_answer_index']!,
          _selectedAnswerIndexMeta,
        ),
      );
    }
    if (data.containsKey('is_correct')) {
      context.handle(
        _isCorrectMeta,
        isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuizAttemptRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizAttemptRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      quizId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quiz_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      selectedAnswerIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selected_answer_index'],
      ),
      isCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_correct'],
      ),
    );
  }

  @override
  $QuizAttemptsTable createAlias(String alias) {
    return $QuizAttemptsTable(attachedDatabase, alias);
  }
}

class QuizAttemptRow extends DataClass implements Insertable<QuizAttemptRow> {
  final String id;
  final String quizId;
  final String userId;
  final String questionId;
  final DateTime timestamp;
  final int? selectedAnswerIndex;
  final bool? isCorrect;
  const QuizAttemptRow({
    required this.id,
    required this.quizId,
    required this.userId,
    required this.questionId,
    required this.timestamp,
    this.selectedAnswerIndex,
    this.isCorrect,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['quiz_id'] = Variable<String>(quizId);
    map['user_id'] = Variable<String>(userId);
    map['question_id'] = Variable<String>(questionId);
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || selectedAnswerIndex != null) {
      map['selected_answer_index'] = Variable<int>(selectedAnswerIndex);
    }
    if (!nullToAbsent || isCorrect != null) {
      map['is_correct'] = Variable<bool>(isCorrect);
    }
    return map;
  }

  QuizAttemptsCompanion toCompanion(bool nullToAbsent) {
    return QuizAttemptsCompanion(
      id: Value(id),
      quizId: Value(quizId),
      userId: Value(userId),
      questionId: Value(questionId),
      timestamp: Value(timestamp),
      selectedAnswerIndex: selectedAnswerIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedAnswerIndex),
      isCorrect: isCorrect == null && nullToAbsent
          ? const Value.absent()
          : Value(isCorrect),
    );
  }

  factory QuizAttemptRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizAttemptRow(
      id: serializer.fromJson<String>(json['id']),
      quizId: serializer.fromJson<String>(json['quizId']),
      userId: serializer.fromJson<String>(json['userId']),
      questionId: serializer.fromJson<String>(json['questionId']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      selectedAnswerIndex: serializer.fromJson<int?>(
        json['selectedAnswerIndex'],
      ),
      isCorrect: serializer.fromJson<bool?>(json['isCorrect']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'quizId': serializer.toJson<String>(quizId),
      'userId': serializer.toJson<String>(userId),
      'questionId': serializer.toJson<String>(questionId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'selectedAnswerIndex': serializer.toJson<int?>(selectedAnswerIndex),
      'isCorrect': serializer.toJson<bool?>(isCorrect),
    };
  }

  QuizAttemptRow copyWith({
    String? id,
    String? quizId,
    String? userId,
    String? questionId,
    DateTime? timestamp,
    Value<int?> selectedAnswerIndex = const Value.absent(),
    Value<bool?> isCorrect = const Value.absent(),
  }) => QuizAttemptRow(
    id: id ?? this.id,
    quizId: quizId ?? this.quizId,
    userId: userId ?? this.userId,
    questionId: questionId ?? this.questionId,
    timestamp: timestamp ?? this.timestamp,
    selectedAnswerIndex: selectedAnswerIndex.present
        ? selectedAnswerIndex.value
        : this.selectedAnswerIndex,
    isCorrect: isCorrect.present ? isCorrect.value : this.isCorrect,
  );
  QuizAttemptRow copyWithCompanion(QuizAttemptsCompanion data) {
    return QuizAttemptRow(
      id: data.id.present ? data.id.value : this.id,
      quizId: data.quizId.present ? data.quizId.value : this.quizId,
      userId: data.userId.present ? data.userId.value : this.userId,
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      selectedAnswerIndex: data.selectedAnswerIndex.present
          ? data.selectedAnswerIndex.value
          : this.selectedAnswerIndex,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizAttemptRow(')
          ..write('id: $id, ')
          ..write('quizId: $quizId, ')
          ..write('userId: $userId, ')
          ..write('questionId: $questionId, ')
          ..write('timestamp: $timestamp, ')
          ..write('selectedAnswerIndex: $selectedAnswerIndex, ')
          ..write('isCorrect: $isCorrect')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    quizId,
    userId,
    questionId,
    timestamp,
    selectedAnswerIndex,
    isCorrect,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizAttemptRow &&
          other.id == this.id &&
          other.quizId == this.quizId &&
          other.userId == this.userId &&
          other.questionId == this.questionId &&
          other.timestamp == this.timestamp &&
          other.selectedAnswerIndex == this.selectedAnswerIndex &&
          other.isCorrect == this.isCorrect);
}

class QuizAttemptsCompanion extends UpdateCompanion<QuizAttemptRow> {
  final Value<String> id;
  final Value<String> quizId;
  final Value<String> userId;
  final Value<String> questionId;
  final Value<DateTime> timestamp;
  final Value<int?> selectedAnswerIndex;
  final Value<bool?> isCorrect;
  final Value<int> rowid;
  const QuizAttemptsCompanion({
    this.id = const Value.absent(),
    this.quizId = const Value.absent(),
    this.userId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.selectedAnswerIndex = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuizAttemptsCompanion.insert({
    required String id,
    required String quizId,
    required String userId,
    required String questionId,
    required DateTime timestamp,
    this.selectedAnswerIndex = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       quizId = Value(quizId),
       userId = Value(userId),
       questionId = Value(questionId),
       timestamp = Value(timestamp);
  static Insertable<QuizAttemptRow> custom({
    Expression<String>? id,
    Expression<String>? quizId,
    Expression<String>? userId,
    Expression<String>? questionId,
    Expression<DateTime>? timestamp,
    Expression<int>? selectedAnswerIndex,
    Expression<bool>? isCorrect,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (quizId != null) 'quiz_id': quizId,
      if (userId != null) 'user_id': userId,
      if (questionId != null) 'question_id': questionId,
      if (timestamp != null) 'timestamp': timestamp,
      if (selectedAnswerIndex != null)
        'selected_answer_index': selectedAnswerIndex,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuizAttemptsCompanion copyWith({
    Value<String>? id,
    Value<String>? quizId,
    Value<String>? userId,
    Value<String>? questionId,
    Value<DateTime>? timestamp,
    Value<int?>? selectedAnswerIndex,
    Value<bool?>? isCorrect,
    Value<int>? rowid,
  }) {
    return QuizAttemptsCompanion(
      id: id ?? this.id,
      quizId: quizId ?? this.quizId,
      userId: userId ?? this.userId,
      questionId: questionId ?? this.questionId,
      timestamp: timestamp ?? this.timestamp,
      selectedAnswerIndex: selectedAnswerIndex ?? this.selectedAnswerIndex,
      isCorrect: isCorrect ?? this.isCorrect,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (quizId.present) {
      map['quiz_id'] = Variable<String>(quizId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (selectedAnswerIndex.present) {
      map['selected_answer_index'] = Variable<int>(selectedAnswerIndex.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizAttemptsCompanion(')
          ..write('id: $id, ')
          ..write('quizId: $quizId, ')
          ..write('userId: $userId, ')
          ..write('questionId: $questionId, ')
          ..write('timestamp: $timestamp, ')
          ..write('selectedAnswerIndex: $selectedAnswerIndex, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuizFeedbackItemsTable extends QuizFeedbackItems
    with TableInfo<$QuizFeedbackItemsTable, QuizFeedbackRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizFeedbackItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptIdMeta = const VerificationMeta(
    'attemptId',
  );
  @override
  late final GeneratedColumn<String> attemptId = GeneratedColumn<String>(
    'attempt_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quiz_attempts (id)',
    ),
  );
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
    'question_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quiz_questions (id)',
    ),
  );
  static const VerificationMeta _isCorrectMeta = const VerificationMeta(
    'isCorrect',
  );
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
    'is_correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_correct" IN (0, 1))',
    ),
  );
  static const VerificationMeta _feedbackTextMeta = const VerificationMeta(
    'feedbackText',
  );
  @override
  late final GeneratedColumn<String> feedbackText = GeneratedColumn<String>(
    'feedback_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationMeta = const VerificationMeta(
    'explanation',
  );
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
    'explanation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    attemptId,
    questionId,
    isCorrect,
    feedbackText,
    explanation,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_feedback_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizFeedbackRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('attempt_id')) {
      context.handle(
        _attemptIdMeta,
        attemptId.isAcceptableOrUnknown(data['attempt_id']!, _attemptIdMeta),
      );
    } else if (isInserting) {
      context.missing(_attemptIdMeta);
    }
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('is_correct')) {
      context.handle(
        _isCorrectMeta,
        isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta),
      );
    } else if (isInserting) {
      context.missing(_isCorrectMeta);
    }
    if (data.containsKey('feedback_text')) {
      context.handle(
        _feedbackTextMeta,
        feedbackText.isAcceptableOrUnknown(
          data['feedback_text']!,
          _feedbackTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_feedbackTextMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
        _explanationMeta,
        explanation.isAcceptableOrUnknown(
          data['explanation']!,
          _explanationMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuizFeedbackRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizFeedbackRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      attemptId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attempt_id'],
      )!,
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_id'],
      )!,
      isCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_correct'],
      )!,
      feedbackText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feedback_text'],
      )!,
      explanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation'],
      ),
    );
  }

  @override
  $QuizFeedbackItemsTable createAlias(String alias) {
    return $QuizFeedbackItemsTable(attachedDatabase, alias);
  }
}

class QuizFeedbackRow extends DataClass implements Insertable<QuizFeedbackRow> {
  final String id;
  final String attemptId;
  final String questionId;
  final bool isCorrect;
  final String feedbackText;
  final String? explanation;
  const QuizFeedbackRow({
    required this.id,
    required this.attemptId,
    required this.questionId,
    required this.isCorrect,
    required this.feedbackText,
    this.explanation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['attempt_id'] = Variable<String>(attemptId);
    map['question_id'] = Variable<String>(questionId);
    map['is_correct'] = Variable<bool>(isCorrect);
    map['feedback_text'] = Variable<String>(feedbackText);
    if (!nullToAbsent || explanation != null) {
      map['explanation'] = Variable<String>(explanation);
    }
    return map;
  }

  QuizFeedbackItemsCompanion toCompanion(bool nullToAbsent) {
    return QuizFeedbackItemsCompanion(
      id: Value(id),
      attemptId: Value(attemptId),
      questionId: Value(questionId),
      isCorrect: Value(isCorrect),
      feedbackText: Value(feedbackText),
      explanation: explanation == null && nullToAbsent
          ? const Value.absent()
          : Value(explanation),
    );
  }

  factory QuizFeedbackRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizFeedbackRow(
      id: serializer.fromJson<String>(json['id']),
      attemptId: serializer.fromJson<String>(json['attemptId']),
      questionId: serializer.fromJson<String>(json['questionId']),
      isCorrect: serializer.fromJson<bool>(json['isCorrect']),
      feedbackText: serializer.fromJson<String>(json['feedbackText']),
      explanation: serializer.fromJson<String?>(json['explanation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'attemptId': serializer.toJson<String>(attemptId),
      'questionId': serializer.toJson<String>(questionId),
      'isCorrect': serializer.toJson<bool>(isCorrect),
      'feedbackText': serializer.toJson<String>(feedbackText),
      'explanation': serializer.toJson<String?>(explanation),
    };
  }

  QuizFeedbackRow copyWith({
    String? id,
    String? attemptId,
    String? questionId,
    bool? isCorrect,
    String? feedbackText,
    Value<String?> explanation = const Value.absent(),
  }) => QuizFeedbackRow(
    id: id ?? this.id,
    attemptId: attemptId ?? this.attemptId,
    questionId: questionId ?? this.questionId,
    isCorrect: isCorrect ?? this.isCorrect,
    feedbackText: feedbackText ?? this.feedbackText,
    explanation: explanation.present ? explanation.value : this.explanation,
  );
  QuizFeedbackRow copyWithCompanion(QuizFeedbackItemsCompanion data) {
    return QuizFeedbackRow(
      id: data.id.present ? data.id.value : this.id,
      attemptId: data.attemptId.present ? data.attemptId.value : this.attemptId,
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
      feedbackText: data.feedbackText.present
          ? data.feedbackText.value
          : this.feedbackText,
      explanation: data.explanation.present
          ? data.explanation.value
          : this.explanation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizFeedbackRow(')
          ..write('id: $id, ')
          ..write('attemptId: $attemptId, ')
          ..write('questionId: $questionId, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('feedbackText: $feedbackText, ')
          ..write('explanation: $explanation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    attemptId,
    questionId,
    isCorrect,
    feedbackText,
    explanation,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizFeedbackRow &&
          other.id == this.id &&
          other.attemptId == this.attemptId &&
          other.questionId == this.questionId &&
          other.isCorrect == this.isCorrect &&
          other.feedbackText == this.feedbackText &&
          other.explanation == this.explanation);
}

class QuizFeedbackItemsCompanion extends UpdateCompanion<QuizFeedbackRow> {
  final Value<String> id;
  final Value<String> attemptId;
  final Value<String> questionId;
  final Value<bool> isCorrect;
  final Value<String> feedbackText;
  final Value<String?> explanation;
  final Value<int> rowid;
  const QuizFeedbackItemsCompanion({
    this.id = const Value.absent(),
    this.attemptId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.feedbackText = const Value.absent(),
    this.explanation = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuizFeedbackItemsCompanion.insert({
    required String id,
    required String attemptId,
    required String questionId,
    required bool isCorrect,
    required String feedbackText,
    this.explanation = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       attemptId = Value(attemptId),
       questionId = Value(questionId),
       isCorrect = Value(isCorrect),
       feedbackText = Value(feedbackText);
  static Insertable<QuizFeedbackRow> custom({
    Expression<String>? id,
    Expression<String>? attemptId,
    Expression<String>? questionId,
    Expression<bool>? isCorrect,
    Expression<String>? feedbackText,
    Expression<String>? explanation,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (attemptId != null) 'attempt_id': attemptId,
      if (questionId != null) 'question_id': questionId,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (feedbackText != null) 'feedback_text': feedbackText,
      if (explanation != null) 'explanation': explanation,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuizFeedbackItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? attemptId,
    Value<String>? questionId,
    Value<bool>? isCorrect,
    Value<String>? feedbackText,
    Value<String?>? explanation,
    Value<int>? rowid,
  }) {
    return QuizFeedbackItemsCompanion(
      id: id ?? this.id,
      attemptId: attemptId ?? this.attemptId,
      questionId: questionId ?? this.questionId,
      isCorrect: isCorrect ?? this.isCorrect,
      feedbackText: feedbackText ?? this.feedbackText,
      explanation: explanation ?? this.explanation,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (attemptId.present) {
      map['attempt_id'] = Variable<String>(attemptId.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    if (feedbackText.present) {
      map['feedback_text'] = Variable<String>(feedbackText.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizFeedbackItemsCompanion(')
          ..write('id: $id, ')
          ..write('attemptId: $attemptId, ')
          ..write('questionId: $questionId, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('feedbackText: $feedbackText, ')
          ..write('explanation: $explanation, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProgressMetricsTable extends ProgressMetrics
    with TableInfo<$ProgressMetricsTable, ProgressMetricRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgressMetricsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subjects (id)',
    ),
  );
  static const VerificationMeta _readinessScoreMeta = const VerificationMeta(
    'readinessScore',
  );
  @override
  late final GeneratedColumn<int> readinessScore = GeneratedColumn<int>(
    'readiness_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastUpdatedAtMeta = const VerificationMeta(
    'lastUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdatedAt =
      GeneratedColumn<DateTime>(
        'last_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _predictedScoreMinMeta = const VerificationMeta(
    'predictedScoreMin',
  );
  @override
  late final GeneratedColumn<int> predictedScoreMin = GeneratedColumn<int>(
    'predicted_score_min',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _predictedScoreMaxMeta = const VerificationMeta(
    'predictedScoreMax',
  );
  @override
  late final GeneratedColumn<int> predictedScoreMax = GeneratedColumn<int>(
    'predicted_score_max',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weeklyGainMeta = const VerificationMeta(
    'weeklyGain',
  );
  @override
  late final GeneratedColumn<int> weeklyGain = GeneratedColumn<int>(
    'weekly_gain',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aiInsightMeta = const VerificationMeta(
    'aiInsight',
  );
  @override
  late final GeneratedColumn<String> aiInsight = GeneratedColumn<String>(
    'ai_insight',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    subjectId,
    readinessScore,
    lastUpdatedAt,
    predictedScoreMin,
    predictedScoreMax,
    weeklyGain,
    aiInsight,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'progress_metrics';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProgressMetricRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('readiness_score')) {
      context.handle(
        _readinessScoreMeta,
        readinessScore.isAcceptableOrUnknown(
          data['readiness_score']!,
          _readinessScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_readinessScoreMeta);
    }
    if (data.containsKey('last_updated_at')) {
      context.handle(
        _lastUpdatedAtMeta,
        lastUpdatedAt.isAcceptableOrUnknown(
          data['last_updated_at']!,
          _lastUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUpdatedAtMeta);
    }
    if (data.containsKey('predicted_score_min')) {
      context.handle(
        _predictedScoreMinMeta,
        predictedScoreMin.isAcceptableOrUnknown(
          data['predicted_score_min']!,
          _predictedScoreMinMeta,
        ),
      );
    }
    if (data.containsKey('predicted_score_max')) {
      context.handle(
        _predictedScoreMaxMeta,
        predictedScoreMax.isAcceptableOrUnknown(
          data['predicted_score_max']!,
          _predictedScoreMaxMeta,
        ),
      );
    }
    if (data.containsKey('weekly_gain')) {
      context.handle(
        _weeklyGainMeta,
        weeklyGain.isAcceptableOrUnknown(data['weekly_gain']!, _weeklyGainMeta),
      );
    }
    if (data.containsKey('ai_insight')) {
      context.handle(
        _aiInsightMeta,
        aiInsight.isAcceptableOrUnknown(data['ai_insight']!, _aiInsightMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, subjectId};
  @override
  ProgressMetricRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgressMetricRow(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_id'],
      )!,
      readinessScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}readiness_score'],
      )!,
      lastUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated_at'],
      )!,
      predictedScoreMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}predicted_score_min'],
      ),
      predictedScoreMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}predicted_score_max'],
      ),
      weeklyGain: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekly_gain'],
      ),
      aiInsight: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_insight'],
      ),
    );
  }

  @override
  $ProgressMetricsTable createAlias(String alias) {
    return $ProgressMetricsTable(attachedDatabase, alias);
  }
}

class ProgressMetricRow extends DataClass
    implements Insertable<ProgressMetricRow> {
  final String userId;
  final String subjectId;
  final int readinessScore;
  final DateTime lastUpdatedAt;
  final int? predictedScoreMin;
  final int? predictedScoreMax;
  final int? weeklyGain;
  final String? aiInsight;
  const ProgressMetricRow({
    required this.userId,
    required this.subjectId,
    required this.readinessScore,
    required this.lastUpdatedAt,
    this.predictedScoreMin,
    this.predictedScoreMax,
    this.weeklyGain,
    this.aiInsight,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['subject_id'] = Variable<String>(subjectId);
    map['readiness_score'] = Variable<int>(readinessScore);
    map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt);
    if (!nullToAbsent || predictedScoreMin != null) {
      map['predicted_score_min'] = Variable<int>(predictedScoreMin);
    }
    if (!nullToAbsent || predictedScoreMax != null) {
      map['predicted_score_max'] = Variable<int>(predictedScoreMax);
    }
    if (!nullToAbsent || weeklyGain != null) {
      map['weekly_gain'] = Variable<int>(weeklyGain);
    }
    if (!nullToAbsent || aiInsight != null) {
      map['ai_insight'] = Variable<String>(aiInsight);
    }
    return map;
  }

  ProgressMetricsCompanion toCompanion(bool nullToAbsent) {
    return ProgressMetricsCompanion(
      userId: Value(userId),
      subjectId: Value(subjectId),
      readinessScore: Value(readinessScore),
      lastUpdatedAt: Value(lastUpdatedAt),
      predictedScoreMin: predictedScoreMin == null && nullToAbsent
          ? const Value.absent()
          : Value(predictedScoreMin),
      predictedScoreMax: predictedScoreMax == null && nullToAbsent
          ? const Value.absent()
          : Value(predictedScoreMax),
      weeklyGain: weeklyGain == null && nullToAbsent
          ? const Value.absent()
          : Value(weeklyGain),
      aiInsight: aiInsight == null && nullToAbsent
          ? const Value.absent()
          : Value(aiInsight),
    );
  }

  factory ProgressMetricRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgressMetricRow(
      userId: serializer.fromJson<String>(json['userId']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      readinessScore: serializer.fromJson<int>(json['readinessScore']),
      lastUpdatedAt: serializer.fromJson<DateTime>(json['lastUpdatedAt']),
      predictedScoreMin: serializer.fromJson<int?>(json['predictedScoreMin']),
      predictedScoreMax: serializer.fromJson<int?>(json['predictedScoreMax']),
      weeklyGain: serializer.fromJson<int?>(json['weeklyGain']),
      aiInsight: serializer.fromJson<String?>(json['aiInsight']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'subjectId': serializer.toJson<String>(subjectId),
      'readinessScore': serializer.toJson<int>(readinessScore),
      'lastUpdatedAt': serializer.toJson<DateTime>(lastUpdatedAt),
      'predictedScoreMin': serializer.toJson<int?>(predictedScoreMin),
      'predictedScoreMax': serializer.toJson<int?>(predictedScoreMax),
      'weeklyGain': serializer.toJson<int?>(weeklyGain),
      'aiInsight': serializer.toJson<String?>(aiInsight),
    };
  }

  ProgressMetricRow copyWith({
    String? userId,
    String? subjectId,
    int? readinessScore,
    DateTime? lastUpdatedAt,
    Value<int?> predictedScoreMin = const Value.absent(),
    Value<int?> predictedScoreMax = const Value.absent(),
    Value<int?> weeklyGain = const Value.absent(),
    Value<String?> aiInsight = const Value.absent(),
  }) => ProgressMetricRow(
    userId: userId ?? this.userId,
    subjectId: subjectId ?? this.subjectId,
    readinessScore: readinessScore ?? this.readinessScore,
    lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    predictedScoreMin: predictedScoreMin.present
        ? predictedScoreMin.value
        : this.predictedScoreMin,
    predictedScoreMax: predictedScoreMax.present
        ? predictedScoreMax.value
        : this.predictedScoreMax,
    weeklyGain: weeklyGain.present ? weeklyGain.value : this.weeklyGain,
    aiInsight: aiInsight.present ? aiInsight.value : this.aiInsight,
  );
  ProgressMetricRow copyWithCompanion(ProgressMetricsCompanion data) {
    return ProgressMetricRow(
      userId: data.userId.present ? data.userId.value : this.userId,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      readinessScore: data.readinessScore.present
          ? data.readinessScore.value
          : this.readinessScore,
      lastUpdatedAt: data.lastUpdatedAt.present
          ? data.lastUpdatedAt.value
          : this.lastUpdatedAt,
      predictedScoreMin: data.predictedScoreMin.present
          ? data.predictedScoreMin.value
          : this.predictedScoreMin,
      predictedScoreMax: data.predictedScoreMax.present
          ? data.predictedScoreMax.value
          : this.predictedScoreMax,
      weeklyGain: data.weeklyGain.present
          ? data.weeklyGain.value
          : this.weeklyGain,
      aiInsight: data.aiInsight.present ? data.aiInsight.value : this.aiInsight,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgressMetricRow(')
          ..write('userId: $userId, ')
          ..write('subjectId: $subjectId, ')
          ..write('readinessScore: $readinessScore, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('predictedScoreMin: $predictedScoreMin, ')
          ..write('predictedScoreMax: $predictedScoreMax, ')
          ..write('weeklyGain: $weeklyGain, ')
          ..write('aiInsight: $aiInsight')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    subjectId,
    readinessScore,
    lastUpdatedAt,
    predictedScoreMin,
    predictedScoreMax,
    weeklyGain,
    aiInsight,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgressMetricRow &&
          other.userId == this.userId &&
          other.subjectId == this.subjectId &&
          other.readinessScore == this.readinessScore &&
          other.lastUpdatedAt == this.lastUpdatedAt &&
          other.predictedScoreMin == this.predictedScoreMin &&
          other.predictedScoreMax == this.predictedScoreMax &&
          other.weeklyGain == this.weeklyGain &&
          other.aiInsight == this.aiInsight);
}

class ProgressMetricsCompanion extends UpdateCompanion<ProgressMetricRow> {
  final Value<String> userId;
  final Value<String> subjectId;
  final Value<int> readinessScore;
  final Value<DateTime> lastUpdatedAt;
  final Value<int?> predictedScoreMin;
  final Value<int?> predictedScoreMax;
  final Value<int?> weeklyGain;
  final Value<String?> aiInsight;
  final Value<int> rowid;
  const ProgressMetricsCompanion({
    this.userId = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.readinessScore = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.predictedScoreMin = const Value.absent(),
    this.predictedScoreMax = const Value.absent(),
    this.weeklyGain = const Value.absent(),
    this.aiInsight = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgressMetricsCompanion.insert({
    required String userId,
    required String subjectId,
    required int readinessScore,
    required DateTime lastUpdatedAt,
    this.predictedScoreMin = const Value.absent(),
    this.predictedScoreMax = const Value.absent(),
    this.weeklyGain = const Value.absent(),
    this.aiInsight = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       subjectId = Value(subjectId),
       readinessScore = Value(readinessScore),
       lastUpdatedAt = Value(lastUpdatedAt);
  static Insertable<ProgressMetricRow> custom({
    Expression<String>? userId,
    Expression<String>? subjectId,
    Expression<int>? readinessScore,
    Expression<DateTime>? lastUpdatedAt,
    Expression<int>? predictedScoreMin,
    Expression<int>? predictedScoreMax,
    Expression<int>? weeklyGain,
    Expression<String>? aiInsight,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (subjectId != null) 'subject_id': subjectId,
      if (readinessScore != null) 'readiness_score': readinessScore,
      if (lastUpdatedAt != null) 'last_updated_at': lastUpdatedAt,
      if (predictedScoreMin != null) 'predicted_score_min': predictedScoreMin,
      if (predictedScoreMax != null) 'predicted_score_max': predictedScoreMax,
      if (weeklyGain != null) 'weekly_gain': weeklyGain,
      if (aiInsight != null) 'ai_insight': aiInsight,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgressMetricsCompanion copyWith({
    Value<String>? userId,
    Value<String>? subjectId,
    Value<int>? readinessScore,
    Value<DateTime>? lastUpdatedAt,
    Value<int?>? predictedScoreMin,
    Value<int?>? predictedScoreMax,
    Value<int?>? weeklyGain,
    Value<String?>? aiInsight,
    Value<int>? rowid,
  }) {
    return ProgressMetricsCompanion(
      userId: userId ?? this.userId,
      subjectId: subjectId ?? this.subjectId,
      readinessScore: readinessScore ?? this.readinessScore,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      predictedScoreMin: predictedScoreMin ?? this.predictedScoreMin,
      predictedScoreMax: predictedScoreMax ?? this.predictedScoreMax,
      weeklyGain: weeklyGain ?? this.weeklyGain,
      aiInsight: aiInsight ?? this.aiInsight,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (readinessScore.present) {
      map['readiness_score'] = Variable<int>(readinessScore.value);
    }
    if (lastUpdatedAt.present) {
      map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt.value);
    }
    if (predictedScoreMin.present) {
      map['predicted_score_min'] = Variable<int>(predictedScoreMin.value);
    }
    if (predictedScoreMax.present) {
      map['predicted_score_max'] = Variable<int>(predictedScoreMax.value);
    }
    if (weeklyGain.present) {
      map['weekly_gain'] = Variable<int>(weeklyGain.value);
    }
    if (aiInsight.present) {
      map['ai_insight'] = Variable<String>(aiInsight.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgressMetricsCompanion(')
          ..write('userId: $userId, ')
          ..write('subjectId: $subjectId, ')
          ..write('readinessScore: $readinessScore, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('predictedScoreMin: $predictedScoreMin, ')
          ..write('predictedScoreMax: $predictedScoreMax, ')
          ..write('weeklyGain: $weeklyGain, ')
          ..write('aiInsight: $aiInsight, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudyStreaksTable extends StudyStreaks
    with TableInfo<$StudyStreaksTable, StudyStreakRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyStreaksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayCountMeta = const VerificationMeta(
    'dayCount',
  );
  @override
  late final GeneratedColumn<int> dayCount = GeneratedColumn<int>(
    'day_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastStudiedDateMeta = const VerificationMeta(
    'lastStudiedDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastStudiedDate =
      GeneratedColumn<DateTime>(
        'last_studied_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    dayCount,
    lastStudiedDate,
    startDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_streaks';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudyStreakRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('day_count')) {
      context.handle(
        _dayCountMeta,
        dayCount.isAcceptableOrUnknown(data['day_count']!, _dayCountMeta),
      );
    } else if (isInserting) {
      context.missing(_dayCountMeta);
    }
    if (data.containsKey('last_studied_date')) {
      context.handle(
        _lastStudiedDateMeta,
        lastStudiedDate.isAcceptableOrUnknown(
          data['last_studied_date']!,
          _lastStudiedDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastStudiedDateMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  StudyStreakRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyStreakRow(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      dayCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_count'],
      )!,
      lastStudiedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_studied_date'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
    );
  }

  @override
  $StudyStreaksTable createAlias(String alias) {
    return $StudyStreaksTable(attachedDatabase, alias);
  }
}

class StudyStreakRow extends DataClass implements Insertable<StudyStreakRow> {
  final String userId;
  final int dayCount;
  final DateTime lastStudiedDate;
  final DateTime startDate;
  const StudyStreakRow({
    required this.userId,
    required this.dayCount,
    required this.lastStudiedDate,
    required this.startDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['day_count'] = Variable<int>(dayCount);
    map['last_studied_date'] = Variable<DateTime>(lastStudiedDate);
    map['start_date'] = Variable<DateTime>(startDate);
    return map;
  }

  StudyStreaksCompanion toCompanion(bool nullToAbsent) {
    return StudyStreaksCompanion(
      userId: Value(userId),
      dayCount: Value(dayCount),
      lastStudiedDate: Value(lastStudiedDate),
      startDate: Value(startDate),
    );
  }

  factory StudyStreakRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyStreakRow(
      userId: serializer.fromJson<String>(json['userId']),
      dayCount: serializer.fromJson<int>(json['dayCount']),
      lastStudiedDate: serializer.fromJson<DateTime>(json['lastStudiedDate']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'dayCount': serializer.toJson<int>(dayCount),
      'lastStudiedDate': serializer.toJson<DateTime>(lastStudiedDate),
      'startDate': serializer.toJson<DateTime>(startDate),
    };
  }

  StudyStreakRow copyWith({
    String? userId,
    int? dayCount,
    DateTime? lastStudiedDate,
    DateTime? startDate,
  }) => StudyStreakRow(
    userId: userId ?? this.userId,
    dayCount: dayCount ?? this.dayCount,
    lastStudiedDate: lastStudiedDate ?? this.lastStudiedDate,
    startDate: startDate ?? this.startDate,
  );
  StudyStreakRow copyWithCompanion(StudyStreaksCompanion data) {
    return StudyStreakRow(
      userId: data.userId.present ? data.userId.value : this.userId,
      dayCount: data.dayCount.present ? data.dayCount.value : this.dayCount,
      lastStudiedDate: data.lastStudiedDate.present
          ? data.lastStudiedDate.value
          : this.lastStudiedDate,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyStreakRow(')
          ..write('userId: $userId, ')
          ..write('dayCount: $dayCount, ')
          ..write('lastStudiedDate: $lastStudiedDate, ')
          ..write('startDate: $startDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, dayCount, lastStudiedDate, startDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyStreakRow &&
          other.userId == this.userId &&
          other.dayCount == this.dayCount &&
          other.lastStudiedDate == this.lastStudiedDate &&
          other.startDate == this.startDate);
}

class StudyStreaksCompanion extends UpdateCompanion<StudyStreakRow> {
  final Value<String> userId;
  final Value<int> dayCount;
  final Value<DateTime> lastStudiedDate;
  final Value<DateTime> startDate;
  final Value<int> rowid;
  const StudyStreaksCompanion({
    this.userId = const Value.absent(),
    this.dayCount = const Value.absent(),
    this.lastStudiedDate = const Value.absent(),
    this.startDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyStreaksCompanion.insert({
    required String userId,
    required int dayCount,
    required DateTime lastStudiedDate,
    required DateTime startDate,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       dayCount = Value(dayCount),
       lastStudiedDate = Value(lastStudiedDate),
       startDate = Value(startDate);
  static Insertable<StudyStreakRow> custom({
    Expression<String>? userId,
    Expression<int>? dayCount,
    Expression<DateTime>? lastStudiedDate,
    Expression<DateTime>? startDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (dayCount != null) 'day_count': dayCount,
      if (lastStudiedDate != null) 'last_studied_date': lastStudiedDate,
      if (startDate != null) 'start_date': startDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudyStreaksCompanion copyWith({
    Value<String>? userId,
    Value<int>? dayCount,
    Value<DateTime>? lastStudiedDate,
    Value<DateTime>? startDate,
    Value<int>? rowid,
  }) {
    return StudyStreaksCompanion(
      userId: userId ?? this.userId,
      dayCount: dayCount ?? this.dayCount,
      lastStudiedDate: lastStudiedDate ?? this.lastStudiedDate,
      startDate: startDate ?? this.startDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (dayCount.present) {
      map['day_count'] = Variable<int>(dayCount.value);
    }
    if (lastStudiedDate.present) {
      map['last_studied_date'] = Variable<DateTime>(lastStudiedDate.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyStreaksCompanion(')
          ..write('userId: $userId, ')
          ..write('dayCount: $dayCount, ')
          ..write('lastStudiedDate: $lastStudiedDate, ')
          ..write('startDate: $startDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyScoresTable extends DailyScores
    with TableInfo<$DailyScoresTable, DailyScoreRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyScoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicIdMeta = const VerificationMeta(
    'topicId',
  );
  @override
  late final GeneratedColumn<String> topicId = GeneratedColumn<String>(
    'topic_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES topics (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, userId, date, score, topicId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_scores';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyScoreRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('topic_id')) {
      context.handle(
        _topicIdMeta,
        topicId.isAcceptableOrUnknown(data['topic_id']!, _topicIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyScoreRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyScoreRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
      topicId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic_id'],
      ),
    );
  }

  @override
  $DailyScoresTable createAlias(String alias) {
    return $DailyScoresTable(attachedDatabase, alias);
  }
}

class DailyScoreRow extends DataClass implements Insertable<DailyScoreRow> {
  final int id;
  final String userId;
  final DateTime date;
  final int score;
  final String? topicId;
  const DailyScoreRow({
    required this.id,
    required this.userId,
    required this.date,
    required this.score,
    this.topicId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['date'] = Variable<DateTime>(date);
    map['score'] = Variable<int>(score);
    if (!nullToAbsent || topicId != null) {
      map['topic_id'] = Variable<String>(topicId);
    }
    return map;
  }

  DailyScoresCompanion toCompanion(bool nullToAbsent) {
    return DailyScoresCompanion(
      id: Value(id),
      userId: Value(userId),
      date: Value(date),
      score: Value(score),
      topicId: topicId == null && nullToAbsent
          ? const Value.absent()
          : Value(topicId),
    );
  }

  factory DailyScoreRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyScoreRow(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      date: serializer.fromJson<DateTime>(json['date']),
      score: serializer.fromJson<int>(json['score']),
      topicId: serializer.fromJson<String?>(json['topicId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'date': serializer.toJson<DateTime>(date),
      'score': serializer.toJson<int>(score),
      'topicId': serializer.toJson<String?>(topicId),
    };
  }

  DailyScoreRow copyWith({
    int? id,
    String? userId,
    DateTime? date,
    int? score,
    Value<String?> topicId = const Value.absent(),
  }) => DailyScoreRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    date: date ?? this.date,
    score: score ?? this.score,
    topicId: topicId.present ? topicId.value : this.topicId,
  );
  DailyScoreRow copyWithCompanion(DailyScoresCompanion data) {
    return DailyScoreRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      date: data.date.present ? data.date.value : this.date,
      score: data.score.present ? data.score.value : this.score,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyScoreRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('score: $score, ')
          ..write('topicId: $topicId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, date, score, topicId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyScoreRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.date == this.date &&
          other.score == this.score &&
          other.topicId == this.topicId);
}

class DailyScoresCompanion extends UpdateCompanion<DailyScoreRow> {
  final Value<int> id;
  final Value<String> userId;
  final Value<DateTime> date;
  final Value<int> score;
  final Value<String?> topicId;
  const DailyScoresCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.date = const Value.absent(),
    this.score = const Value.absent(),
    this.topicId = const Value.absent(),
  });
  DailyScoresCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required DateTime date,
    required int score,
    this.topicId = const Value.absent(),
  }) : userId = Value(userId),
       date = Value(date),
       score = Value(score);
  static Insertable<DailyScoreRow> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<DateTime>? date,
    Expression<int>? score,
    Expression<String>? topicId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (date != null) 'date': date,
      if (score != null) 'score': score,
      if (topicId != null) 'topic_id': topicId,
    });
  }

  DailyScoresCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<DateTime>? date,
    Value<int>? score,
    Value<String?>? topicId,
  }) {
    return DailyScoresCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      score: score ?? this.score,
      topicId: topicId ?? this.topicId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (topicId.present) {
      map['topic_id'] = Variable<String>(topicId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyScoresCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('score: $score, ')
          ..write('topicId: $topicId')
          ..write(')'))
        .toString();
  }
}

class $SessionMetricsTable extends SessionMetrics
    with TableInfo<$SessionMetricsTable, SessionMetricRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionMetricsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicIdsMeta = const VerificationMeta(
    'topicIds',
  );
  @override
  late final GeneratedColumn<String> topicIds = GeneratedColumn<String>(
    'topic_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    date,
    durationMinutes,
    topicIds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_metrics';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionMetricRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('topic_ids')) {
      context.handle(
        _topicIdsMeta,
        topicIds.isAcceptableOrUnknown(data['topic_ids']!, _topicIdsMeta),
      );
    } else if (isInserting) {
      context.missing(_topicIdsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionMetricRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionMetricRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      topicIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic_ids'],
      )!,
    );
  }

  @override
  $SessionMetricsTable createAlias(String alias) {
    return $SessionMetricsTable(attachedDatabase, alias);
  }
}

class SessionMetricRow extends DataClass
    implements Insertable<SessionMetricRow> {
  final int id;
  final String userId;
  final DateTime date;
  final int durationMinutes;
  final String topicIds;
  const SessionMetricRow({
    required this.id,
    required this.userId,
    required this.date,
    required this.durationMinutes,
    required this.topicIds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['date'] = Variable<DateTime>(date);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['topic_ids'] = Variable<String>(topicIds);
    return map;
  }

  SessionMetricsCompanion toCompanion(bool nullToAbsent) {
    return SessionMetricsCompanion(
      id: Value(id),
      userId: Value(userId),
      date: Value(date),
      durationMinutes: Value(durationMinutes),
      topicIds: Value(topicIds),
    );
  }

  factory SessionMetricRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionMetricRow(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      date: serializer.fromJson<DateTime>(json['date']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      topicIds: serializer.fromJson<String>(json['topicIds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'date': serializer.toJson<DateTime>(date),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'topicIds': serializer.toJson<String>(topicIds),
    };
  }

  SessionMetricRow copyWith({
    int? id,
    String? userId,
    DateTime? date,
    int? durationMinutes,
    String? topicIds,
  }) => SessionMetricRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    date: date ?? this.date,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    topicIds: topicIds ?? this.topicIds,
  );
  SessionMetricRow copyWithCompanion(SessionMetricsCompanion data) {
    return SessionMetricRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      date: data.date.present ? data.date.value : this.date,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      topicIds: data.topicIds.present ? data.topicIds.value : this.topicIds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionMetricRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('topicIds: $topicIds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, date, durationMinutes, topicIds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionMetricRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.date == this.date &&
          other.durationMinutes == this.durationMinutes &&
          other.topicIds == this.topicIds);
}

class SessionMetricsCompanion extends UpdateCompanion<SessionMetricRow> {
  final Value<int> id;
  final Value<String> userId;
  final Value<DateTime> date;
  final Value<int> durationMinutes;
  final Value<String> topicIds;
  const SessionMetricsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.date = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.topicIds = const Value.absent(),
  });
  SessionMetricsCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required DateTime date,
    required int durationMinutes,
    required String topicIds,
  }) : userId = Value(userId),
       date = Value(date),
       durationMinutes = Value(durationMinutes),
       topicIds = Value(topicIds);
  static Insertable<SessionMetricRow> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<DateTime>? date,
    Expression<int>? durationMinutes,
    Expression<String>? topicIds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (date != null) 'date': date,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (topicIds != null) 'topic_ids': topicIds,
    });
  }

  SessionMetricsCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<DateTime>? date,
    Value<int>? durationMinutes,
    Value<String>? topicIds,
  }) {
    return SessionMetricsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      topicIds: topicIds ?? this.topicIds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (topicIds.present) {
      map['topic_ids'] = Variable<String>(topicIds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionMetricsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('topicIds: $topicIds')
          ..write(')'))
        .toString();
  }
}

class $TutorConversationsTable extends TutorConversations
    with TableInfo<$TutorConversationsTable, TutorConversationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TutorConversationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subjects (id)',
    ),
  );
  static const VerificationMeta _topicIdMeta = const VerificationMeta(
    'topicId',
  );
  @override
  late final GeneratedColumn<String> topicId = GeneratedColumn<String>(
    'topic_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES topics (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _groundedSourceCountMeta =
      const VerificationMeta('groundedSourceCount');
  @override
  late final GeneratedColumn<int> groundedSourceCount = GeneratedColumn<int>(
    'grounded_source_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastMessageAtMeta = const VerificationMeta(
    'lastMessageAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastMessageAt =
      GeneratedColumn<DateTime>(
        'last_message_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    subjectId,
    topicId,
    title,
    groundedSourceCount,
    createdAt,
    lastMessageAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tutor_conversations';
  @override
  VerificationContext validateIntegrity(
    Insertable<TutorConversationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('topic_id')) {
      context.handle(
        _topicIdMeta,
        topicId.isAcceptableOrUnknown(data['topic_id']!, _topicIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('grounded_source_count')) {
      context.handle(
        _groundedSourceCountMeta,
        groundedSourceCount.isAcceptableOrUnknown(
          data['grounded_source_count']!,
          _groundedSourceCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_groundedSourceCountMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_message_at')) {
      context.handle(
        _lastMessageAtMeta,
        lastMessageAt.isAcceptableOrUnknown(
          data['last_message_at']!,
          _lastMessageAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastMessageAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TutorConversationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TutorConversationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_id'],
      )!,
      topicId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      groundedSourceCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grounded_source_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastMessageAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_message_at'],
      )!,
    );
  }

  @override
  $TutorConversationsTable createAlias(String alias) {
    return $TutorConversationsTable(attachedDatabase, alias);
  }
}

class TutorConversationRow extends DataClass
    implements Insertable<TutorConversationRow> {
  final String id;
  final String userId;
  final String subjectId;
  final String? topicId;
  final String? title;
  final int groundedSourceCount;
  final DateTime createdAt;
  final DateTime lastMessageAt;
  const TutorConversationRow({
    required this.id,
    required this.userId,
    required this.subjectId,
    this.topicId,
    this.title,
    required this.groundedSourceCount,
    required this.createdAt,
    required this.lastMessageAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['subject_id'] = Variable<String>(subjectId);
    if (!nullToAbsent || topicId != null) {
      map['topic_id'] = Variable<String>(topicId);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['grounded_source_count'] = Variable<int>(groundedSourceCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_message_at'] = Variable<DateTime>(lastMessageAt);
    return map;
  }

  TutorConversationsCompanion toCompanion(bool nullToAbsent) {
    return TutorConversationsCompanion(
      id: Value(id),
      userId: Value(userId),
      subjectId: Value(subjectId),
      topicId: topicId == null && nullToAbsent
          ? const Value.absent()
          : Value(topicId),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      groundedSourceCount: Value(groundedSourceCount),
      createdAt: Value(createdAt),
      lastMessageAt: Value(lastMessageAt),
    );
  }

  factory TutorConversationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TutorConversationRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      topicId: serializer.fromJson<String?>(json['topicId']),
      title: serializer.fromJson<String?>(json['title']),
      groundedSourceCount: serializer.fromJson<int>(
        json['groundedSourceCount'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastMessageAt: serializer.fromJson<DateTime>(json['lastMessageAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'subjectId': serializer.toJson<String>(subjectId),
      'topicId': serializer.toJson<String?>(topicId),
      'title': serializer.toJson<String?>(title),
      'groundedSourceCount': serializer.toJson<int>(groundedSourceCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastMessageAt': serializer.toJson<DateTime>(lastMessageAt),
    };
  }

  TutorConversationRow copyWith({
    String? id,
    String? userId,
    String? subjectId,
    Value<String?> topicId = const Value.absent(),
    Value<String?> title = const Value.absent(),
    int? groundedSourceCount,
    DateTime? createdAt,
    DateTime? lastMessageAt,
  }) => TutorConversationRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    subjectId: subjectId ?? this.subjectId,
    topicId: topicId.present ? topicId.value : this.topicId,
    title: title.present ? title.value : this.title,
    groundedSourceCount: groundedSourceCount ?? this.groundedSourceCount,
    createdAt: createdAt ?? this.createdAt,
    lastMessageAt: lastMessageAt ?? this.lastMessageAt,
  );
  TutorConversationRow copyWithCompanion(TutorConversationsCompanion data) {
    return TutorConversationRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
      title: data.title.present ? data.title.value : this.title,
      groundedSourceCount: data.groundedSourceCount.present
          ? data.groundedSourceCount.value
          : this.groundedSourceCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastMessageAt: data.lastMessageAt.present
          ? data.lastMessageAt.value
          : this.lastMessageAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TutorConversationRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('subjectId: $subjectId, ')
          ..write('topicId: $topicId, ')
          ..write('title: $title, ')
          ..write('groundedSourceCount: $groundedSourceCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastMessageAt: $lastMessageAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    subjectId,
    topicId,
    title,
    groundedSourceCount,
    createdAt,
    lastMessageAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TutorConversationRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.subjectId == this.subjectId &&
          other.topicId == this.topicId &&
          other.title == this.title &&
          other.groundedSourceCount == this.groundedSourceCount &&
          other.createdAt == this.createdAt &&
          other.lastMessageAt == this.lastMessageAt);
}

class TutorConversationsCompanion
    extends UpdateCompanion<TutorConversationRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> subjectId;
  final Value<String?> topicId;
  final Value<String?> title;
  final Value<int> groundedSourceCount;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastMessageAt;
  final Value<int> rowid;
  const TutorConversationsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.topicId = const Value.absent(),
    this.title = const Value.absent(),
    this.groundedSourceCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TutorConversationsCompanion.insert({
    required String id,
    required String userId,
    required String subjectId,
    this.topicId = const Value.absent(),
    this.title = const Value.absent(),
    required int groundedSourceCount,
    required DateTime createdAt,
    required DateTime lastMessageAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       subjectId = Value(subjectId),
       groundedSourceCount = Value(groundedSourceCount),
       createdAt = Value(createdAt),
       lastMessageAt = Value(lastMessageAt);
  static Insertable<TutorConversationRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? subjectId,
    Expression<String>? topicId,
    Expression<String>? title,
    Expression<int>? groundedSourceCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastMessageAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (subjectId != null) 'subject_id': subjectId,
      if (topicId != null) 'topic_id': topicId,
      if (title != null) 'title': title,
      if (groundedSourceCount != null)
        'grounded_source_count': groundedSourceCount,
      if (createdAt != null) 'created_at': createdAt,
      if (lastMessageAt != null) 'last_message_at': lastMessageAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TutorConversationsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? subjectId,
    Value<String?>? topicId,
    Value<String?>? title,
    Value<int>? groundedSourceCount,
    Value<DateTime>? createdAt,
    Value<DateTime>? lastMessageAt,
    Value<int>? rowid,
  }) {
    return TutorConversationsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      subjectId: subjectId ?? this.subjectId,
      topicId: topicId ?? this.topicId,
      title: title ?? this.title,
      groundedSourceCount: groundedSourceCount ?? this.groundedSourceCount,
      createdAt: createdAt ?? this.createdAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (topicId.present) {
      map['topic_id'] = Variable<String>(topicId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (groundedSourceCount.present) {
      map['grounded_source_count'] = Variable<int>(groundedSourceCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastMessageAt.present) {
      map['last_message_at'] = Variable<DateTime>(lastMessageAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TutorConversationsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('subjectId: $subjectId, ')
          ..write('topicId: $topicId, ')
          ..write('title: $title, ')
          ..write('groundedSourceCount: $groundedSourceCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastMessageAt: $lastMessageAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TutorMessagesTable extends TutorMessages
    with TableInfo<$TutorMessagesTable, TutorMessageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TutorMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tutor_conversations (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<MessageSender, String> sender =
      GeneratedColumn<String>(
        'sender',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MessageSender>($TutorMessagesTable.$convertersender);
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<FollowUpPoint>, String>
  followUpPoints =
      GeneratedColumn<String>(
        'follow_up_points',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<FollowUpPoint>>(
        $TutorMessagesTable.$converterfollowUpPoints,
      );
  @override
  late final GeneratedColumnWithTypeConverter<List<Citation>, String>
  citations = GeneratedColumn<String>(
    'citations',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<Citation>>($TutorMessagesTable.$convertercitations);
  static const VerificationMeta _kickerQuestionMeta = const VerificationMeta(
    'kickerQuestion',
  );
  @override
  late final GeneratedColumn<String> kickerQuestion = GeneratedColumn<String>(
    'kicker_question',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    conversationId,
    sender,
    content,
    timestamp,
    followUpPoints,
    citations,
    kickerQuestion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tutor_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<TutorMessageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('kicker_question')) {
      context.handle(
        _kickerQuestionMeta,
        kickerQuestion.isAcceptableOrUnknown(
          data['kicker_question']!,
          _kickerQuestionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TutorMessageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TutorMessageRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      sender: $TutorMessagesTable.$convertersender.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sender'],
        )!,
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      followUpPoints: $TutorMessagesTable.$converterfollowUpPoints.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}follow_up_points'],
        )!,
      ),
      citations: $TutorMessagesTable.$convertercitations.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}citations'],
        )!,
      ),
      kickerQuestion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kicker_question'],
      ),
    );
  }

  @override
  $TutorMessagesTable createAlias(String alias) {
    return $TutorMessagesTable(attachedDatabase, alias);
  }

  static TypeConverter<MessageSender, String> $convertersender =
      const EnumConverter<MessageSender>(MessageSender.values);
  static TypeConverter<List<FollowUpPoint>, String> $converterfollowUpPoints =
      const FollowUpPointsConverter();
  static TypeConverter<List<Citation>, String> $convertercitations =
      const CitationsConverter();
}

class TutorMessageRow extends DataClass implements Insertable<TutorMessageRow> {
  final String id;
  final String conversationId;
  final MessageSender sender;
  final String content;
  final DateTime timestamp;
  final List<FollowUpPoint> followUpPoints;
  final List<Citation> citations;
  final String? kickerQuestion;
  const TutorMessageRow({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.content,
    required this.timestamp,
    required this.followUpPoints,
    required this.citations,
    this.kickerQuestion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['conversation_id'] = Variable<String>(conversationId);
    {
      map['sender'] = Variable<String>(
        $TutorMessagesTable.$convertersender.toSql(sender),
      );
    }
    map['content'] = Variable<String>(content);
    map['timestamp'] = Variable<DateTime>(timestamp);
    {
      map['follow_up_points'] = Variable<String>(
        $TutorMessagesTable.$converterfollowUpPoints.toSql(followUpPoints),
      );
    }
    {
      map['citations'] = Variable<String>(
        $TutorMessagesTable.$convertercitations.toSql(citations),
      );
    }
    if (!nullToAbsent || kickerQuestion != null) {
      map['kicker_question'] = Variable<String>(kickerQuestion);
    }
    return map;
  }

  TutorMessagesCompanion toCompanion(bool nullToAbsent) {
    return TutorMessagesCompanion(
      id: Value(id),
      conversationId: Value(conversationId),
      sender: Value(sender),
      content: Value(content),
      timestamp: Value(timestamp),
      followUpPoints: Value(followUpPoints),
      citations: Value(citations),
      kickerQuestion: kickerQuestion == null && nullToAbsent
          ? const Value.absent()
          : Value(kickerQuestion),
    );
  }

  factory TutorMessageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TutorMessageRow(
      id: serializer.fromJson<String>(json['id']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      sender: serializer.fromJson<MessageSender>(json['sender']),
      content: serializer.fromJson<String>(json['content']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      followUpPoints: serializer.fromJson<List<FollowUpPoint>>(
        json['followUpPoints'],
      ),
      citations: serializer.fromJson<List<Citation>>(json['citations']),
      kickerQuestion: serializer.fromJson<String?>(json['kickerQuestion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'conversationId': serializer.toJson<String>(conversationId),
      'sender': serializer.toJson<MessageSender>(sender),
      'content': serializer.toJson<String>(content),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'followUpPoints': serializer.toJson<List<FollowUpPoint>>(followUpPoints),
      'citations': serializer.toJson<List<Citation>>(citations),
      'kickerQuestion': serializer.toJson<String?>(kickerQuestion),
    };
  }

  TutorMessageRow copyWith({
    String? id,
    String? conversationId,
    MessageSender? sender,
    String? content,
    DateTime? timestamp,
    List<FollowUpPoint>? followUpPoints,
    List<Citation>? citations,
    Value<String?> kickerQuestion = const Value.absent(),
  }) => TutorMessageRow(
    id: id ?? this.id,
    conversationId: conversationId ?? this.conversationId,
    sender: sender ?? this.sender,
    content: content ?? this.content,
    timestamp: timestamp ?? this.timestamp,
    followUpPoints: followUpPoints ?? this.followUpPoints,
    citations: citations ?? this.citations,
    kickerQuestion: kickerQuestion.present
        ? kickerQuestion.value
        : this.kickerQuestion,
  );
  TutorMessageRow copyWithCompanion(TutorMessagesCompanion data) {
    return TutorMessageRow(
      id: data.id.present ? data.id.value : this.id,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      sender: data.sender.present ? data.sender.value : this.sender,
      content: data.content.present ? data.content.value : this.content,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      followUpPoints: data.followUpPoints.present
          ? data.followUpPoints.value
          : this.followUpPoints,
      citations: data.citations.present ? data.citations.value : this.citations,
      kickerQuestion: data.kickerQuestion.present
          ? data.kickerQuestion.value
          : this.kickerQuestion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TutorMessageRow(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('sender: $sender, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp, ')
          ..write('followUpPoints: $followUpPoints, ')
          ..write('citations: $citations, ')
          ..write('kickerQuestion: $kickerQuestion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    conversationId,
    sender,
    content,
    timestamp,
    followUpPoints,
    citations,
    kickerQuestion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TutorMessageRow &&
          other.id == this.id &&
          other.conversationId == this.conversationId &&
          other.sender == this.sender &&
          other.content == this.content &&
          other.timestamp == this.timestamp &&
          other.followUpPoints == this.followUpPoints &&
          other.citations == this.citations &&
          other.kickerQuestion == this.kickerQuestion);
}

class TutorMessagesCompanion extends UpdateCompanion<TutorMessageRow> {
  final Value<String> id;
  final Value<String> conversationId;
  final Value<MessageSender> sender;
  final Value<String> content;
  final Value<DateTime> timestamp;
  final Value<List<FollowUpPoint>> followUpPoints;
  final Value<List<Citation>> citations;
  final Value<String?> kickerQuestion;
  final Value<int> rowid;
  const TutorMessagesCompanion({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.sender = const Value.absent(),
    this.content = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.followUpPoints = const Value.absent(),
    this.citations = const Value.absent(),
    this.kickerQuestion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TutorMessagesCompanion.insert({
    required String id,
    required String conversationId,
    required MessageSender sender,
    required String content,
    required DateTime timestamp,
    required List<FollowUpPoint> followUpPoints,
    required List<Citation> citations,
    this.kickerQuestion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       conversationId = Value(conversationId),
       sender = Value(sender),
       content = Value(content),
       timestamp = Value(timestamp),
       followUpPoints = Value(followUpPoints),
       citations = Value(citations);
  static Insertable<TutorMessageRow> custom({
    Expression<String>? id,
    Expression<String>? conversationId,
    Expression<String>? sender,
    Expression<String>? content,
    Expression<DateTime>? timestamp,
    Expression<String>? followUpPoints,
    Expression<String>? citations,
    Expression<String>? kickerQuestion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conversationId != null) 'conversation_id': conversationId,
      if (sender != null) 'sender': sender,
      if (content != null) 'content': content,
      if (timestamp != null) 'timestamp': timestamp,
      if (followUpPoints != null) 'follow_up_points': followUpPoints,
      if (citations != null) 'citations': citations,
      if (kickerQuestion != null) 'kicker_question': kickerQuestion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TutorMessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? conversationId,
    Value<MessageSender>? sender,
    Value<String>? content,
    Value<DateTime>? timestamp,
    Value<List<FollowUpPoint>>? followUpPoints,
    Value<List<Citation>>? citations,
    Value<String?>? kickerQuestion,
    Value<int>? rowid,
  }) {
    return TutorMessagesCompanion(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      sender: sender ?? this.sender,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      followUpPoints: followUpPoints ?? this.followUpPoints,
      citations: citations ?? this.citations,
      kickerQuestion: kickerQuestion ?? this.kickerQuestion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (sender.present) {
      map['sender'] = Variable<String>(
        $TutorMessagesTable.$convertersender.toSql(sender.value),
      );
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (followUpPoints.present) {
      map['follow_up_points'] = Variable<String>(
        $TutorMessagesTable.$converterfollowUpPoints.toSql(
          followUpPoints.value,
        ),
      );
    }
    if (citations.present) {
      map['citations'] = Variable<String>(
        $TutorMessagesTable.$convertercitations.toSql(citations.value),
      );
    }
    if (kickerQuestion.present) {
      map['kicker_question'] = Variable<String>(kickerQuestion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TutorMessagesCompanion(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('sender: $sender, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp, ')
          ..write('followUpPoints: $followUpPoints, ')
          ..write('citations: $citations, ')
          ..write('kickerQuestion: $kickerQuestion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TutorSettingsTableTable extends TutorSettingsTable
    with TableInfo<$TutorSettingsTableTable, TutorSettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TutorSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _showCitationsOnEveryReplyMeta =
      const VerificationMeta('showCitationsOnEveryReply');
  @override
  late final GeneratedColumn<bool> showCitationsOnEveryReply =
      GeneratedColumn<bool>(
        'show_citations_on_every_reply',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_citations_on_every_reply" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  @override
  late final GeneratedColumnWithTypeConverter<TutorScope, String> scope =
      GeneratedColumn<String>(
        'scope',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TutorScope>($TutorSettingsTableTable.$converterscope);
  @override
  late final GeneratedColumnWithTypeConverter<ReasoningDepth, String>
  reasoningDepth =
      GeneratedColumn<String>(
        'reasoning_depth',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ReasoningDepth>(
        $TutorSettingsTableTable.$converterreasoningDepth,
      );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    showCitationsOnEveryReply,
    scope,
    reasoningDepth,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tutor_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<TutorSettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('show_citations_on_every_reply')) {
      context.handle(
        _showCitationsOnEveryReplyMeta,
        showCitationsOnEveryReply.isAcceptableOrUnknown(
          data['show_citations_on_every_reply']!,
          _showCitationsOnEveryReplyMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  TutorSettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TutorSettingsRow(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      showCitationsOnEveryReply: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_citations_on_every_reply'],
      )!,
      scope: $TutorSettingsTableTable.$converterscope.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}scope'],
        )!,
      ),
      reasoningDepth: $TutorSettingsTableTable.$converterreasoningDepth.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}reasoning_depth'],
        )!,
      ),
    );
  }

  @override
  $TutorSettingsTableTable createAlias(String alias) {
    return $TutorSettingsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<TutorScope, String> $converterscope =
      const EnumConverter<TutorScope>(TutorScope.values);
  static TypeConverter<ReasoningDepth, String> $converterreasoningDepth =
      const EnumConverter<ReasoningDepth>(ReasoningDepth.values);
}

class TutorSettingsRow extends DataClass
    implements Insertable<TutorSettingsRow> {
  final String userId;
  final bool showCitationsOnEveryReply;
  final TutorScope scope;
  final ReasoningDepth reasoningDepth;
  const TutorSettingsRow({
    required this.userId,
    required this.showCitationsOnEveryReply,
    required this.scope,
    required this.reasoningDepth,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['show_citations_on_every_reply'] = Variable<bool>(
      showCitationsOnEveryReply,
    );
    {
      map['scope'] = Variable<String>(
        $TutorSettingsTableTable.$converterscope.toSql(scope),
      );
    }
    {
      map['reasoning_depth'] = Variable<String>(
        $TutorSettingsTableTable.$converterreasoningDepth.toSql(reasoningDepth),
      );
    }
    return map;
  }

  TutorSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return TutorSettingsTableCompanion(
      userId: Value(userId),
      showCitationsOnEveryReply: Value(showCitationsOnEveryReply),
      scope: Value(scope),
      reasoningDepth: Value(reasoningDepth),
    );
  }

  factory TutorSettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TutorSettingsRow(
      userId: serializer.fromJson<String>(json['userId']),
      showCitationsOnEveryReply: serializer.fromJson<bool>(
        json['showCitationsOnEveryReply'],
      ),
      scope: serializer.fromJson<TutorScope>(json['scope']),
      reasoningDepth: serializer.fromJson<ReasoningDepth>(
        json['reasoningDepth'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'showCitationsOnEveryReply': serializer.toJson<bool>(
        showCitationsOnEveryReply,
      ),
      'scope': serializer.toJson<TutorScope>(scope),
      'reasoningDepth': serializer.toJson<ReasoningDepth>(reasoningDepth),
    };
  }

  TutorSettingsRow copyWith({
    String? userId,
    bool? showCitationsOnEveryReply,
    TutorScope? scope,
    ReasoningDepth? reasoningDepth,
  }) => TutorSettingsRow(
    userId: userId ?? this.userId,
    showCitationsOnEveryReply:
        showCitationsOnEveryReply ?? this.showCitationsOnEveryReply,
    scope: scope ?? this.scope,
    reasoningDepth: reasoningDepth ?? this.reasoningDepth,
  );
  TutorSettingsRow copyWithCompanion(TutorSettingsTableCompanion data) {
    return TutorSettingsRow(
      userId: data.userId.present ? data.userId.value : this.userId,
      showCitationsOnEveryReply: data.showCitationsOnEveryReply.present
          ? data.showCitationsOnEveryReply.value
          : this.showCitationsOnEveryReply,
      scope: data.scope.present ? data.scope.value : this.scope,
      reasoningDepth: data.reasoningDepth.present
          ? data.reasoningDepth.value
          : this.reasoningDepth,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TutorSettingsRow(')
          ..write('userId: $userId, ')
          ..write('showCitationsOnEveryReply: $showCitationsOnEveryReply, ')
          ..write('scope: $scope, ')
          ..write('reasoningDepth: $reasoningDepth')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(userId, showCitationsOnEveryReply, scope, reasoningDepth);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TutorSettingsRow &&
          other.userId == this.userId &&
          other.showCitationsOnEveryReply == this.showCitationsOnEveryReply &&
          other.scope == this.scope &&
          other.reasoningDepth == this.reasoningDepth);
}

class TutorSettingsTableCompanion extends UpdateCompanion<TutorSettingsRow> {
  final Value<String> userId;
  final Value<bool> showCitationsOnEveryReply;
  final Value<TutorScope> scope;
  final Value<ReasoningDepth> reasoningDepth;
  final Value<int> rowid;
  const TutorSettingsTableCompanion({
    this.userId = const Value.absent(),
    this.showCitationsOnEveryReply = const Value.absent(),
    this.scope = const Value.absent(),
    this.reasoningDepth = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TutorSettingsTableCompanion.insert({
    required String userId,
    this.showCitationsOnEveryReply = const Value.absent(),
    required TutorScope scope,
    required ReasoningDepth reasoningDepth,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       scope = Value(scope),
       reasoningDepth = Value(reasoningDepth);
  static Insertable<TutorSettingsRow> custom({
    Expression<String>? userId,
    Expression<bool>? showCitationsOnEveryReply,
    Expression<String>? scope,
    Expression<String>? reasoningDepth,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (showCitationsOnEveryReply != null)
        'show_citations_on_every_reply': showCitationsOnEveryReply,
      if (scope != null) 'scope': scope,
      if (reasoningDepth != null) 'reasoning_depth': reasoningDepth,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TutorSettingsTableCompanion copyWith({
    Value<String>? userId,
    Value<bool>? showCitationsOnEveryReply,
    Value<TutorScope>? scope,
    Value<ReasoningDepth>? reasoningDepth,
    Value<int>? rowid,
  }) {
    return TutorSettingsTableCompanion(
      userId: userId ?? this.userId,
      showCitationsOnEveryReply:
          showCitationsOnEveryReply ?? this.showCitationsOnEveryReply,
      scope: scope ?? this.scope,
      reasoningDepth: reasoningDepth ?? this.reasoningDepth,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (showCitationsOnEveryReply.present) {
      map['show_citations_on_every_reply'] = Variable<bool>(
        showCitationsOnEveryReply.value,
      );
    }
    if (scope.present) {
      map['scope'] = Variable<String>(
        $TutorSettingsTableTable.$converterscope.toSql(scope.value),
      );
    }
    if (reasoningDepth.present) {
      map['reasoning_depth'] = Variable<String>(
        $TutorSettingsTableTable.$converterreasoningDepth.toSql(
          reasoningDepth.value,
        ),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TutorSettingsTableCompanion(')
          ..write('userId: $userId, ')
          ..write('showCitationsOnEveryReply: $showCitationsOnEveryReply, ')
          ..write('scope: $scope, ')
          ..write('reasoningDepth: $reasoningDepth, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationSettingsTableTable extends NotificationSettingsTable
    with TableInfo<$NotificationSettingsTableTable, NotificationSettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _blockRemindersMeta = const VerificationMeta(
    'blockReminders',
  );
  @override
  late final GeneratedColumn<bool> blockReminders = GeneratedColumn<bool>(
    'block_reminders',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("block_reminders" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _dailyCheckInMeta = const VerificationMeta(
    'dailyCheckIn',
  );
  @override
  late final GeneratedColumn<bool> dailyCheckIn = GeneratedColumn<bool>(
    'daily_check_in',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("daily_check_in" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _examCountdownMeta = const VerificationMeta(
    'examCountdown',
  );
  @override
  late final GeneratedColumn<bool> examCountdown = GeneratedColumn<bool>(
    'exam_countdown',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("exam_countdown" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    blockReminders,
    dailyCheckIn,
    examCountdown,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationSettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('block_reminders')) {
      context.handle(
        _blockRemindersMeta,
        blockReminders.isAcceptableOrUnknown(
          data['block_reminders']!,
          _blockRemindersMeta,
        ),
      );
    }
    if (data.containsKey('daily_check_in')) {
      context.handle(
        _dailyCheckInMeta,
        dailyCheckIn.isAcceptableOrUnknown(
          data['daily_check_in']!,
          _dailyCheckInMeta,
        ),
      );
    }
    if (data.containsKey('exam_countdown')) {
      context.handle(
        _examCountdownMeta,
        examCountdown.isAcceptableOrUnknown(
          data['exam_countdown']!,
          _examCountdownMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  NotificationSettingsRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationSettingsRow(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      blockReminders: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}block_reminders'],
      )!,
      dailyCheckIn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}daily_check_in'],
      )!,
      examCountdown: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}exam_countdown'],
      )!,
    );
  }

  @override
  $NotificationSettingsTableTable createAlias(String alias) {
    return $NotificationSettingsTableTable(attachedDatabase, alias);
  }
}

class NotificationSettingsRow extends DataClass
    implements Insertable<NotificationSettingsRow> {
  final String userId;
  final bool blockReminders;
  final bool dailyCheckIn;
  final bool examCountdown;
  const NotificationSettingsRow({
    required this.userId,
    required this.blockReminders,
    required this.dailyCheckIn,
    required this.examCountdown,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['block_reminders'] = Variable<bool>(blockReminders);
    map['daily_check_in'] = Variable<bool>(dailyCheckIn);
    map['exam_countdown'] = Variable<bool>(examCountdown);
    return map;
  }

  NotificationSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return NotificationSettingsTableCompanion(
      userId: Value(userId),
      blockReminders: Value(blockReminders),
      dailyCheckIn: Value(dailyCheckIn),
      examCountdown: Value(examCountdown),
    );
  }

  factory NotificationSettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationSettingsRow(
      userId: serializer.fromJson<String>(json['userId']),
      blockReminders: serializer.fromJson<bool>(json['blockReminders']),
      dailyCheckIn: serializer.fromJson<bool>(json['dailyCheckIn']),
      examCountdown: serializer.fromJson<bool>(json['examCountdown']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'blockReminders': serializer.toJson<bool>(blockReminders),
      'dailyCheckIn': serializer.toJson<bool>(dailyCheckIn),
      'examCountdown': serializer.toJson<bool>(examCountdown),
    };
  }

  NotificationSettingsRow copyWith({
    String? userId,
    bool? blockReminders,
    bool? dailyCheckIn,
    bool? examCountdown,
  }) => NotificationSettingsRow(
    userId: userId ?? this.userId,
    blockReminders: blockReminders ?? this.blockReminders,
    dailyCheckIn: dailyCheckIn ?? this.dailyCheckIn,
    examCountdown: examCountdown ?? this.examCountdown,
  );
  NotificationSettingsRow copyWithCompanion(
    NotificationSettingsTableCompanion data,
  ) {
    return NotificationSettingsRow(
      userId: data.userId.present ? data.userId.value : this.userId,
      blockReminders: data.blockReminders.present
          ? data.blockReminders.value
          : this.blockReminders,
      dailyCheckIn: data.dailyCheckIn.present
          ? data.dailyCheckIn.value
          : this.dailyCheckIn,
      examCountdown: data.examCountdown.present
          ? data.examCountdown.value
          : this.examCountdown,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationSettingsRow(')
          ..write('userId: $userId, ')
          ..write('blockReminders: $blockReminders, ')
          ..write('dailyCheckIn: $dailyCheckIn, ')
          ..write('examCountdown: $examCountdown')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(userId, blockReminders, dailyCheckIn, examCountdown);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationSettingsRow &&
          other.userId == this.userId &&
          other.blockReminders == this.blockReminders &&
          other.dailyCheckIn == this.dailyCheckIn &&
          other.examCountdown == this.examCountdown);
}

class NotificationSettingsTableCompanion
    extends UpdateCompanion<NotificationSettingsRow> {
  final Value<String> userId;
  final Value<bool> blockReminders;
  final Value<bool> dailyCheckIn;
  final Value<bool> examCountdown;
  final Value<int> rowid;
  const NotificationSettingsTableCompanion({
    this.userId = const Value.absent(),
    this.blockReminders = const Value.absent(),
    this.dailyCheckIn = const Value.absent(),
    this.examCountdown = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationSettingsTableCompanion.insert({
    required String userId,
    this.blockReminders = const Value.absent(),
    this.dailyCheckIn = const Value.absent(),
    this.examCountdown = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId);
  static Insertable<NotificationSettingsRow> custom({
    Expression<String>? userId,
    Expression<bool>? blockReminders,
    Expression<bool>? dailyCheckIn,
    Expression<bool>? examCountdown,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (blockReminders != null) 'block_reminders': blockReminders,
      if (dailyCheckIn != null) 'daily_check_in': dailyCheckIn,
      if (examCountdown != null) 'exam_countdown': examCountdown,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationSettingsTableCompanion copyWith({
    Value<String>? userId,
    Value<bool>? blockReminders,
    Value<bool>? dailyCheckIn,
    Value<bool>? examCountdown,
    Value<int>? rowid,
  }) {
    return NotificationSettingsTableCompanion(
      userId: userId ?? this.userId,
      blockReminders: blockReminders ?? this.blockReminders,
      dailyCheckIn: dailyCheckIn ?? this.dailyCheckIn,
      examCountdown: examCountdown ?? this.examCountdown,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (blockReminders.present) {
      map['block_reminders'] = Variable<bool>(blockReminders.value);
    }
    if (dailyCheckIn.present) {
      map['daily_check_in'] = Variable<bool>(dailyCheckIn.value);
    }
    if (examCountdown.present) {
      map['exam_countdown'] = Variable<bool>(examCountdown.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationSettingsTableCompanion(')
          ..write('userId: $userId, ')
          ..write('blockReminders: $blockReminders, ')
          ..write('dailyCheckIn: $dailyCheckIn, ')
          ..write('examCountdown: $examCountdown, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppearancePrefsTableTable extends AppearancePrefsTable
    with TableInfo<$AppearancePrefsTableTable, AppearancePreferencesRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppearancePrefsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ThemeSetting, String> theme =
      GeneratedColumn<String>(
        'theme',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ThemeSetting>($AppearancePrefsTableTable.$convertertheme);
  static const VerificationMeta _showDuaCardMeta = const VerificationMeta(
    'showDuaCard',
  );
  @override
  late final GeneratedColumn<bool> showDuaCard = GeneratedColumn<bool>(
    'show_dua_card',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_dua_card" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _showHijriDateMeta = const VerificationMeta(
    'showHijriDate',
  );
  @override
  late final GeneratedColumn<bool> showHijriDate = GeneratedColumn<bool>(
    'show_hijri_date',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_hijri_date" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _dailyDuaTextMeta = const VerificationMeta(
    'dailyDuaText',
  );
  @override
  late final GeneratedColumn<String> dailyDuaText = GeneratedColumn<String>(
    'daily_dua_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    theme,
    showDuaCard,
    showHijriDate,
    dailyDuaText,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'appearance_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppearancePreferencesRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('show_dua_card')) {
      context.handle(
        _showDuaCardMeta,
        showDuaCard.isAcceptableOrUnknown(
          data['show_dua_card']!,
          _showDuaCardMeta,
        ),
      );
    }
    if (data.containsKey('show_hijri_date')) {
      context.handle(
        _showHijriDateMeta,
        showHijriDate.isAcceptableOrUnknown(
          data['show_hijri_date']!,
          _showHijriDateMeta,
        ),
      );
    }
    if (data.containsKey('daily_dua_text')) {
      context.handle(
        _dailyDuaTextMeta,
        dailyDuaText.isAcceptableOrUnknown(
          data['daily_dua_text']!,
          _dailyDuaTextMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  AppearancePreferencesRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppearancePreferencesRow(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      theme: $AppearancePrefsTableTable.$convertertheme.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}theme'],
        )!,
      ),
      showDuaCard: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_dua_card'],
      )!,
      showHijriDate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_hijri_date'],
      )!,
      dailyDuaText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}daily_dua_text'],
      ),
    );
  }

  @override
  $AppearancePrefsTableTable createAlias(String alias) {
    return $AppearancePrefsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<ThemeSetting, String> $convertertheme =
      const EnumConverter<ThemeSetting>(ThemeSetting.values);
}

class AppearancePreferencesRow extends DataClass
    implements Insertable<AppearancePreferencesRow> {
  final String userId;
  final ThemeSetting theme;
  final bool showDuaCard;
  final bool showHijriDate;
  final String? dailyDuaText;
  const AppearancePreferencesRow({
    required this.userId,
    required this.theme,
    required this.showDuaCard,
    required this.showHijriDate,
    this.dailyDuaText,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    {
      map['theme'] = Variable<String>(
        $AppearancePrefsTableTable.$convertertheme.toSql(theme),
      );
    }
    map['show_dua_card'] = Variable<bool>(showDuaCard);
    map['show_hijri_date'] = Variable<bool>(showHijriDate);
    if (!nullToAbsent || dailyDuaText != null) {
      map['daily_dua_text'] = Variable<String>(dailyDuaText);
    }
    return map;
  }

  AppearancePrefsTableCompanion toCompanion(bool nullToAbsent) {
    return AppearancePrefsTableCompanion(
      userId: Value(userId),
      theme: Value(theme),
      showDuaCard: Value(showDuaCard),
      showHijriDate: Value(showHijriDate),
      dailyDuaText: dailyDuaText == null && nullToAbsent
          ? const Value.absent()
          : Value(dailyDuaText),
    );
  }

  factory AppearancePreferencesRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppearancePreferencesRow(
      userId: serializer.fromJson<String>(json['userId']),
      theme: serializer.fromJson<ThemeSetting>(json['theme']),
      showDuaCard: serializer.fromJson<bool>(json['showDuaCard']),
      showHijriDate: serializer.fromJson<bool>(json['showHijriDate']),
      dailyDuaText: serializer.fromJson<String?>(json['dailyDuaText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'theme': serializer.toJson<ThemeSetting>(theme),
      'showDuaCard': serializer.toJson<bool>(showDuaCard),
      'showHijriDate': serializer.toJson<bool>(showHijriDate),
      'dailyDuaText': serializer.toJson<String?>(dailyDuaText),
    };
  }

  AppearancePreferencesRow copyWith({
    String? userId,
    ThemeSetting? theme,
    bool? showDuaCard,
    bool? showHijriDate,
    Value<String?> dailyDuaText = const Value.absent(),
  }) => AppearancePreferencesRow(
    userId: userId ?? this.userId,
    theme: theme ?? this.theme,
    showDuaCard: showDuaCard ?? this.showDuaCard,
    showHijriDate: showHijriDate ?? this.showHijriDate,
    dailyDuaText: dailyDuaText.present ? dailyDuaText.value : this.dailyDuaText,
  );
  AppearancePreferencesRow copyWithCompanion(
    AppearancePrefsTableCompanion data,
  ) {
    return AppearancePreferencesRow(
      userId: data.userId.present ? data.userId.value : this.userId,
      theme: data.theme.present ? data.theme.value : this.theme,
      showDuaCard: data.showDuaCard.present
          ? data.showDuaCard.value
          : this.showDuaCard,
      showHijriDate: data.showHijriDate.present
          ? data.showHijriDate.value
          : this.showHijriDate,
      dailyDuaText: data.dailyDuaText.present
          ? data.dailyDuaText.value
          : this.dailyDuaText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppearancePreferencesRow(')
          ..write('userId: $userId, ')
          ..write('theme: $theme, ')
          ..write('showDuaCard: $showDuaCard, ')
          ..write('showHijriDate: $showHijriDate, ')
          ..write('dailyDuaText: $dailyDuaText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(userId, theme, showDuaCard, showHijriDate, dailyDuaText);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppearancePreferencesRow &&
          other.userId == this.userId &&
          other.theme == this.theme &&
          other.showDuaCard == this.showDuaCard &&
          other.showHijriDate == this.showHijriDate &&
          other.dailyDuaText == this.dailyDuaText);
}

class AppearancePrefsTableCompanion
    extends UpdateCompanion<AppearancePreferencesRow> {
  final Value<String> userId;
  final Value<ThemeSetting> theme;
  final Value<bool> showDuaCard;
  final Value<bool> showHijriDate;
  final Value<String?> dailyDuaText;
  final Value<int> rowid;
  const AppearancePrefsTableCompanion({
    this.userId = const Value.absent(),
    this.theme = const Value.absent(),
    this.showDuaCard = const Value.absent(),
    this.showHijriDate = const Value.absent(),
    this.dailyDuaText = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppearancePrefsTableCompanion.insert({
    required String userId,
    required ThemeSetting theme,
    this.showDuaCard = const Value.absent(),
    this.showHijriDate = const Value.absent(),
    this.dailyDuaText = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       theme = Value(theme);
  static Insertable<AppearancePreferencesRow> custom({
    Expression<String>? userId,
    Expression<String>? theme,
    Expression<bool>? showDuaCard,
    Expression<bool>? showHijriDate,
    Expression<String>? dailyDuaText,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (theme != null) 'theme': theme,
      if (showDuaCard != null) 'show_dua_card': showDuaCard,
      if (showHijriDate != null) 'show_hijri_date': showHijriDate,
      if (dailyDuaText != null) 'daily_dua_text': dailyDuaText,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppearancePrefsTableCompanion copyWith({
    Value<String>? userId,
    Value<ThemeSetting>? theme,
    Value<bool>? showDuaCard,
    Value<bool>? showHijriDate,
    Value<String?>? dailyDuaText,
    Value<int>? rowid,
  }) {
    return AppearancePrefsTableCompanion(
      userId: userId ?? this.userId,
      theme: theme ?? this.theme,
      showDuaCard: showDuaCard ?? this.showDuaCard,
      showHijriDate: showHijriDate ?? this.showHijriDate,
      dailyDuaText: dailyDuaText ?? this.dailyDuaText,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (theme.present) {
      map['theme'] = Variable<String>(
        $AppearancePrefsTableTable.$convertertheme.toSql(theme.value),
      );
    }
    if (showDuaCard.present) {
      map['show_dua_card'] = Variable<bool>(showDuaCard.value);
    }
    if (showHijriDate.present) {
      map['show_hijri_date'] = Variable<bool>(showHijriDate.value);
    }
    if (dailyDuaText.present) {
      map['daily_dua_text'] = Variable<String>(dailyDuaText.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppearancePrefsTableCompanion(')
          ..write('userId: $userId, ')
          ..write('theme: $theme, ')
          ..write('showDuaCard: $showDuaCard, ')
          ..write('showHijriDate: $showHijriDate, ')
          ..write('dailyDuaText: $dailyDuaText, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LanguagePrefsTableTable extends LanguagePrefsTable
    with TableInfo<$LanguagePrefsTableTable, LanguagePreferencesRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LanguagePrefsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AppLanguage, String> appLanguage =
      GeneratedColumn<String>(
        'app_language',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AppLanguage>(
        $LanguagePrefsTableTable.$converterappLanguage,
      );
  static const VerificationMeta _useUrduNastaliqMeta = const VerificationMeta(
    'useUrduNastaliq',
  );
  @override
  late final GeneratedColumn<bool> useUrduNastaliq = GeneratedColumn<bool>(
    'use_urdu_nastaliq',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("use_urdu_nastaliq" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [userId, appLanguage, useUrduNastaliq];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'language_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<LanguagePreferencesRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('use_urdu_nastaliq')) {
      context.handle(
        _useUrduNastaliqMeta,
        useUrduNastaliq.isAcceptableOrUnknown(
          data['use_urdu_nastaliq']!,
          _useUrduNastaliqMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  LanguagePreferencesRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LanguagePreferencesRow(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      appLanguage: $LanguagePrefsTableTable.$converterappLanguage.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}app_language'],
        )!,
      ),
      useUrduNastaliq: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}use_urdu_nastaliq'],
      )!,
    );
  }

  @override
  $LanguagePrefsTableTable createAlias(String alias) {
    return $LanguagePrefsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<AppLanguage, String> $converterappLanguage =
      const EnumConverter<AppLanguage>(AppLanguage.values);
}

class LanguagePreferencesRow extends DataClass
    implements Insertable<LanguagePreferencesRow> {
  final String userId;
  final AppLanguage appLanguage;
  final bool useUrduNastaliq;
  const LanguagePreferencesRow({
    required this.userId,
    required this.appLanguage,
    required this.useUrduNastaliq,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    {
      map['app_language'] = Variable<String>(
        $LanguagePrefsTableTable.$converterappLanguage.toSql(appLanguage),
      );
    }
    map['use_urdu_nastaliq'] = Variable<bool>(useUrduNastaliq);
    return map;
  }

  LanguagePrefsTableCompanion toCompanion(bool nullToAbsent) {
    return LanguagePrefsTableCompanion(
      userId: Value(userId),
      appLanguage: Value(appLanguage),
      useUrduNastaliq: Value(useUrduNastaliq),
    );
  }

  factory LanguagePreferencesRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LanguagePreferencesRow(
      userId: serializer.fromJson<String>(json['userId']),
      appLanguage: serializer.fromJson<AppLanguage>(json['appLanguage']),
      useUrduNastaliq: serializer.fromJson<bool>(json['useUrduNastaliq']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'appLanguage': serializer.toJson<AppLanguage>(appLanguage),
      'useUrduNastaliq': serializer.toJson<bool>(useUrduNastaliq),
    };
  }

  LanguagePreferencesRow copyWith({
    String? userId,
    AppLanguage? appLanguage,
    bool? useUrduNastaliq,
  }) => LanguagePreferencesRow(
    userId: userId ?? this.userId,
    appLanguage: appLanguage ?? this.appLanguage,
    useUrduNastaliq: useUrduNastaliq ?? this.useUrduNastaliq,
  );
  LanguagePreferencesRow copyWithCompanion(LanguagePrefsTableCompanion data) {
    return LanguagePreferencesRow(
      userId: data.userId.present ? data.userId.value : this.userId,
      appLanguage: data.appLanguage.present
          ? data.appLanguage.value
          : this.appLanguage,
      useUrduNastaliq: data.useUrduNastaliq.present
          ? data.useUrduNastaliq.value
          : this.useUrduNastaliq,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LanguagePreferencesRow(')
          ..write('userId: $userId, ')
          ..write('appLanguage: $appLanguage, ')
          ..write('useUrduNastaliq: $useUrduNastaliq')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, appLanguage, useUrduNastaliq);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LanguagePreferencesRow &&
          other.userId == this.userId &&
          other.appLanguage == this.appLanguage &&
          other.useUrduNastaliq == this.useUrduNastaliq);
}

class LanguagePrefsTableCompanion
    extends UpdateCompanion<LanguagePreferencesRow> {
  final Value<String> userId;
  final Value<AppLanguage> appLanguage;
  final Value<bool> useUrduNastaliq;
  final Value<int> rowid;
  const LanguagePrefsTableCompanion({
    this.userId = const Value.absent(),
    this.appLanguage = const Value.absent(),
    this.useUrduNastaliq = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LanguagePrefsTableCompanion.insert({
    required String userId,
    required AppLanguage appLanguage,
    this.useUrduNastaliq = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       appLanguage = Value(appLanguage);
  static Insertable<LanguagePreferencesRow> custom({
    Expression<String>? userId,
    Expression<String>? appLanguage,
    Expression<bool>? useUrduNastaliq,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (appLanguage != null) 'app_language': appLanguage,
      if (useUrduNastaliq != null) 'use_urdu_nastaliq': useUrduNastaliq,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LanguagePrefsTableCompanion copyWith({
    Value<String>? userId,
    Value<AppLanguage>? appLanguage,
    Value<bool>? useUrduNastaliq,
    Value<int>? rowid,
  }) {
    return LanguagePrefsTableCompanion(
      userId: userId ?? this.userId,
      appLanguage: appLanguage ?? this.appLanguage,
      useUrduNastaliq: useUrduNastaliq ?? this.useUrduNastaliq,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (appLanguage.present) {
      map['app_language'] = Variable<String>(
        $LanguagePrefsTableTable.$converterappLanguage.toSql(appLanguage.value),
      );
    }
    if (useUrduNastaliq.present) {
      map['use_urdu_nastaliq'] = Variable<bool>(useUrduNastaliq.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LanguagePrefsTableCompanion(')
          ..write('userId: $userId, ')
          ..write('appLanguage: $appLanguage, ')
          ..write('useUrduNastaliq: $useUrduNastaliq, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PrivacySettingsTableTable extends PrivacySettingsTable
    with TableInfo<$PrivacySettingsTableTable, PrivacySettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrivacySettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _onDeviceProcessingMeta =
      const VerificationMeta('onDeviceProcessing');
  @override
  late final GeneratedColumn<bool> onDeviceProcessing = GeneratedColumn<bool>(
    'on_device_processing',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("on_device_processing" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _cloudBackupEnabledMeta =
      const VerificationMeta('cloudBackupEnabled');
  @override
  late final GeneratedColumn<bool> cloudBackupEnabled = GeneratedColumn<bool>(
    'cloud_backup_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("cloud_backup_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _cloudBackupLastSyncMeta =
      const VerificationMeta('cloudBackupLastSync');
  @override
  late final GeneratedColumn<DateTime> cloudBackupLastSync =
      GeneratedColumn<DateTime>(
        'cloud_backup_last_sync',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    onDeviceProcessing,
    cloudBackupEnabled,
    cloudBackupLastSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'privacy_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<PrivacySettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('on_device_processing')) {
      context.handle(
        _onDeviceProcessingMeta,
        onDeviceProcessing.isAcceptableOrUnknown(
          data['on_device_processing']!,
          _onDeviceProcessingMeta,
        ),
      );
    }
    if (data.containsKey('cloud_backup_enabled')) {
      context.handle(
        _cloudBackupEnabledMeta,
        cloudBackupEnabled.isAcceptableOrUnknown(
          data['cloud_backup_enabled']!,
          _cloudBackupEnabledMeta,
        ),
      );
    }
    if (data.containsKey('cloud_backup_last_sync')) {
      context.handle(
        _cloudBackupLastSyncMeta,
        cloudBackupLastSync.isAcceptableOrUnknown(
          data['cloud_backup_last_sync']!,
          _cloudBackupLastSyncMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  PrivacySettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrivacySettingsRow(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      onDeviceProcessing: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}on_device_processing'],
      )!,
      cloudBackupEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}cloud_backup_enabled'],
      )!,
      cloudBackupLastSync: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cloud_backup_last_sync'],
      ),
    );
  }

  @override
  $PrivacySettingsTableTable createAlias(String alias) {
    return $PrivacySettingsTableTable(attachedDatabase, alias);
  }
}

class PrivacySettingsRow extends DataClass
    implements Insertable<PrivacySettingsRow> {
  final String userId;
  final bool onDeviceProcessing;
  final bool cloudBackupEnabled;
  final DateTime? cloudBackupLastSync;
  const PrivacySettingsRow({
    required this.userId,
    required this.onDeviceProcessing,
    required this.cloudBackupEnabled,
    this.cloudBackupLastSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['on_device_processing'] = Variable<bool>(onDeviceProcessing);
    map['cloud_backup_enabled'] = Variable<bool>(cloudBackupEnabled);
    if (!nullToAbsent || cloudBackupLastSync != null) {
      map['cloud_backup_last_sync'] = Variable<DateTime>(cloudBackupLastSync);
    }
    return map;
  }

  PrivacySettingsTableCompanion toCompanion(bool nullToAbsent) {
    return PrivacySettingsTableCompanion(
      userId: Value(userId),
      onDeviceProcessing: Value(onDeviceProcessing),
      cloudBackupEnabled: Value(cloudBackupEnabled),
      cloudBackupLastSync: cloudBackupLastSync == null && nullToAbsent
          ? const Value.absent()
          : Value(cloudBackupLastSync),
    );
  }

  factory PrivacySettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrivacySettingsRow(
      userId: serializer.fromJson<String>(json['userId']),
      onDeviceProcessing: serializer.fromJson<bool>(json['onDeviceProcessing']),
      cloudBackupEnabled: serializer.fromJson<bool>(json['cloudBackupEnabled']),
      cloudBackupLastSync: serializer.fromJson<DateTime?>(
        json['cloudBackupLastSync'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'onDeviceProcessing': serializer.toJson<bool>(onDeviceProcessing),
      'cloudBackupEnabled': serializer.toJson<bool>(cloudBackupEnabled),
      'cloudBackupLastSync': serializer.toJson<DateTime?>(cloudBackupLastSync),
    };
  }

  PrivacySettingsRow copyWith({
    String? userId,
    bool? onDeviceProcessing,
    bool? cloudBackupEnabled,
    Value<DateTime?> cloudBackupLastSync = const Value.absent(),
  }) => PrivacySettingsRow(
    userId: userId ?? this.userId,
    onDeviceProcessing: onDeviceProcessing ?? this.onDeviceProcessing,
    cloudBackupEnabled: cloudBackupEnabled ?? this.cloudBackupEnabled,
    cloudBackupLastSync: cloudBackupLastSync.present
        ? cloudBackupLastSync.value
        : this.cloudBackupLastSync,
  );
  PrivacySettingsRow copyWithCompanion(PrivacySettingsTableCompanion data) {
    return PrivacySettingsRow(
      userId: data.userId.present ? data.userId.value : this.userId,
      onDeviceProcessing: data.onDeviceProcessing.present
          ? data.onDeviceProcessing.value
          : this.onDeviceProcessing,
      cloudBackupEnabled: data.cloudBackupEnabled.present
          ? data.cloudBackupEnabled.value
          : this.cloudBackupEnabled,
      cloudBackupLastSync: data.cloudBackupLastSync.present
          ? data.cloudBackupLastSync.value
          : this.cloudBackupLastSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrivacySettingsRow(')
          ..write('userId: $userId, ')
          ..write('onDeviceProcessing: $onDeviceProcessing, ')
          ..write('cloudBackupEnabled: $cloudBackupEnabled, ')
          ..write('cloudBackupLastSync: $cloudBackupLastSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    onDeviceProcessing,
    cloudBackupEnabled,
    cloudBackupLastSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrivacySettingsRow &&
          other.userId == this.userId &&
          other.onDeviceProcessing == this.onDeviceProcessing &&
          other.cloudBackupEnabled == this.cloudBackupEnabled &&
          other.cloudBackupLastSync == this.cloudBackupLastSync);
}

class PrivacySettingsTableCompanion
    extends UpdateCompanion<PrivacySettingsRow> {
  final Value<String> userId;
  final Value<bool> onDeviceProcessing;
  final Value<bool> cloudBackupEnabled;
  final Value<DateTime?> cloudBackupLastSync;
  final Value<int> rowid;
  const PrivacySettingsTableCompanion({
    this.userId = const Value.absent(),
    this.onDeviceProcessing = const Value.absent(),
    this.cloudBackupEnabled = const Value.absent(),
    this.cloudBackupLastSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PrivacySettingsTableCompanion.insert({
    required String userId,
    this.onDeviceProcessing = const Value.absent(),
    this.cloudBackupEnabled = const Value.absent(),
    this.cloudBackupLastSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId);
  static Insertable<PrivacySettingsRow> custom({
    Expression<String>? userId,
    Expression<bool>? onDeviceProcessing,
    Expression<bool>? cloudBackupEnabled,
    Expression<DateTime>? cloudBackupLastSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (onDeviceProcessing != null)
        'on_device_processing': onDeviceProcessing,
      if (cloudBackupEnabled != null)
        'cloud_backup_enabled': cloudBackupEnabled,
      if (cloudBackupLastSync != null)
        'cloud_backup_last_sync': cloudBackupLastSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PrivacySettingsTableCompanion copyWith({
    Value<String>? userId,
    Value<bool>? onDeviceProcessing,
    Value<bool>? cloudBackupEnabled,
    Value<DateTime?>? cloudBackupLastSync,
    Value<int>? rowid,
  }) {
    return PrivacySettingsTableCompanion(
      userId: userId ?? this.userId,
      onDeviceProcessing: onDeviceProcessing ?? this.onDeviceProcessing,
      cloudBackupEnabled: cloudBackupEnabled ?? this.cloudBackupEnabled,
      cloudBackupLastSync: cloudBackupLastSync ?? this.cloudBackupLastSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (onDeviceProcessing.present) {
      map['on_device_processing'] = Variable<bool>(onDeviceProcessing.value);
    }
    if (cloudBackupEnabled.present) {
      map['cloud_backup_enabled'] = Variable<bool>(cloudBackupEnabled.value);
    }
    if (cloudBackupLastSync.present) {
      map['cloud_backup_last_sync'] = Variable<DateTime>(
        cloudBackupLastSync.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrivacySettingsTableCompanion(')
          ..write('userId: $userId, ')
          ..write('onDeviceProcessing: $onDeviceProcessing, ')
          ..write('cloudBackupEnabled: $cloudBackupEnabled, ')
          ..write('cloudBackupLastSync: $cloudBackupLastSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OnboardingDataTableTable extends OnboardingDataTable
    with TableInfo<$OnboardingDataTableTable, OnboardingDataRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OnboardingDataTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepMeta = const VerificationMeta('step');
  @override
  late final GeneratedColumn<int> step = GeneratedColumn<int>(
    'step',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _institutionMeta = const VerificationMeta(
    'institution',
  );
  @override
  late final GeneratedColumn<String> institution = GeneratedColumn<String>(
    'institution',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [userId, step, institution];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'onboarding_data';
  @override
  VerificationContext validateIntegrity(
    Insertable<OnboardingDataRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('step')) {
      context.handle(
        _stepMeta,
        step.isAcceptableOrUnknown(data['step']!, _stepMeta),
      );
    }
    if (data.containsKey('institution')) {
      context.handle(
        _institutionMeta,
        institution.isAcceptableOrUnknown(
          data['institution']!,
          _institutionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  OnboardingDataRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OnboardingDataRow(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      step: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}step'],
      )!,
      institution: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}institution'],
      ),
    );
  }

  @override
  $OnboardingDataTableTable createAlias(String alias) {
    return $OnboardingDataTableTable(attachedDatabase, alias);
  }
}

class OnboardingDataRow extends DataClass
    implements Insertable<OnboardingDataRow> {
  final String userId;
  final int step;
  final String? institution;
  const OnboardingDataRow({
    required this.userId,
    required this.step,
    this.institution,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['step'] = Variable<int>(step);
    if (!nullToAbsent || institution != null) {
      map['institution'] = Variable<String>(institution);
    }
    return map;
  }

  OnboardingDataTableCompanion toCompanion(bool nullToAbsent) {
    return OnboardingDataTableCompanion(
      userId: Value(userId),
      step: Value(step),
      institution: institution == null && nullToAbsent
          ? const Value.absent()
          : Value(institution),
    );
  }

  factory OnboardingDataRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OnboardingDataRow(
      userId: serializer.fromJson<String>(json['userId']),
      step: serializer.fromJson<int>(json['step']),
      institution: serializer.fromJson<String?>(json['institution']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'step': serializer.toJson<int>(step),
      'institution': serializer.toJson<String?>(institution),
    };
  }

  OnboardingDataRow copyWith({
    String? userId,
    int? step,
    Value<String?> institution = const Value.absent(),
  }) => OnboardingDataRow(
    userId: userId ?? this.userId,
    step: step ?? this.step,
    institution: institution.present ? institution.value : this.institution,
  );
  OnboardingDataRow copyWithCompanion(OnboardingDataTableCompanion data) {
    return OnboardingDataRow(
      userId: data.userId.present ? data.userId.value : this.userId,
      step: data.step.present ? data.step.value : this.step,
      institution: data.institution.present
          ? data.institution.value
          : this.institution,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OnboardingDataRow(')
          ..write('userId: $userId, ')
          ..write('step: $step, ')
          ..write('institution: $institution')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, step, institution);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OnboardingDataRow &&
          other.userId == this.userId &&
          other.step == this.step &&
          other.institution == this.institution);
}

class OnboardingDataTableCompanion extends UpdateCompanion<OnboardingDataRow> {
  final Value<String> userId;
  final Value<int> step;
  final Value<String?> institution;
  final Value<int> rowid;
  const OnboardingDataTableCompanion({
    this.userId = const Value.absent(),
    this.step = const Value.absent(),
    this.institution = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OnboardingDataTableCompanion.insert({
    required String userId,
    this.step = const Value.absent(),
    this.institution = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId);
  static Insertable<OnboardingDataRow> custom({
    Expression<String>? userId,
    Expression<int>? step,
    Expression<String>? institution,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (step != null) 'step': step,
      if (institution != null) 'institution': institution,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OnboardingDataTableCompanion copyWith({
    Value<String>? userId,
    Value<int>? step,
    Value<String?>? institution,
    Value<int>? rowid,
  }) {
    return OnboardingDataTableCompanion(
      userId: userId ?? this.userId,
      step: step ?? this.step,
      institution: institution ?? this.institution,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (step.present) {
      map['step'] = Variable<int>(step.value);
    }
    if (institution.present) {
      map['institution'] = Variable<String>(institution.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OnboardingDataTableCompanion(')
          ..write('userId: $userId, ')
          ..write('step: $step, ')
          ..write('institution: $institution, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SubjectsTable subjects = $SubjectsTable(this);
  late final $TopicsTable topics = $TopicsTable(this);
  late final $ExamsTable exams = $ExamsTable(this);
  late final $StudyWindowsTable studyWindows = $StudyWindowsTable(this);
  late final $SchedulesTable schedules = $SchedulesTable(this);
  late final $StudyBlocksTable studyBlocks = $StudyBlocksTable(this);
  late final $LibraryItemsTable libraryItems = $LibraryItemsTable(this);
  late final $MaterialTextsTable materialTexts = $MaterialTextsTable(this);
  late final $QuizzesTable quizzes = $QuizzesTable(this);
  late final $QuizQuestionsTable quizQuestions = $QuizQuestionsTable(this);
  late final $QuizAttemptsTable quizAttempts = $QuizAttemptsTable(this);
  late final $QuizFeedbackItemsTable quizFeedbackItems =
      $QuizFeedbackItemsTable(this);
  late final $ProgressMetricsTable progressMetrics = $ProgressMetricsTable(
    this,
  );
  late final $StudyStreaksTable studyStreaks = $StudyStreaksTable(this);
  late final $DailyScoresTable dailyScores = $DailyScoresTable(this);
  late final $SessionMetricsTable sessionMetrics = $SessionMetricsTable(this);
  late final $TutorConversationsTable tutorConversations =
      $TutorConversationsTable(this);
  late final $TutorMessagesTable tutorMessages = $TutorMessagesTable(this);
  late final $TutorSettingsTableTable tutorSettingsTable =
      $TutorSettingsTableTable(this);
  late final $NotificationSettingsTableTable notificationSettingsTable =
      $NotificationSettingsTableTable(this);
  late final $AppearancePrefsTableTable appearancePrefsTable =
      $AppearancePrefsTableTable(this);
  late final $LanguagePrefsTableTable languagePrefsTable =
      $LanguagePrefsTableTable(this);
  late final $PrivacySettingsTableTable privacySettingsTable =
      $PrivacySettingsTableTable(this);
  late final $OnboardingDataTableTable onboardingDataTable =
      $OnboardingDataTableTable(this);
  late final SubjectDao subjectDao = SubjectDao(this as AppDatabase);
  late final ScheduleDao scheduleDao = ScheduleDao(this as AppDatabase);
  late final LibraryDao libraryDao = LibraryDao(this as AppDatabase);
  late final MaterialTextsDao materialTextsDao = MaterialTextsDao(
    this as AppDatabase,
  );
  late final QuizDao quizDao = QuizDao(this as AppDatabase);
  late final ProgressDao progressDao = ProgressDao(this as AppDatabase);
  late final TutorDao tutorDao = TutorDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  late final OnboardingDao onboardingDao = OnboardingDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    subjects,
    topics,
    exams,
    studyWindows,
    schedules,
    studyBlocks,
    libraryItems,
    materialTexts,
    quizzes,
    quizQuestions,
    quizAttempts,
    quizFeedbackItems,
    progressMetrics,
    studyStreaks,
    dailyScores,
    sessionMetrics,
    tutorConversations,
    tutorMessages,
    tutorSettingsTable,
    notificationSettingsTable,
    appearancePrefsTable,
    languagePrefsTable,
    privacySettingsTable,
    onboardingDataTable,
  ];
}

typedef $$SubjectsTableCreateCompanionBuilder =
    SubjectsCompanion Function({
      required String id,
      Value<String> userId,
      required String code,
      required String name,
      required String colorHex,
      required double confidenceLevel,
      Value<int> order,
      Value<int> rowid,
    });
typedef $$SubjectsTableUpdateCompanionBuilder =
    SubjectsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> code,
      Value<String> name,
      Value<String> colorHex,
      Value<double> confidenceLevel,
      Value<int> order,
      Value<int> rowid,
    });

final class $$SubjectsTableReferences
    extends BaseReferences<_$AppDatabase, $SubjectsTable, SubjectRow> {
  $$SubjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TopicsTable, List<TopicRow>> _topicsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.topics,
    aliasName: $_aliasNameGenerator(db.subjects.id, db.topics.subjectId),
  );

  $$TopicsTableProcessedTableManager get topicsRefs {
    final manager = $$TopicsTableTableManager(
      $_db,
      $_db.topics,
    ).filter((f) => f.subjectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_topicsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExamsTable, List<ExamRow>> _examsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.exams,
    aliasName: $_aliasNameGenerator(db.subjects.id, db.exams.subjectId),
  );

  $$ExamsTableProcessedTableManager get examsRefs {
    final manager = $$ExamsTableTableManager(
      $_db,
      $_db.exams,
    ).filter((f) => f.subjectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_examsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StudyBlocksTable, List<StudyBlockRow>>
  _studyBlocksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.studyBlocks,
    aliasName: $_aliasNameGenerator(db.subjects.id, db.studyBlocks.subjectId),
  );

  $$StudyBlocksTableProcessedTableManager get studyBlocksRefs {
    final manager = $$StudyBlocksTableTableManager(
      $_db,
      $_db.studyBlocks,
    ).filter((f) => f.subjectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_studyBlocksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LibraryItemsTable, List<LibraryItemRow>>
  _libraryItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.libraryItems,
    aliasName: $_aliasNameGenerator(db.subjects.id, db.libraryItems.subjectId),
  );

  $$LibraryItemsTableProcessedTableManager get libraryItemsRefs {
    final manager = $$LibraryItemsTableTableManager(
      $_db,
      $_db.libraryItems,
    ).filter((f) => f.subjectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_libraryItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$QuizzesTable, List<QuizRow>> _quizzesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.quizzes,
    aliasName: $_aliasNameGenerator(db.subjects.id, db.quizzes.subjectId),
  );

  $$QuizzesTableProcessedTableManager get quizzesRefs {
    final manager = $$QuizzesTableTableManager(
      $_db,
      $_db.quizzes,
    ).filter((f) => f.subjectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_quizzesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProgressMetricsTable, List<ProgressMetricRow>>
  _progressMetricsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.progressMetrics,
    aliasName: $_aliasNameGenerator(
      db.subjects.id,
      db.progressMetrics.subjectId,
    ),
  );

  $$ProgressMetricsTableProcessedTableManager get progressMetricsRefs {
    final manager = $$ProgressMetricsTableTableManager(
      $_db,
      $_db.progressMetrics,
    ).filter((f) => f.subjectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _progressMetricsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TutorConversationsTable,
    List<TutorConversationRow>
  >
  _tutorConversationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.tutorConversations,
        aliasName: $_aliasNameGenerator(
          db.subjects.id,
          db.tutorConversations.subjectId,
        ),
      );

  $$TutorConversationsTableProcessedTableManager get tutorConversationsRefs {
    final manager = $$TutorConversationsTableTableManager(
      $_db,
      $_db.tutorConversations,
    ).filter((f) => f.subjectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _tutorConversationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SubjectsTableFilterComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidenceLevel => $composableBuilder(
    column: $table.confidenceLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> topicsRefs(
    Expression<bool> Function($$TopicsTableFilterComposer f) f,
  ) {
    final $$TopicsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.topics,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsTableFilterComposer(
            $db: $db,
            $table: $db.topics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> examsRefs(
    Expression<bool> Function($$ExamsTableFilterComposer f) f,
  ) {
    final $$ExamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exams,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamsTableFilterComposer(
            $db: $db,
            $table: $db.exams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> studyBlocksRefs(
    Expression<bool> Function($$StudyBlocksTableFilterComposer f) f,
  ) {
    final $$StudyBlocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyBlocks,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyBlocksTableFilterComposer(
            $db: $db,
            $table: $db.studyBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> libraryItemsRefs(
    Expression<bool> Function($$LibraryItemsTableFilterComposer f) f,
  ) {
    final $$LibraryItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.libraryItems,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LibraryItemsTableFilterComposer(
            $db: $db,
            $table: $db.libraryItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> quizzesRefs(
    Expression<bool> Function($$QuizzesTableFilterComposer f) f,
  ) {
    final $$QuizzesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizzes,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizzesTableFilterComposer(
            $db: $db,
            $table: $db.quizzes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> progressMetricsRefs(
    Expression<bool> Function($$ProgressMetricsTableFilterComposer f) f,
  ) {
    final $$ProgressMetricsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.progressMetrics,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgressMetricsTableFilterComposer(
            $db: $db,
            $table: $db.progressMetrics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tutorConversationsRefs(
    Expression<bool> Function($$TutorConversationsTableFilterComposer f) f,
  ) {
    final $$TutorConversationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tutorConversations,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TutorConversationsTableFilterComposer(
            $db: $db,
            $table: $db.tutorConversations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidenceLevel => $composableBuilder(
    column: $table.confidenceLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<double> get confidenceLevel => $composableBuilder(
    column: $table.confidenceLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  Expression<T> topicsRefs<T extends Object>(
    Expression<T> Function($$TopicsTableAnnotationComposer a) f,
  ) {
    final $$TopicsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.topics,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsTableAnnotationComposer(
            $db: $db,
            $table: $db.topics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> examsRefs<T extends Object>(
    Expression<T> Function($$ExamsTableAnnotationComposer a) f,
  ) {
    final $$ExamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exams,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamsTableAnnotationComposer(
            $db: $db,
            $table: $db.exams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> studyBlocksRefs<T extends Object>(
    Expression<T> Function($$StudyBlocksTableAnnotationComposer a) f,
  ) {
    final $$StudyBlocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyBlocks,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyBlocksTableAnnotationComposer(
            $db: $db,
            $table: $db.studyBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> libraryItemsRefs<T extends Object>(
    Expression<T> Function($$LibraryItemsTableAnnotationComposer a) f,
  ) {
    final $$LibraryItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.libraryItems,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LibraryItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.libraryItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> quizzesRefs<T extends Object>(
    Expression<T> Function($$QuizzesTableAnnotationComposer a) f,
  ) {
    final $$QuizzesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizzes,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizzesTableAnnotationComposer(
            $db: $db,
            $table: $db.quizzes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> progressMetricsRefs<T extends Object>(
    Expression<T> Function($$ProgressMetricsTableAnnotationComposer a) f,
  ) {
    final $$ProgressMetricsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.progressMetrics,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgressMetricsTableAnnotationComposer(
            $db: $db,
            $table: $db.progressMetrics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tutorConversationsRefs<T extends Object>(
    Expression<T> Function($$TutorConversationsTableAnnotationComposer a) f,
  ) {
    final $$TutorConversationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.tutorConversations,
          getReferencedColumn: (t) => t.subjectId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TutorConversationsTableAnnotationComposer(
                $db: $db,
                $table: $db.tutorConversations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SubjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubjectsTable,
          SubjectRow,
          $$SubjectsTableFilterComposer,
          $$SubjectsTableOrderingComposer,
          $$SubjectsTableAnnotationComposer,
          $$SubjectsTableCreateCompanionBuilder,
          $$SubjectsTableUpdateCompanionBuilder,
          (SubjectRow, $$SubjectsTableReferences),
          SubjectRow,
          PrefetchHooks Function({
            bool topicsRefs,
            bool examsRefs,
            bool studyBlocksRefs,
            bool libraryItemsRefs,
            bool quizzesRefs,
            bool progressMetricsRefs,
            bool tutorConversationsRefs,
          })
        > {
  $$SubjectsTableTableManager(_$AppDatabase db, $SubjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<double> confidenceLevel = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubjectsCompanion(
                id: id,
                userId: userId,
                code: code,
                name: name,
                colorHex: colorHex,
                confidenceLevel: confidenceLevel,
                order: order,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> userId = const Value.absent(),
                required String code,
                required String name,
                required String colorHex,
                required double confidenceLevel,
                Value<int> order = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubjectsCompanion.insert(
                id: id,
                userId: userId,
                code: code,
                name: name,
                colorHex: colorHex,
                confidenceLevel: confidenceLevel,
                order: order,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SubjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                topicsRefs = false,
                examsRefs = false,
                studyBlocksRefs = false,
                libraryItemsRefs = false,
                quizzesRefs = false,
                progressMetricsRefs = false,
                tutorConversationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (topicsRefs) db.topics,
                    if (examsRefs) db.exams,
                    if (studyBlocksRefs) db.studyBlocks,
                    if (libraryItemsRefs) db.libraryItems,
                    if (quizzesRefs) db.quizzes,
                    if (progressMetricsRefs) db.progressMetrics,
                    if (tutorConversationsRefs) db.tutorConversations,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (topicsRefs)
                        await $_getPrefetchedData<
                          SubjectRow,
                          $SubjectsTable,
                          TopicRow
                        >(
                          currentTable: table,
                          referencedTable: $$SubjectsTableReferences
                              ._topicsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).topicsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subjectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (examsRefs)
                        await $_getPrefetchedData<
                          SubjectRow,
                          $SubjectsTable,
                          ExamRow
                        >(
                          currentTable: table,
                          referencedTable: $$SubjectsTableReferences
                              ._examsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).examsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subjectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (studyBlocksRefs)
                        await $_getPrefetchedData<
                          SubjectRow,
                          $SubjectsTable,
                          StudyBlockRow
                        >(
                          currentTable: table,
                          referencedTable: $$SubjectsTableReferences
                              ._studyBlocksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).studyBlocksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subjectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (libraryItemsRefs)
                        await $_getPrefetchedData<
                          SubjectRow,
                          $SubjectsTable,
                          LibraryItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$SubjectsTableReferences
                              ._libraryItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).libraryItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subjectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (quizzesRefs)
                        await $_getPrefetchedData<
                          SubjectRow,
                          $SubjectsTable,
                          QuizRow
                        >(
                          currentTable: table,
                          referencedTable: $$SubjectsTableReferences
                              ._quizzesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).quizzesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subjectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (progressMetricsRefs)
                        await $_getPrefetchedData<
                          SubjectRow,
                          $SubjectsTable,
                          ProgressMetricRow
                        >(
                          currentTable: table,
                          referencedTable: $$SubjectsTableReferences
                              ._progressMetricsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).progressMetricsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subjectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tutorConversationsRefs)
                        await $_getPrefetchedData<
                          SubjectRow,
                          $SubjectsTable,
                          TutorConversationRow
                        >(
                          currentTable: table,
                          referencedTable: $$SubjectsTableReferences
                              ._tutorConversationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).tutorConversationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subjectId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SubjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubjectsTable,
      SubjectRow,
      $$SubjectsTableFilterComposer,
      $$SubjectsTableOrderingComposer,
      $$SubjectsTableAnnotationComposer,
      $$SubjectsTableCreateCompanionBuilder,
      $$SubjectsTableUpdateCompanionBuilder,
      (SubjectRow, $$SubjectsTableReferences),
      SubjectRow,
      PrefetchHooks Function({
        bool topicsRefs,
        bool examsRefs,
        bool studyBlocksRefs,
        bool libraryItemsRefs,
        bool quizzesRefs,
        bool progressMetricsRefs,
        bool tutorConversationsRefs,
      })
    >;
typedef $$TopicsTableCreateCompanionBuilder =
    TopicsCompanion Function({
      required String id,
      required String subjectId,
      required String name,
      required int masteryPercentage,
      required TrendType trend,
      Value<bool> isWeak,
      Value<int> rowid,
    });
typedef $$TopicsTableUpdateCompanionBuilder =
    TopicsCompanion Function({
      Value<String> id,
      Value<String> subjectId,
      Value<String> name,
      Value<int> masteryPercentage,
      Value<TrendType> trend,
      Value<bool> isWeak,
      Value<int> rowid,
    });

final class $$TopicsTableReferences
    extends BaseReferences<_$AppDatabase, $TopicsTable, TopicRow> {
  $$TopicsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SubjectsTable _subjectIdTable(_$AppDatabase db) => db.subjects
      .createAlias($_aliasNameGenerator(db.topics.subjectId, db.subjects.id));

  $$SubjectsTableProcessedTableManager get subjectId {
    final $_column = $_itemColumn<String>('subject_id')!;

    final manager = $$SubjectsTableTableManager(
      $_db,
      $_db.subjects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$StudyBlocksTable, List<StudyBlockRow>>
  _studyBlocksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.studyBlocks,
    aliasName: $_aliasNameGenerator(db.topics.id, db.studyBlocks.topicId),
  );

  $$StudyBlocksTableProcessedTableManager get studyBlocksRefs {
    final manager = $$StudyBlocksTableTableManager(
      $_db,
      $_db.studyBlocks,
    ).filter((f) => f.topicId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_studyBlocksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$QuizzesTable, List<QuizRow>> _quizzesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.quizzes,
    aliasName: $_aliasNameGenerator(db.topics.id, db.quizzes.topicId),
  );

  $$QuizzesTableProcessedTableManager get quizzesRefs {
    final manager = $$QuizzesTableTableManager(
      $_db,
      $_db.quizzes,
    ).filter((f) => f.topicId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_quizzesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DailyScoresTable, List<DailyScoreRow>>
  _dailyScoresRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.dailyScores,
    aliasName: $_aliasNameGenerator(db.topics.id, db.dailyScores.topicId),
  );

  $$DailyScoresTableProcessedTableManager get dailyScoresRefs {
    final manager = $$DailyScoresTableTableManager(
      $_db,
      $_db.dailyScores,
    ).filter((f) => f.topicId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_dailyScoresRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TutorConversationsTable,
    List<TutorConversationRow>
  >
  _tutorConversationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.tutorConversations,
        aliasName: $_aliasNameGenerator(
          db.topics.id,
          db.tutorConversations.topicId,
        ),
      );

  $$TutorConversationsTableProcessedTableManager get tutorConversationsRefs {
    final manager = $$TutorConversationsTableTableManager(
      $_db,
      $_db.tutorConversations,
    ).filter((f) => f.topicId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _tutorConversationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TopicsTableFilterComposer
    extends Composer<_$AppDatabase, $TopicsTable> {
  $$TopicsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get masteryPercentage => $composableBuilder(
    column: $table.masteryPercentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TrendType, TrendType, String> get trend =>
      $composableBuilder(
        column: $table.trend,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get isWeak => $composableBuilder(
    column: $table.isWeak,
    builder: (column) => ColumnFilters(column),
  );

  $$SubjectsTableFilterComposer get subjectId {
    final $$SubjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableFilterComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> studyBlocksRefs(
    Expression<bool> Function($$StudyBlocksTableFilterComposer f) f,
  ) {
    final $$StudyBlocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyBlocks,
      getReferencedColumn: (t) => t.topicId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyBlocksTableFilterComposer(
            $db: $db,
            $table: $db.studyBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> quizzesRefs(
    Expression<bool> Function($$QuizzesTableFilterComposer f) f,
  ) {
    final $$QuizzesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizzes,
      getReferencedColumn: (t) => t.topicId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizzesTableFilterComposer(
            $db: $db,
            $table: $db.quizzes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> dailyScoresRefs(
    Expression<bool> Function($$DailyScoresTableFilterComposer f) f,
  ) {
    final $$DailyScoresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyScores,
      getReferencedColumn: (t) => t.topicId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyScoresTableFilterComposer(
            $db: $db,
            $table: $db.dailyScores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tutorConversationsRefs(
    Expression<bool> Function($$TutorConversationsTableFilterComposer f) f,
  ) {
    final $$TutorConversationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tutorConversations,
      getReferencedColumn: (t) => t.topicId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TutorConversationsTableFilterComposer(
            $db: $db,
            $table: $db.tutorConversations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TopicsTableOrderingComposer
    extends Composer<_$AppDatabase, $TopicsTable> {
  $$TopicsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get masteryPercentage => $composableBuilder(
    column: $table.masteryPercentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trend => $composableBuilder(
    column: $table.trend,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isWeak => $composableBuilder(
    column: $table.isWeak,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubjectsTableOrderingComposer get subjectId {
    final $$SubjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableOrderingComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TopicsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TopicsTable> {
  $$TopicsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get masteryPercentage => $composableBuilder(
    column: $table.masteryPercentage,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TrendType, String> get trend =>
      $composableBuilder(column: $table.trend, builder: (column) => column);

  GeneratedColumn<bool> get isWeak =>
      $composableBuilder(column: $table.isWeak, builder: (column) => column);

  $$SubjectsTableAnnotationComposer get subjectId {
    final $$SubjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> studyBlocksRefs<T extends Object>(
    Expression<T> Function($$StudyBlocksTableAnnotationComposer a) f,
  ) {
    final $$StudyBlocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyBlocks,
      getReferencedColumn: (t) => t.topicId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyBlocksTableAnnotationComposer(
            $db: $db,
            $table: $db.studyBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> quizzesRefs<T extends Object>(
    Expression<T> Function($$QuizzesTableAnnotationComposer a) f,
  ) {
    final $$QuizzesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizzes,
      getReferencedColumn: (t) => t.topicId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizzesTableAnnotationComposer(
            $db: $db,
            $table: $db.quizzes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> dailyScoresRefs<T extends Object>(
    Expression<T> Function($$DailyScoresTableAnnotationComposer a) f,
  ) {
    final $$DailyScoresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyScores,
      getReferencedColumn: (t) => t.topicId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyScoresTableAnnotationComposer(
            $db: $db,
            $table: $db.dailyScores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tutorConversationsRefs<T extends Object>(
    Expression<T> Function($$TutorConversationsTableAnnotationComposer a) f,
  ) {
    final $$TutorConversationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.tutorConversations,
          getReferencedColumn: (t) => t.topicId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TutorConversationsTableAnnotationComposer(
                $db: $db,
                $table: $db.tutorConversations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TopicsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TopicsTable,
          TopicRow,
          $$TopicsTableFilterComposer,
          $$TopicsTableOrderingComposer,
          $$TopicsTableAnnotationComposer,
          $$TopicsTableCreateCompanionBuilder,
          $$TopicsTableUpdateCompanionBuilder,
          (TopicRow, $$TopicsTableReferences),
          TopicRow,
          PrefetchHooks Function({
            bool subjectId,
            bool studyBlocksRefs,
            bool quizzesRefs,
            bool dailyScoresRefs,
            bool tutorConversationsRefs,
          })
        > {
  $$TopicsTableTableManager(_$AppDatabase db, $TopicsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TopicsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TopicsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TopicsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> subjectId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> masteryPercentage = const Value.absent(),
                Value<TrendType> trend = const Value.absent(),
                Value<bool> isWeak = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TopicsCompanion(
                id: id,
                subjectId: subjectId,
                name: name,
                masteryPercentage: masteryPercentage,
                trend: trend,
                isWeak: isWeak,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String subjectId,
                required String name,
                required int masteryPercentage,
                required TrendType trend,
                Value<bool> isWeak = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TopicsCompanion.insert(
                id: id,
                subjectId: subjectId,
                name: name,
                masteryPercentage: masteryPercentage,
                trend: trend,
                isWeak: isWeak,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TopicsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                subjectId = false,
                studyBlocksRefs = false,
                quizzesRefs = false,
                dailyScoresRefs = false,
                tutorConversationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (studyBlocksRefs) db.studyBlocks,
                    if (quizzesRefs) db.quizzes,
                    if (dailyScoresRefs) db.dailyScores,
                    if (tutorConversationsRefs) db.tutorConversations,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (subjectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.subjectId,
                                    referencedTable: $$TopicsTableReferences
                                        ._subjectIdTable(db),
                                    referencedColumn: $$TopicsTableReferences
                                        ._subjectIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (studyBlocksRefs)
                        await $_getPrefetchedData<
                          TopicRow,
                          $TopicsTable,
                          StudyBlockRow
                        >(
                          currentTable: table,
                          referencedTable: $$TopicsTableReferences
                              ._studyBlocksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TopicsTableReferences(
                                db,
                                table,
                                p0,
                              ).studyBlocksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.topicId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (quizzesRefs)
                        await $_getPrefetchedData<
                          TopicRow,
                          $TopicsTable,
                          QuizRow
                        >(
                          currentTable: table,
                          referencedTable: $$TopicsTableReferences
                              ._quizzesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TopicsTableReferences(
                                db,
                                table,
                                p0,
                              ).quizzesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.topicId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (dailyScoresRefs)
                        await $_getPrefetchedData<
                          TopicRow,
                          $TopicsTable,
                          DailyScoreRow
                        >(
                          currentTable: table,
                          referencedTable: $$TopicsTableReferences
                              ._dailyScoresRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TopicsTableReferences(
                                db,
                                table,
                                p0,
                              ).dailyScoresRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.topicId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tutorConversationsRefs)
                        await $_getPrefetchedData<
                          TopicRow,
                          $TopicsTable,
                          TutorConversationRow
                        >(
                          currentTable: table,
                          referencedTable: $$TopicsTableReferences
                              ._tutorConversationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TopicsTableReferences(
                                db,
                                table,
                                p0,
                              ).tutorConversationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.topicId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TopicsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TopicsTable,
      TopicRow,
      $$TopicsTableFilterComposer,
      $$TopicsTableOrderingComposer,
      $$TopicsTableAnnotationComposer,
      $$TopicsTableCreateCompanionBuilder,
      $$TopicsTableUpdateCompanionBuilder,
      (TopicRow, $$TopicsTableReferences),
      TopicRow,
      PrefetchHooks Function({
        bool subjectId,
        bool studyBlocksRefs,
        bool quizzesRefs,
        bool dailyScoresRefs,
        bool tutorConversationsRefs,
      })
    >;
typedef $$ExamsTableCreateCompanionBuilder =
    ExamsCompanion Function({
      required String id,
      Value<String> userId,
      required String subjectId,
      required DateTime date,
      Value<String?> label,
      Value<int> rowid,
    });
typedef $$ExamsTableUpdateCompanionBuilder =
    ExamsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> subjectId,
      Value<DateTime> date,
      Value<String?> label,
      Value<int> rowid,
    });

final class $$ExamsTableReferences
    extends BaseReferences<_$AppDatabase, $ExamsTable, ExamRow> {
  $$ExamsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SubjectsTable _subjectIdTable(_$AppDatabase db) => db.subjects
      .createAlias($_aliasNameGenerator(db.exams.subjectId, db.subjects.id));

  $$SubjectsTableProcessedTableManager get subjectId {
    final $_column = $_itemColumn<String>('subject_id')!;

    final manager = $$SubjectsTableTableManager(
      $_db,
      $_db.subjects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExamsTableFilterComposer extends Composer<_$AppDatabase, $ExamsTable> {
  $$ExamsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  $$SubjectsTableFilterComposer get subjectId {
    final $$SubjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableFilterComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExamsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamsTable> {
  $$ExamsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubjectsTableOrderingComposer get subjectId {
    final $$SubjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableOrderingComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExamsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamsTable> {
  $$ExamsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  $$SubjectsTableAnnotationComposer get subjectId {
    final $$SubjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExamsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExamsTable,
          ExamRow,
          $$ExamsTableFilterComposer,
          $$ExamsTableOrderingComposer,
          $$ExamsTableAnnotationComposer,
          $$ExamsTableCreateCompanionBuilder,
          $$ExamsTableUpdateCompanionBuilder,
          (ExamRow, $$ExamsTableReferences),
          ExamRow,
          PrefetchHooks Function({bool subjectId})
        > {
  $$ExamsTableTableManager(_$AppDatabase db, $ExamsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExamsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExamsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExamsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> subjectId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExamsCompanion(
                id: id,
                userId: userId,
                subjectId: subjectId,
                date: date,
                label: label,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> userId = const Value.absent(),
                required String subjectId,
                required DateTime date,
                Value<String?> label = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExamsCompanion.insert(
                id: id,
                userId: userId,
                subjectId: subjectId,
                date: date,
                label: label,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$ExamsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({subjectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (subjectId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.subjectId,
                                referencedTable: $$ExamsTableReferences
                                    ._subjectIdTable(db),
                                referencedColumn: $$ExamsTableReferences
                                    ._subjectIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExamsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExamsTable,
      ExamRow,
      $$ExamsTableFilterComposer,
      $$ExamsTableOrderingComposer,
      $$ExamsTableAnnotationComposer,
      $$ExamsTableCreateCompanionBuilder,
      $$ExamsTableUpdateCompanionBuilder,
      (ExamRow, $$ExamsTableReferences),
      ExamRow,
      PrefetchHooks Function({bool subjectId})
    >;
typedef $$StudyWindowsTableCreateCompanionBuilder =
    StudyWindowsCompanion Function({
      required String id,
      required String label,
      required String startTime,
      required String endTime,
      Value<bool> isEnabled,
      Value<int> rowid,
    });
typedef $$StudyWindowsTableUpdateCompanionBuilder =
    StudyWindowsCompanion Function({
      Value<String> id,
      Value<String> label,
      Value<String> startTime,
      Value<String> endTime,
      Value<bool> isEnabled,
      Value<int> rowid,
    });

class $$StudyWindowsTableFilterComposer
    extends Composer<_$AppDatabase, $StudyWindowsTable> {
  $$StudyWindowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StudyWindowsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudyWindowsTable> {
  $$StudyWindowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudyWindowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudyWindowsTable> {
  $$StudyWindowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);
}

class $$StudyWindowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudyWindowsTable,
          StudyWindowRow,
          $$StudyWindowsTableFilterComposer,
          $$StudyWindowsTableOrderingComposer,
          $$StudyWindowsTableAnnotationComposer,
          $$StudyWindowsTableCreateCompanionBuilder,
          $$StudyWindowsTableUpdateCompanionBuilder,
          (
            StudyWindowRow,
            BaseReferences<_$AppDatabase, $StudyWindowsTable, StudyWindowRow>,
          ),
          StudyWindowRow,
          PrefetchHooks Function()
        > {
  $$StudyWindowsTableTableManager(_$AppDatabase db, $StudyWindowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudyWindowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudyWindowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudyWindowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> startTime = const Value.absent(),
                Value<String> endTime = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyWindowsCompanion(
                id: id,
                label: label,
                startTime: startTime,
                endTime: endTime,
                isEnabled: isEnabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String label,
                required String startTime,
                required String endTime,
                Value<bool> isEnabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyWindowsCompanion.insert(
                id: id,
                label: label,
                startTime: startTime,
                endTime: endTime,
                isEnabled: isEnabled,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StudyWindowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudyWindowsTable,
      StudyWindowRow,
      $$StudyWindowsTableFilterComposer,
      $$StudyWindowsTableOrderingComposer,
      $$StudyWindowsTableAnnotationComposer,
      $$StudyWindowsTableCreateCompanionBuilder,
      $$StudyWindowsTableUpdateCompanionBuilder,
      (
        StudyWindowRow,
        BaseReferences<_$AppDatabase, $StudyWindowsTable, StudyWindowRow>,
      ),
      StudyWindowRow,
      PrefetchHooks Function()
    >;
typedef $$SchedulesTableCreateCompanionBuilder =
    SchedulesCompanion Function({
      required String id,
      required String userId,
      required double dailyTargetHours,
      required List<String> enabledWindowIds,
      Value<DateTime?> weekStartDate,
      Value<String?> aiReasoning,
      Value<bool> isAIGenerated,
      Value<int> rowid,
    });
typedef $$SchedulesTableUpdateCompanionBuilder =
    SchedulesCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<double> dailyTargetHours,
      Value<List<String>> enabledWindowIds,
      Value<DateTime?> weekStartDate,
      Value<String?> aiReasoning,
      Value<bool> isAIGenerated,
      Value<int> rowid,
    });

final class $$SchedulesTableReferences
    extends BaseReferences<_$AppDatabase, $SchedulesTable, ScheduleRow> {
  $$SchedulesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StudyBlocksTable, List<StudyBlockRow>>
  _studyBlocksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.studyBlocks,
    aliasName: $_aliasNameGenerator(db.schedules.id, db.studyBlocks.scheduleId),
  );

  $$StudyBlocksTableProcessedTableManager get studyBlocksRefs {
    final manager = $$StudyBlocksTableTableManager(
      $_db,
      $_db.studyBlocks,
    ).filter((f) => f.scheduleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_studyBlocksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SchedulesTableFilterComposer
    extends Composer<_$AppDatabase, $SchedulesTable> {
  $$SchedulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get dailyTargetHours => $composableBuilder(
    column: $table.dailyTargetHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get enabledWindowIds => $composableBuilder(
    column: $table.enabledWindowIds,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get weekStartDate => $composableBuilder(
    column: $table.weekStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiReasoning => $composableBuilder(
    column: $table.aiReasoning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAIGenerated => $composableBuilder(
    column: $table.isAIGenerated,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> studyBlocksRefs(
    Expression<bool> Function($$StudyBlocksTableFilterComposer f) f,
  ) {
    final $$StudyBlocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyBlocks,
      getReferencedColumn: (t) => t.scheduleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyBlocksTableFilterComposer(
            $db: $db,
            $table: $db.studyBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SchedulesTableOrderingComposer
    extends Composer<_$AppDatabase, $SchedulesTable> {
  $$SchedulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get dailyTargetHours => $composableBuilder(
    column: $table.dailyTargetHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get enabledWindowIds => $composableBuilder(
    column: $table.enabledWindowIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get weekStartDate => $composableBuilder(
    column: $table.weekStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiReasoning => $composableBuilder(
    column: $table.aiReasoning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAIGenerated => $composableBuilder(
    column: $table.isAIGenerated,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SchedulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SchedulesTable> {
  $$SchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<double> get dailyTargetHours => $composableBuilder(
    column: $table.dailyTargetHours,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get enabledWindowIds =>
      $composableBuilder(
        column: $table.enabledWindowIds,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get weekStartDate => $composableBuilder(
    column: $table.weekStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get aiReasoning => $composableBuilder(
    column: $table.aiReasoning,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isAIGenerated => $composableBuilder(
    column: $table.isAIGenerated,
    builder: (column) => column,
  );

  Expression<T> studyBlocksRefs<T extends Object>(
    Expression<T> Function($$StudyBlocksTableAnnotationComposer a) f,
  ) {
    final $$StudyBlocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyBlocks,
      getReferencedColumn: (t) => t.scheduleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyBlocksTableAnnotationComposer(
            $db: $db,
            $table: $db.studyBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SchedulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SchedulesTable,
          ScheduleRow,
          $$SchedulesTableFilterComposer,
          $$SchedulesTableOrderingComposer,
          $$SchedulesTableAnnotationComposer,
          $$SchedulesTableCreateCompanionBuilder,
          $$SchedulesTableUpdateCompanionBuilder,
          (ScheduleRow, $$SchedulesTableReferences),
          ScheduleRow,
          PrefetchHooks Function({bool studyBlocksRefs})
        > {
  $$SchedulesTableTableManager(_$AppDatabase db, $SchedulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SchedulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SchedulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<double> dailyTargetHours = const Value.absent(),
                Value<List<String>> enabledWindowIds = const Value.absent(),
                Value<DateTime?> weekStartDate = const Value.absent(),
                Value<String?> aiReasoning = const Value.absent(),
                Value<bool> isAIGenerated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SchedulesCompanion(
                id: id,
                userId: userId,
                dailyTargetHours: dailyTargetHours,
                enabledWindowIds: enabledWindowIds,
                weekStartDate: weekStartDate,
                aiReasoning: aiReasoning,
                isAIGenerated: isAIGenerated,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required double dailyTargetHours,
                required List<String> enabledWindowIds,
                Value<DateTime?> weekStartDate = const Value.absent(),
                Value<String?> aiReasoning = const Value.absent(),
                Value<bool> isAIGenerated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SchedulesCompanion.insert(
                id: id,
                userId: userId,
                dailyTargetHours: dailyTargetHours,
                enabledWindowIds: enabledWindowIds,
                weekStartDate: weekStartDate,
                aiReasoning: aiReasoning,
                isAIGenerated: isAIGenerated,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SchedulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({studyBlocksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (studyBlocksRefs) db.studyBlocks],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (studyBlocksRefs)
                    await $_getPrefetchedData<
                      ScheduleRow,
                      $SchedulesTable,
                      StudyBlockRow
                    >(
                      currentTable: table,
                      referencedTable: $$SchedulesTableReferences
                          ._studyBlocksRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SchedulesTableReferences(
                            db,
                            table,
                            p0,
                          ).studyBlocksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.scheduleId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SchedulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SchedulesTable,
      ScheduleRow,
      $$SchedulesTableFilterComposer,
      $$SchedulesTableOrderingComposer,
      $$SchedulesTableAnnotationComposer,
      $$SchedulesTableCreateCompanionBuilder,
      $$SchedulesTableUpdateCompanionBuilder,
      (ScheduleRow, $$SchedulesTableReferences),
      ScheduleRow,
      PrefetchHooks Function({bool studyBlocksRefs})
    >;
typedef $$StudyBlocksTableCreateCompanionBuilder =
    StudyBlocksCompanion Function({
      required String id,
      required String scheduleId,
      required int dayOfWeek,
      required DateTime date,
      required String startTime,
      required int durationMinutes,
      required String subjectId,
      Value<String?> topicId,
      required String title,
      required String activities,
      required BlockStatus status,
      Value<String?> aiInsight,
      Value<bool> isAIGenerated,
      Value<int> rowid,
    });
typedef $$StudyBlocksTableUpdateCompanionBuilder =
    StudyBlocksCompanion Function({
      Value<String> id,
      Value<String> scheduleId,
      Value<int> dayOfWeek,
      Value<DateTime> date,
      Value<String> startTime,
      Value<int> durationMinutes,
      Value<String> subjectId,
      Value<String?> topicId,
      Value<String> title,
      Value<String> activities,
      Value<BlockStatus> status,
      Value<String?> aiInsight,
      Value<bool> isAIGenerated,
      Value<int> rowid,
    });

final class $$StudyBlocksTableReferences
    extends BaseReferences<_$AppDatabase, $StudyBlocksTable, StudyBlockRow> {
  $$StudyBlocksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SchedulesTable _scheduleIdTable(_$AppDatabase db) =>
      db.schedules.createAlias(
        $_aliasNameGenerator(db.studyBlocks.scheduleId, db.schedules.id),
      );

  $$SchedulesTableProcessedTableManager get scheduleId {
    final $_column = $_itemColumn<String>('schedule_id')!;

    final manager = $$SchedulesTableTableManager(
      $_db,
      $_db.schedules,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_scheduleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SubjectsTable _subjectIdTable(_$AppDatabase db) =>
      db.subjects.createAlias(
        $_aliasNameGenerator(db.studyBlocks.subjectId, db.subjects.id),
      );

  $$SubjectsTableProcessedTableManager get subjectId {
    final $_column = $_itemColumn<String>('subject_id')!;

    final manager = $$SubjectsTableTableManager(
      $_db,
      $_db.subjects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TopicsTable _topicIdTable(_$AppDatabase db) => db.topics.createAlias(
    $_aliasNameGenerator(db.studyBlocks.topicId, db.topics.id),
  );

  $$TopicsTableProcessedTableManager? get topicId {
    final $_column = $_itemColumn<String>('topic_id');
    if ($_column == null) return null;
    final manager = $$TopicsTableTableManager(
      $_db,
      $_db.topics,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_topicIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StudyBlocksTableFilterComposer
    extends Composer<_$AppDatabase, $StudyBlocksTable> {
  $$StudyBlocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activities => $composableBuilder(
    column: $table.activities,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BlockStatus, BlockStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get aiInsight => $composableBuilder(
    column: $table.aiInsight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAIGenerated => $composableBuilder(
    column: $table.isAIGenerated,
    builder: (column) => ColumnFilters(column),
  );

  $$SchedulesTableFilterComposer get scheduleId {
    final $$SchedulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleId,
      referencedTable: $db.schedules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchedulesTableFilterComposer(
            $db: $db,
            $table: $db.schedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubjectsTableFilterComposer get subjectId {
    final $$SubjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableFilterComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TopicsTableFilterComposer get topicId {
    final $$TopicsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topicId,
      referencedTable: $db.topics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsTableFilterComposer(
            $db: $db,
            $table: $db.topics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudyBlocksTableOrderingComposer
    extends Composer<_$AppDatabase, $StudyBlocksTable> {
  $$StudyBlocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activities => $composableBuilder(
    column: $table.activities,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiInsight => $composableBuilder(
    column: $table.aiInsight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAIGenerated => $composableBuilder(
    column: $table.isAIGenerated,
    builder: (column) => ColumnOrderings(column),
  );

  $$SchedulesTableOrderingComposer get scheduleId {
    final $$SchedulesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleId,
      referencedTable: $db.schedules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchedulesTableOrderingComposer(
            $db: $db,
            $table: $db.schedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubjectsTableOrderingComposer get subjectId {
    final $$SubjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableOrderingComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TopicsTableOrderingComposer get topicId {
    final $$TopicsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topicId,
      referencedTable: $db.topics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsTableOrderingComposer(
            $db: $db,
            $table: $db.topics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudyBlocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudyBlocksTable> {
  $$StudyBlocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get dayOfWeek =>
      $composableBuilder(column: $table.dayOfWeek, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get activities => $composableBuilder(
    column: $table.activities,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<BlockStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get aiInsight =>
      $composableBuilder(column: $table.aiInsight, builder: (column) => column);

  GeneratedColumn<bool> get isAIGenerated => $composableBuilder(
    column: $table.isAIGenerated,
    builder: (column) => column,
  );

  $$SchedulesTableAnnotationComposer get scheduleId {
    final $$SchedulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleId,
      referencedTable: $db.schedules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchedulesTableAnnotationComposer(
            $db: $db,
            $table: $db.schedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubjectsTableAnnotationComposer get subjectId {
    final $$SubjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TopicsTableAnnotationComposer get topicId {
    final $$TopicsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topicId,
      referencedTable: $db.topics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsTableAnnotationComposer(
            $db: $db,
            $table: $db.topics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudyBlocksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudyBlocksTable,
          StudyBlockRow,
          $$StudyBlocksTableFilterComposer,
          $$StudyBlocksTableOrderingComposer,
          $$StudyBlocksTableAnnotationComposer,
          $$StudyBlocksTableCreateCompanionBuilder,
          $$StudyBlocksTableUpdateCompanionBuilder,
          (StudyBlockRow, $$StudyBlocksTableReferences),
          StudyBlockRow,
          PrefetchHooks Function({
            bool scheduleId,
            bool subjectId,
            bool topicId,
          })
        > {
  $$StudyBlocksTableTableManager(_$AppDatabase db, $StudyBlocksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudyBlocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudyBlocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudyBlocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> scheduleId = const Value.absent(),
                Value<int> dayOfWeek = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> startTime = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<String> subjectId = const Value.absent(),
                Value<String?> topicId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> activities = const Value.absent(),
                Value<BlockStatus> status = const Value.absent(),
                Value<String?> aiInsight = const Value.absent(),
                Value<bool> isAIGenerated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyBlocksCompanion(
                id: id,
                scheduleId: scheduleId,
                dayOfWeek: dayOfWeek,
                date: date,
                startTime: startTime,
                durationMinutes: durationMinutes,
                subjectId: subjectId,
                topicId: topicId,
                title: title,
                activities: activities,
                status: status,
                aiInsight: aiInsight,
                isAIGenerated: isAIGenerated,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String scheduleId,
                required int dayOfWeek,
                required DateTime date,
                required String startTime,
                required int durationMinutes,
                required String subjectId,
                Value<String?> topicId = const Value.absent(),
                required String title,
                required String activities,
                required BlockStatus status,
                Value<String?> aiInsight = const Value.absent(),
                Value<bool> isAIGenerated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyBlocksCompanion.insert(
                id: id,
                scheduleId: scheduleId,
                dayOfWeek: dayOfWeek,
                date: date,
                startTime: startTime,
                durationMinutes: durationMinutes,
                subjectId: subjectId,
                topicId: topicId,
                title: title,
                activities: activities,
                status: status,
                aiInsight: aiInsight,
                isAIGenerated: isAIGenerated,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StudyBlocksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({scheduleId = false, subjectId = false, topicId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (scheduleId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.scheduleId,
                                    referencedTable:
                                        $$StudyBlocksTableReferences
                                            ._scheduleIdTable(db),
                                    referencedColumn:
                                        $$StudyBlocksTableReferences
                                            ._scheduleIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (subjectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.subjectId,
                                    referencedTable:
                                        $$StudyBlocksTableReferences
                                            ._subjectIdTable(db),
                                    referencedColumn:
                                        $$StudyBlocksTableReferences
                                            ._subjectIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (topicId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.topicId,
                                    referencedTable:
                                        $$StudyBlocksTableReferences
                                            ._topicIdTable(db),
                                    referencedColumn:
                                        $$StudyBlocksTableReferences
                                            ._topicIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$StudyBlocksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudyBlocksTable,
      StudyBlockRow,
      $$StudyBlocksTableFilterComposer,
      $$StudyBlocksTableOrderingComposer,
      $$StudyBlocksTableAnnotationComposer,
      $$StudyBlocksTableCreateCompanionBuilder,
      $$StudyBlocksTableUpdateCompanionBuilder,
      (StudyBlockRow, $$StudyBlocksTableReferences),
      StudyBlockRow,
      PrefetchHooks Function({bool scheduleId, bool subjectId, bool topicId})
    >;
typedef $$LibraryItemsTableCreateCompanionBuilder =
    LibraryItemsCompanion Function({
      required String id,
      required String userId,
      required String name,
      required ItemKind kind,
      required int fileSize,
      required DateTime uploadedAt,
      required ProcessingStatus processingStatus,
      Value<String?> subjectId,
      Value<String?> metadata,
      Value<String?> colorHex,
      Value<int?> indexedPageCount,
      Value<int> rowid,
    });
typedef $$LibraryItemsTableUpdateCompanionBuilder =
    LibraryItemsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> name,
      Value<ItemKind> kind,
      Value<int> fileSize,
      Value<DateTime> uploadedAt,
      Value<ProcessingStatus> processingStatus,
      Value<String?> subjectId,
      Value<String?> metadata,
      Value<String?> colorHex,
      Value<int?> indexedPageCount,
      Value<int> rowid,
    });

final class $$LibraryItemsTableReferences
    extends BaseReferences<_$AppDatabase, $LibraryItemsTable, LibraryItemRow> {
  $$LibraryItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SubjectsTable _subjectIdTable(_$AppDatabase db) =>
      db.subjects.createAlias(
        $_aliasNameGenerator(db.libraryItems.subjectId, db.subjects.id),
      );

  $$SubjectsTableProcessedTableManager? get subjectId {
    final $_column = $_itemColumn<String>('subject_id');
    if ($_column == null) return null;
    final manager = $$SubjectsTableTableManager(
      $_db,
      $_db.subjects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MaterialTextsTable, List<MaterialTextRow>>
  _materialTextsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.materialTexts,
    aliasName: $_aliasNameGenerator(
      db.libraryItems.id,
      db.materialTexts.itemId,
    ),
  );

  $$MaterialTextsTableProcessedTableManager get materialTextsRefs {
    final manager = $$MaterialTextsTableTableManager(
      $_db,
      $_db.materialTexts,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_materialTextsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LibraryItemsTableFilterComposer
    extends Composer<_$AppDatabase, $LibraryItemsTable> {
  $$LibraryItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ItemKind, ItemKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ProcessingStatus, ProcessingStatus, String>
  get processingStatus => $composableBuilder(
    column: $table.processingStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get indexedPageCount => $composableBuilder(
    column: $table.indexedPageCount,
    builder: (column) => ColumnFilters(column),
  );

  $$SubjectsTableFilterComposer get subjectId {
    final $$SubjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableFilterComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> materialTextsRefs(
    Expression<bool> Function($$MaterialTextsTableFilterComposer f) f,
  ) {
    final $$MaterialTextsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.materialTexts,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaterialTextsTableFilterComposer(
            $db: $db,
            $table: $db.materialTexts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LibraryItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $LibraryItemsTable> {
  $$LibraryItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get processingStatus => $composableBuilder(
    column: $table.processingStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get indexedPageCount => $composableBuilder(
    column: $table.indexedPageCount,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubjectsTableOrderingComposer get subjectId {
    final $$SubjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableOrderingComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LibraryItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LibraryItemsTable> {
  $$LibraryItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ItemKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<DateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ProcessingStatus, String>
  get processingStatus => $composableBuilder(
    column: $table.processingStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<int> get indexedPageCount => $composableBuilder(
    column: $table.indexedPageCount,
    builder: (column) => column,
  );

  $$SubjectsTableAnnotationComposer get subjectId {
    final $$SubjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> materialTextsRefs<T extends Object>(
    Expression<T> Function($$MaterialTextsTableAnnotationComposer a) f,
  ) {
    final $$MaterialTextsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.materialTexts,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaterialTextsTableAnnotationComposer(
            $db: $db,
            $table: $db.materialTexts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LibraryItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LibraryItemsTable,
          LibraryItemRow,
          $$LibraryItemsTableFilterComposer,
          $$LibraryItemsTableOrderingComposer,
          $$LibraryItemsTableAnnotationComposer,
          $$LibraryItemsTableCreateCompanionBuilder,
          $$LibraryItemsTableUpdateCompanionBuilder,
          (LibraryItemRow, $$LibraryItemsTableReferences),
          LibraryItemRow,
          PrefetchHooks Function({bool subjectId, bool materialTextsRefs})
        > {
  $$LibraryItemsTableTableManager(_$AppDatabase db, $LibraryItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LibraryItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LibraryItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LibraryItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<ItemKind> kind = const Value.absent(),
                Value<int> fileSize = const Value.absent(),
                Value<DateTime> uploadedAt = const Value.absent(),
                Value<ProcessingStatus> processingStatus = const Value.absent(),
                Value<String?> subjectId = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<String?> colorHex = const Value.absent(),
                Value<int?> indexedPageCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LibraryItemsCompanion(
                id: id,
                userId: userId,
                name: name,
                kind: kind,
                fileSize: fileSize,
                uploadedAt: uploadedAt,
                processingStatus: processingStatus,
                subjectId: subjectId,
                metadata: metadata,
                colorHex: colorHex,
                indexedPageCount: indexedPageCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String name,
                required ItemKind kind,
                required int fileSize,
                required DateTime uploadedAt,
                required ProcessingStatus processingStatus,
                Value<String?> subjectId = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<String?> colorHex = const Value.absent(),
                Value<int?> indexedPageCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LibraryItemsCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                kind: kind,
                fileSize: fileSize,
                uploadedAt: uploadedAt,
                processingStatus: processingStatus,
                subjectId: subjectId,
                metadata: metadata,
                colorHex: colorHex,
                indexedPageCount: indexedPageCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LibraryItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({subjectId = false, materialTextsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (materialTextsRefs) db.materialTexts,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (subjectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.subjectId,
                                    referencedTable:
                                        $$LibraryItemsTableReferences
                                            ._subjectIdTable(db),
                                    referencedColumn:
                                        $$LibraryItemsTableReferences
                                            ._subjectIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (materialTextsRefs)
                        await $_getPrefetchedData<
                          LibraryItemRow,
                          $LibraryItemsTable,
                          MaterialTextRow
                        >(
                          currentTable: table,
                          referencedTable: $$LibraryItemsTableReferences
                              ._materialTextsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LibraryItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).materialTextsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LibraryItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LibraryItemsTable,
      LibraryItemRow,
      $$LibraryItemsTableFilterComposer,
      $$LibraryItemsTableOrderingComposer,
      $$LibraryItemsTableAnnotationComposer,
      $$LibraryItemsTableCreateCompanionBuilder,
      $$LibraryItemsTableUpdateCompanionBuilder,
      (LibraryItemRow, $$LibraryItemsTableReferences),
      LibraryItemRow,
      PrefetchHooks Function({bool subjectId, bool materialTextsRefs})
    >;
typedef $$MaterialTextsTableCreateCompanionBuilder =
    MaterialTextsCompanion Function({
      required String itemId,
      required String content,
      Value<int> pageCount,
      Value<int> charCount,
      required DateTime extractedAt,
      Value<int> rowid,
    });
typedef $$MaterialTextsTableUpdateCompanionBuilder =
    MaterialTextsCompanion Function({
      Value<String> itemId,
      Value<String> content,
      Value<int> pageCount,
      Value<int> charCount,
      Value<DateTime> extractedAt,
      Value<int> rowid,
    });

final class $$MaterialTextsTableReferences
    extends
        BaseReferences<_$AppDatabase, $MaterialTextsTable, MaterialTextRow> {
  $$MaterialTextsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LibraryItemsTable _itemIdTable(_$AppDatabase db) =>
      db.libraryItems.createAlias(
        $_aliasNameGenerator(db.materialTexts.itemId, db.libraryItems.id),
      );

  $$LibraryItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = $$LibraryItemsTableTableManager(
      $_db,
      $_db.libraryItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MaterialTextsTableFilterComposer
    extends Composer<_$AppDatabase, $MaterialTextsTable> {
  $$MaterialTextsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageCount => $composableBuilder(
    column: $table.pageCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get charCount => $composableBuilder(
    column: $table.charCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get extractedAt => $composableBuilder(
    column: $table.extractedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LibraryItemsTableFilterComposer get itemId {
    final $$LibraryItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.libraryItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LibraryItemsTableFilterComposer(
            $db: $db,
            $table: $db.libraryItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MaterialTextsTableOrderingComposer
    extends Composer<_$AppDatabase, $MaterialTextsTable> {
  $$MaterialTextsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageCount => $composableBuilder(
    column: $table.pageCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get charCount => $composableBuilder(
    column: $table.charCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get extractedAt => $composableBuilder(
    column: $table.extractedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LibraryItemsTableOrderingComposer get itemId {
    final $$LibraryItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.libraryItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LibraryItemsTableOrderingComposer(
            $db: $db,
            $table: $db.libraryItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MaterialTextsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaterialTextsTable> {
  $$MaterialTextsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get pageCount =>
      $composableBuilder(column: $table.pageCount, builder: (column) => column);

  GeneratedColumn<int> get charCount =>
      $composableBuilder(column: $table.charCount, builder: (column) => column);

  GeneratedColumn<DateTime> get extractedAt => $composableBuilder(
    column: $table.extractedAt,
    builder: (column) => column,
  );

  $$LibraryItemsTableAnnotationComposer get itemId {
    final $$LibraryItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.libraryItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LibraryItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.libraryItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MaterialTextsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MaterialTextsTable,
          MaterialTextRow,
          $$MaterialTextsTableFilterComposer,
          $$MaterialTextsTableOrderingComposer,
          $$MaterialTextsTableAnnotationComposer,
          $$MaterialTextsTableCreateCompanionBuilder,
          $$MaterialTextsTableUpdateCompanionBuilder,
          (MaterialTextRow, $$MaterialTextsTableReferences),
          MaterialTextRow,
          PrefetchHooks Function({bool itemId})
        > {
  $$MaterialTextsTableTableManager(_$AppDatabase db, $MaterialTextsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaterialTextsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaterialTextsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaterialTextsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> itemId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<int> pageCount = const Value.absent(),
                Value<int> charCount = const Value.absent(),
                Value<DateTime> extractedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MaterialTextsCompanion(
                itemId: itemId,
                content: content,
                pageCount: pageCount,
                charCount: charCount,
                extractedAt: extractedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemId,
                required String content,
                Value<int> pageCount = const Value.absent(),
                Value<int> charCount = const Value.absent(),
                required DateTime extractedAt,
                Value<int> rowid = const Value.absent(),
              }) => MaterialTextsCompanion.insert(
                itemId: itemId,
                content: content,
                pageCount: pageCount,
                charCount: charCount,
                extractedAt: extractedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MaterialTextsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (itemId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.itemId,
                                referencedTable: $$MaterialTextsTableReferences
                                    ._itemIdTable(db),
                                referencedColumn: $$MaterialTextsTableReferences
                                    ._itemIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MaterialTextsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MaterialTextsTable,
      MaterialTextRow,
      $$MaterialTextsTableFilterComposer,
      $$MaterialTextsTableOrderingComposer,
      $$MaterialTextsTableAnnotationComposer,
      $$MaterialTextsTableCreateCompanionBuilder,
      $$MaterialTextsTableUpdateCompanionBuilder,
      (MaterialTextRow, $$MaterialTextsTableReferences),
      MaterialTextRow,
      PrefetchHooks Function({bool itemId})
    >;
typedef $$QuizzesTableCreateCompanionBuilder =
    QuizzesCompanion Function({
      required String id,
      required String subjectId,
      Value<String?> topicId,
      required int currentQuestionIndex,
      Value<String?> sourceLabel,
      Value<bool> isAIGenerated,
      Value<int> rowid,
    });
typedef $$QuizzesTableUpdateCompanionBuilder =
    QuizzesCompanion Function({
      Value<String> id,
      Value<String> subjectId,
      Value<String?> topicId,
      Value<int> currentQuestionIndex,
      Value<String?> sourceLabel,
      Value<bool> isAIGenerated,
      Value<int> rowid,
    });

final class $$QuizzesTableReferences
    extends BaseReferences<_$AppDatabase, $QuizzesTable, QuizRow> {
  $$QuizzesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SubjectsTable _subjectIdTable(_$AppDatabase db) => db.subjects
      .createAlias($_aliasNameGenerator(db.quizzes.subjectId, db.subjects.id));

  $$SubjectsTableProcessedTableManager get subjectId {
    final $_column = $_itemColumn<String>('subject_id')!;

    final manager = $$SubjectsTableTableManager(
      $_db,
      $_db.subjects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TopicsTable _topicIdTable(_$AppDatabase db) => db.topics.createAlias(
    $_aliasNameGenerator(db.quizzes.topicId, db.topics.id),
  );

  $$TopicsTableProcessedTableManager? get topicId {
    final $_column = $_itemColumn<String>('topic_id');
    if ($_column == null) return null;
    final manager = $$TopicsTableTableManager(
      $_db,
      $_db.topics,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_topicIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$QuizQuestionsTable, List<QuizQuestionRow>>
  _quizQuestionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.quizQuestions,
    aliasName: $_aliasNameGenerator(db.quizzes.id, db.quizQuestions.quizId),
  );

  $$QuizQuestionsTableProcessedTableManager get quizQuestionsRefs {
    final manager = $$QuizQuestionsTableTableManager(
      $_db,
      $_db.quizQuestions,
    ).filter((f) => f.quizId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_quizQuestionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$QuizAttemptsTable, List<QuizAttemptRow>>
  _quizAttemptsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.quizAttempts,
    aliasName: $_aliasNameGenerator(db.quizzes.id, db.quizAttempts.quizId),
  );

  $$QuizAttemptsTableProcessedTableManager get quizAttemptsRefs {
    final manager = $$QuizAttemptsTableTableManager(
      $_db,
      $_db.quizAttempts,
    ).filter((f) => f.quizId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_quizAttemptsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$QuizzesTableFilterComposer
    extends Composer<_$AppDatabase, $QuizzesTable> {
  $$QuizzesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentQuestionIndex => $composableBuilder(
    column: $table.currentQuestionIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceLabel => $composableBuilder(
    column: $table.sourceLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAIGenerated => $composableBuilder(
    column: $table.isAIGenerated,
    builder: (column) => ColumnFilters(column),
  );

  $$SubjectsTableFilterComposer get subjectId {
    final $$SubjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableFilterComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TopicsTableFilterComposer get topicId {
    final $$TopicsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topicId,
      referencedTable: $db.topics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsTableFilterComposer(
            $db: $db,
            $table: $db.topics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> quizQuestionsRefs(
    Expression<bool> Function($$QuizQuestionsTableFilterComposer f) f,
  ) {
    final $$QuizQuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizQuestions,
      getReferencedColumn: (t) => t.quizId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizQuestionsTableFilterComposer(
            $db: $db,
            $table: $db.quizQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> quizAttemptsRefs(
    Expression<bool> Function($$QuizAttemptsTableFilterComposer f) f,
  ) {
    final $$QuizAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizAttempts,
      getReferencedColumn: (t) => t.quizId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.quizAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuizzesTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizzesTable> {
  $$QuizzesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentQuestionIndex => $composableBuilder(
    column: $table.currentQuestionIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceLabel => $composableBuilder(
    column: $table.sourceLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAIGenerated => $composableBuilder(
    column: $table.isAIGenerated,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubjectsTableOrderingComposer get subjectId {
    final $$SubjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableOrderingComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TopicsTableOrderingComposer get topicId {
    final $$TopicsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topicId,
      referencedTable: $db.topics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsTableOrderingComposer(
            $db: $db,
            $table: $db.topics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizzesTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizzesTable> {
  $$QuizzesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get currentQuestionIndex => $composableBuilder(
    column: $table.currentQuestionIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceLabel => $composableBuilder(
    column: $table.sourceLabel,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isAIGenerated => $composableBuilder(
    column: $table.isAIGenerated,
    builder: (column) => column,
  );

  $$SubjectsTableAnnotationComposer get subjectId {
    final $$SubjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TopicsTableAnnotationComposer get topicId {
    final $$TopicsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topicId,
      referencedTable: $db.topics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsTableAnnotationComposer(
            $db: $db,
            $table: $db.topics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> quizQuestionsRefs<T extends Object>(
    Expression<T> Function($$QuizQuestionsTableAnnotationComposer a) f,
  ) {
    final $$QuizQuestionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizQuestions,
      getReferencedColumn: (t) => t.quizId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizQuestionsTableAnnotationComposer(
            $db: $db,
            $table: $db.quizQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> quizAttemptsRefs<T extends Object>(
    Expression<T> Function($$QuizAttemptsTableAnnotationComposer a) f,
  ) {
    final $$QuizAttemptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizAttempts,
      getReferencedColumn: (t) => t.quizId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAttemptsTableAnnotationComposer(
            $db: $db,
            $table: $db.quizAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuizzesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizzesTable,
          QuizRow,
          $$QuizzesTableFilterComposer,
          $$QuizzesTableOrderingComposer,
          $$QuizzesTableAnnotationComposer,
          $$QuizzesTableCreateCompanionBuilder,
          $$QuizzesTableUpdateCompanionBuilder,
          (QuizRow, $$QuizzesTableReferences),
          QuizRow,
          PrefetchHooks Function({
            bool subjectId,
            bool topicId,
            bool quizQuestionsRefs,
            bool quizAttemptsRefs,
          })
        > {
  $$QuizzesTableTableManager(_$AppDatabase db, $QuizzesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizzesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizzesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizzesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> subjectId = const Value.absent(),
                Value<String?> topicId = const Value.absent(),
                Value<int> currentQuestionIndex = const Value.absent(),
                Value<String?> sourceLabel = const Value.absent(),
                Value<bool> isAIGenerated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizzesCompanion(
                id: id,
                subjectId: subjectId,
                topicId: topicId,
                currentQuestionIndex: currentQuestionIndex,
                sourceLabel: sourceLabel,
                isAIGenerated: isAIGenerated,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String subjectId,
                Value<String?> topicId = const Value.absent(),
                required int currentQuestionIndex,
                Value<String?> sourceLabel = const Value.absent(),
                Value<bool> isAIGenerated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizzesCompanion.insert(
                id: id,
                subjectId: subjectId,
                topicId: topicId,
                currentQuestionIndex: currentQuestionIndex,
                sourceLabel: sourceLabel,
                isAIGenerated: isAIGenerated,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuizzesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                subjectId = false,
                topicId = false,
                quizQuestionsRefs = false,
                quizAttemptsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (quizQuestionsRefs) db.quizQuestions,
                    if (quizAttemptsRefs) db.quizAttempts,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (subjectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.subjectId,
                                    referencedTable: $$QuizzesTableReferences
                                        ._subjectIdTable(db),
                                    referencedColumn: $$QuizzesTableReferences
                                        ._subjectIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (topicId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.topicId,
                                    referencedTable: $$QuizzesTableReferences
                                        ._topicIdTable(db),
                                    referencedColumn: $$QuizzesTableReferences
                                        ._topicIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (quizQuestionsRefs)
                        await $_getPrefetchedData<
                          QuizRow,
                          $QuizzesTable,
                          QuizQuestionRow
                        >(
                          currentTable: table,
                          referencedTable: $$QuizzesTableReferences
                              ._quizQuestionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuizzesTableReferences(
                                db,
                                table,
                                p0,
                              ).quizQuestionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.quizId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (quizAttemptsRefs)
                        await $_getPrefetchedData<
                          QuizRow,
                          $QuizzesTable,
                          QuizAttemptRow
                        >(
                          currentTable: table,
                          referencedTable: $$QuizzesTableReferences
                              ._quizAttemptsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuizzesTableReferences(
                                db,
                                table,
                                p0,
                              ).quizAttemptsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.quizId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$QuizzesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizzesTable,
      QuizRow,
      $$QuizzesTableFilterComposer,
      $$QuizzesTableOrderingComposer,
      $$QuizzesTableAnnotationComposer,
      $$QuizzesTableCreateCompanionBuilder,
      $$QuizzesTableUpdateCompanionBuilder,
      (QuizRow, $$QuizzesTableReferences),
      QuizRow,
      PrefetchHooks Function({
        bool subjectId,
        bool topicId,
        bool quizQuestionsRefs,
        bool quizAttemptsRefs,
      })
    >;
typedef $$QuizQuestionsTableCreateCompanionBuilder =
    QuizQuestionsCompanion Function({
      required String id,
      required String quizId,
      required int index,
      required String content,
      required QuestionType type,
      required int markValue,
      required List<String> options,
      Value<int?> correctAnswerIndex,
      Value<int?> timeLimit,
      Value<int> rowid,
    });
typedef $$QuizQuestionsTableUpdateCompanionBuilder =
    QuizQuestionsCompanion Function({
      Value<String> id,
      Value<String> quizId,
      Value<int> index,
      Value<String> content,
      Value<QuestionType> type,
      Value<int> markValue,
      Value<List<String>> options,
      Value<int?> correctAnswerIndex,
      Value<int?> timeLimit,
      Value<int> rowid,
    });

final class $$QuizQuestionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $QuizQuestionsTable, QuizQuestionRow> {
  $$QuizQuestionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $QuizzesTable _quizIdTable(_$AppDatabase db) => db.quizzes.createAlias(
    $_aliasNameGenerator(db.quizQuestions.quizId, db.quizzes.id),
  );

  $$QuizzesTableProcessedTableManager get quizId {
    final $_column = $_itemColumn<String>('quiz_id')!;

    final manager = $$QuizzesTableTableManager(
      $_db,
      $_db.quizzes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_quizIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$QuizAttemptsTable, List<QuizAttemptRow>>
  _quizAttemptsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.quizAttempts,
    aliasName: $_aliasNameGenerator(
      db.quizQuestions.id,
      db.quizAttempts.questionId,
    ),
  );

  $$QuizAttemptsTableProcessedTableManager get quizAttemptsRefs {
    final manager = $$QuizAttemptsTableTableManager(
      $_db,
      $_db.quizAttempts,
    ).filter((f) => f.questionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_quizAttemptsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$QuizFeedbackItemsTable, List<QuizFeedbackRow>>
  _quizFeedbackItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.quizFeedbackItems,
        aliasName: $_aliasNameGenerator(
          db.quizQuestions.id,
          db.quizFeedbackItems.questionId,
        ),
      );

  $$QuizFeedbackItemsTableProcessedTableManager get quizFeedbackItemsRefs {
    final manager = $$QuizFeedbackItemsTableTableManager(
      $_db,
      $_db.quizFeedbackItems,
    ).filter((f) => f.questionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _quizFeedbackItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$QuizQuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $QuizQuestionsTable> {
  $$QuizQuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get index => $composableBuilder(
    column: $table.index,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<QuestionType, QuestionType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get markValue => $composableBuilder(
    column: $table.markValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get options => $composableBuilder(
    column: $table.options,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get correctAnswerIndex => $composableBuilder(
    column: $table.correctAnswerIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeLimit => $composableBuilder(
    column: $table.timeLimit,
    builder: (column) => ColumnFilters(column),
  );

  $$QuizzesTableFilterComposer get quizId {
    final $$QuizzesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quizId,
      referencedTable: $db.quizzes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizzesTableFilterComposer(
            $db: $db,
            $table: $db.quizzes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> quizAttemptsRefs(
    Expression<bool> Function($$QuizAttemptsTableFilterComposer f) f,
  ) {
    final $$QuizAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizAttempts,
      getReferencedColumn: (t) => t.questionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.quizAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> quizFeedbackItemsRefs(
    Expression<bool> Function($$QuizFeedbackItemsTableFilterComposer f) f,
  ) {
    final $$QuizFeedbackItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizFeedbackItems,
      getReferencedColumn: (t) => t.questionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizFeedbackItemsTableFilterComposer(
            $db: $db,
            $table: $db.quizFeedbackItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuizQuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizQuestionsTable> {
  $$QuizQuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get index => $composableBuilder(
    column: $table.index,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get markValue => $composableBuilder(
    column: $table.markValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get options => $composableBuilder(
    column: $table.options,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctAnswerIndex => $composableBuilder(
    column: $table.correctAnswerIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeLimit => $composableBuilder(
    column: $table.timeLimit,
    builder: (column) => ColumnOrderings(column),
  );

  $$QuizzesTableOrderingComposer get quizId {
    final $$QuizzesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quizId,
      referencedTable: $db.quizzes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizzesTableOrderingComposer(
            $db: $db,
            $table: $db.quizzes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizQuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizQuestionsTable> {
  $$QuizQuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get index =>
      $composableBuilder(column: $table.index, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumnWithTypeConverter<QuestionType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get markValue =>
      $composableBuilder(column: $table.markValue, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get options =>
      $composableBuilder(column: $table.options, builder: (column) => column);

  GeneratedColumn<int> get correctAnswerIndex => $composableBuilder(
    column: $table.correctAnswerIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timeLimit =>
      $composableBuilder(column: $table.timeLimit, builder: (column) => column);

  $$QuizzesTableAnnotationComposer get quizId {
    final $$QuizzesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quizId,
      referencedTable: $db.quizzes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizzesTableAnnotationComposer(
            $db: $db,
            $table: $db.quizzes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> quizAttemptsRefs<T extends Object>(
    Expression<T> Function($$QuizAttemptsTableAnnotationComposer a) f,
  ) {
    final $$QuizAttemptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizAttempts,
      getReferencedColumn: (t) => t.questionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAttemptsTableAnnotationComposer(
            $db: $db,
            $table: $db.quizAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> quizFeedbackItemsRefs<T extends Object>(
    Expression<T> Function($$QuizFeedbackItemsTableAnnotationComposer a) f,
  ) {
    final $$QuizFeedbackItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.quizFeedbackItems,
          getReferencedColumn: (t) => t.questionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$QuizFeedbackItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.quizFeedbackItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$QuizQuestionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizQuestionsTable,
          QuizQuestionRow,
          $$QuizQuestionsTableFilterComposer,
          $$QuizQuestionsTableOrderingComposer,
          $$QuizQuestionsTableAnnotationComposer,
          $$QuizQuestionsTableCreateCompanionBuilder,
          $$QuizQuestionsTableUpdateCompanionBuilder,
          (QuizQuestionRow, $$QuizQuestionsTableReferences),
          QuizQuestionRow,
          PrefetchHooks Function({
            bool quizId,
            bool quizAttemptsRefs,
            bool quizFeedbackItemsRefs,
          })
        > {
  $$QuizQuestionsTableTableManager(_$AppDatabase db, $QuizQuestionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizQuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizQuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizQuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> quizId = const Value.absent(),
                Value<int> index = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<QuestionType> type = const Value.absent(),
                Value<int> markValue = const Value.absent(),
                Value<List<String>> options = const Value.absent(),
                Value<int?> correctAnswerIndex = const Value.absent(),
                Value<int?> timeLimit = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizQuestionsCompanion(
                id: id,
                quizId: quizId,
                index: index,
                content: content,
                type: type,
                markValue: markValue,
                options: options,
                correctAnswerIndex: correctAnswerIndex,
                timeLimit: timeLimit,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String quizId,
                required int index,
                required String content,
                required QuestionType type,
                required int markValue,
                required List<String> options,
                Value<int?> correctAnswerIndex = const Value.absent(),
                Value<int?> timeLimit = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizQuestionsCompanion.insert(
                id: id,
                quizId: quizId,
                index: index,
                content: content,
                type: type,
                markValue: markValue,
                options: options,
                correctAnswerIndex: correctAnswerIndex,
                timeLimit: timeLimit,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuizQuestionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                quizId = false,
                quizAttemptsRefs = false,
                quizFeedbackItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (quizAttemptsRefs) db.quizAttempts,
                    if (quizFeedbackItemsRefs) db.quizFeedbackItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (quizId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.quizId,
                                    referencedTable:
                                        $$QuizQuestionsTableReferences
                                            ._quizIdTable(db),
                                    referencedColumn:
                                        $$QuizQuestionsTableReferences
                                            ._quizIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (quizAttemptsRefs)
                        await $_getPrefetchedData<
                          QuizQuestionRow,
                          $QuizQuestionsTable,
                          QuizAttemptRow
                        >(
                          currentTable: table,
                          referencedTable: $$QuizQuestionsTableReferences
                              ._quizAttemptsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuizQuestionsTableReferences(
                                db,
                                table,
                                p0,
                              ).quizAttemptsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.questionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (quizFeedbackItemsRefs)
                        await $_getPrefetchedData<
                          QuizQuestionRow,
                          $QuizQuestionsTable,
                          QuizFeedbackRow
                        >(
                          currentTable: table,
                          referencedTable: $$QuizQuestionsTableReferences
                              ._quizFeedbackItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuizQuestionsTableReferences(
                                db,
                                table,
                                p0,
                              ).quizFeedbackItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.questionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$QuizQuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizQuestionsTable,
      QuizQuestionRow,
      $$QuizQuestionsTableFilterComposer,
      $$QuizQuestionsTableOrderingComposer,
      $$QuizQuestionsTableAnnotationComposer,
      $$QuizQuestionsTableCreateCompanionBuilder,
      $$QuizQuestionsTableUpdateCompanionBuilder,
      (QuizQuestionRow, $$QuizQuestionsTableReferences),
      QuizQuestionRow,
      PrefetchHooks Function({
        bool quizId,
        bool quizAttemptsRefs,
        bool quizFeedbackItemsRefs,
      })
    >;
typedef $$QuizAttemptsTableCreateCompanionBuilder =
    QuizAttemptsCompanion Function({
      required String id,
      required String quizId,
      required String userId,
      required String questionId,
      required DateTime timestamp,
      Value<int?> selectedAnswerIndex,
      Value<bool?> isCorrect,
      Value<int> rowid,
    });
typedef $$QuizAttemptsTableUpdateCompanionBuilder =
    QuizAttemptsCompanion Function({
      Value<String> id,
      Value<String> quizId,
      Value<String> userId,
      Value<String> questionId,
      Value<DateTime> timestamp,
      Value<int?> selectedAnswerIndex,
      Value<bool?> isCorrect,
      Value<int> rowid,
    });

final class $$QuizAttemptsTableReferences
    extends BaseReferences<_$AppDatabase, $QuizAttemptsTable, QuizAttemptRow> {
  $$QuizAttemptsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $QuizzesTable _quizIdTable(_$AppDatabase db) => db.quizzes.createAlias(
    $_aliasNameGenerator(db.quizAttempts.quizId, db.quizzes.id),
  );

  $$QuizzesTableProcessedTableManager get quizId {
    final $_column = $_itemColumn<String>('quiz_id')!;

    final manager = $$QuizzesTableTableManager(
      $_db,
      $_db.quizzes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_quizIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $QuizQuestionsTable _questionIdTable(_$AppDatabase db) =>
      db.quizQuestions.createAlias(
        $_aliasNameGenerator(db.quizAttempts.questionId, db.quizQuestions.id),
      );

  $$QuizQuestionsTableProcessedTableManager get questionId {
    final $_column = $_itemColumn<String>('question_id')!;

    final manager = $$QuizQuestionsTableTableManager(
      $_db,
      $_db.quizQuestions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_questionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$QuizFeedbackItemsTable, List<QuizFeedbackRow>>
  _quizFeedbackItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.quizFeedbackItems,
        aliasName: $_aliasNameGenerator(
          db.quizAttempts.id,
          db.quizFeedbackItems.attemptId,
        ),
      );

  $$QuizFeedbackItemsTableProcessedTableManager get quizFeedbackItemsRefs {
    final manager = $$QuizFeedbackItemsTableTableManager(
      $_db,
      $_db.quizFeedbackItems,
    ).filter((f) => f.attemptId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _quizFeedbackItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$QuizAttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $QuizAttemptsTable> {
  $$QuizAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get selectedAnswerIndex => $composableBuilder(
    column: $table.selectedAnswerIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnFilters(column),
  );

  $$QuizzesTableFilterComposer get quizId {
    final $$QuizzesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quizId,
      referencedTable: $db.quizzes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizzesTableFilterComposer(
            $db: $db,
            $table: $db.quizzes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$QuizQuestionsTableFilterComposer get questionId {
    final $$QuizQuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.quizQuestions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizQuestionsTableFilterComposer(
            $db: $db,
            $table: $db.quizQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> quizFeedbackItemsRefs(
    Expression<bool> Function($$QuizFeedbackItemsTableFilterComposer f) f,
  ) {
    final $$QuizFeedbackItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizFeedbackItems,
      getReferencedColumn: (t) => t.attemptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizFeedbackItemsTableFilterComposer(
            $db: $db,
            $table: $db.quizFeedbackItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuizAttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizAttemptsTable> {
  $$QuizAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get selectedAnswerIndex => $composableBuilder(
    column: $table.selectedAnswerIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  $$QuizzesTableOrderingComposer get quizId {
    final $$QuizzesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quizId,
      referencedTable: $db.quizzes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizzesTableOrderingComposer(
            $db: $db,
            $table: $db.quizzes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$QuizQuestionsTableOrderingComposer get questionId {
    final $$QuizQuestionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.quizQuestions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizQuestionsTableOrderingComposer(
            $db: $db,
            $table: $db.quizQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizAttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizAttemptsTable> {
  $$QuizAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<int> get selectedAnswerIndex => $composableBuilder(
    column: $table.selectedAnswerIndex,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  $$QuizzesTableAnnotationComposer get quizId {
    final $$QuizzesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quizId,
      referencedTable: $db.quizzes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizzesTableAnnotationComposer(
            $db: $db,
            $table: $db.quizzes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$QuizQuestionsTableAnnotationComposer get questionId {
    final $$QuizQuestionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.quizQuestions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizQuestionsTableAnnotationComposer(
            $db: $db,
            $table: $db.quizQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> quizFeedbackItemsRefs<T extends Object>(
    Expression<T> Function($$QuizFeedbackItemsTableAnnotationComposer a) f,
  ) {
    final $$QuizFeedbackItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.quizFeedbackItems,
          getReferencedColumn: (t) => t.attemptId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$QuizFeedbackItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.quizFeedbackItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$QuizAttemptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizAttemptsTable,
          QuizAttemptRow,
          $$QuizAttemptsTableFilterComposer,
          $$QuizAttemptsTableOrderingComposer,
          $$QuizAttemptsTableAnnotationComposer,
          $$QuizAttemptsTableCreateCompanionBuilder,
          $$QuizAttemptsTableUpdateCompanionBuilder,
          (QuizAttemptRow, $$QuizAttemptsTableReferences),
          QuizAttemptRow,
          PrefetchHooks Function({
            bool quizId,
            bool questionId,
            bool quizFeedbackItemsRefs,
          })
        > {
  $$QuizAttemptsTableTableManager(_$AppDatabase db, $QuizAttemptsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> quizId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> questionId = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int?> selectedAnswerIndex = const Value.absent(),
                Value<bool?> isCorrect = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizAttemptsCompanion(
                id: id,
                quizId: quizId,
                userId: userId,
                questionId: questionId,
                timestamp: timestamp,
                selectedAnswerIndex: selectedAnswerIndex,
                isCorrect: isCorrect,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String quizId,
                required String userId,
                required String questionId,
                required DateTime timestamp,
                Value<int?> selectedAnswerIndex = const Value.absent(),
                Value<bool?> isCorrect = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizAttemptsCompanion.insert(
                id: id,
                quizId: quizId,
                userId: userId,
                questionId: questionId,
                timestamp: timestamp,
                selectedAnswerIndex: selectedAnswerIndex,
                isCorrect: isCorrect,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuizAttemptsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                quizId = false,
                questionId = false,
                quizFeedbackItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (quizFeedbackItemsRefs) db.quizFeedbackItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (quizId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.quizId,
                                    referencedTable:
                                        $$QuizAttemptsTableReferences
                                            ._quizIdTable(db),
                                    referencedColumn:
                                        $$QuizAttemptsTableReferences
                                            ._quizIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (questionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.questionId,
                                    referencedTable:
                                        $$QuizAttemptsTableReferences
                                            ._questionIdTable(db),
                                    referencedColumn:
                                        $$QuizAttemptsTableReferences
                                            ._questionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (quizFeedbackItemsRefs)
                        await $_getPrefetchedData<
                          QuizAttemptRow,
                          $QuizAttemptsTable,
                          QuizFeedbackRow
                        >(
                          currentTable: table,
                          referencedTable: $$QuizAttemptsTableReferences
                              ._quizFeedbackItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuizAttemptsTableReferences(
                                db,
                                table,
                                p0,
                              ).quizFeedbackItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.attemptId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$QuizAttemptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizAttemptsTable,
      QuizAttemptRow,
      $$QuizAttemptsTableFilterComposer,
      $$QuizAttemptsTableOrderingComposer,
      $$QuizAttemptsTableAnnotationComposer,
      $$QuizAttemptsTableCreateCompanionBuilder,
      $$QuizAttemptsTableUpdateCompanionBuilder,
      (QuizAttemptRow, $$QuizAttemptsTableReferences),
      QuizAttemptRow,
      PrefetchHooks Function({
        bool quizId,
        bool questionId,
        bool quizFeedbackItemsRefs,
      })
    >;
typedef $$QuizFeedbackItemsTableCreateCompanionBuilder =
    QuizFeedbackItemsCompanion Function({
      required String id,
      required String attemptId,
      required String questionId,
      required bool isCorrect,
      required String feedbackText,
      Value<String?> explanation,
      Value<int> rowid,
    });
typedef $$QuizFeedbackItemsTableUpdateCompanionBuilder =
    QuizFeedbackItemsCompanion Function({
      Value<String> id,
      Value<String> attemptId,
      Value<String> questionId,
      Value<bool> isCorrect,
      Value<String> feedbackText,
      Value<String?> explanation,
      Value<int> rowid,
    });

final class $$QuizFeedbackItemsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $QuizFeedbackItemsTable,
          QuizFeedbackRow
        > {
  $$QuizFeedbackItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $QuizAttemptsTable _attemptIdTable(_$AppDatabase db) =>
      db.quizAttempts.createAlias(
        $_aliasNameGenerator(
          db.quizFeedbackItems.attemptId,
          db.quizAttempts.id,
        ),
      );

  $$QuizAttemptsTableProcessedTableManager get attemptId {
    final $_column = $_itemColumn<String>('attempt_id')!;

    final manager = $$QuizAttemptsTableTableManager(
      $_db,
      $_db.quizAttempts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_attemptIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $QuizQuestionsTable _questionIdTable(_$AppDatabase db) =>
      db.quizQuestions.createAlias(
        $_aliasNameGenerator(
          db.quizFeedbackItems.questionId,
          db.quizQuestions.id,
        ),
      );

  $$QuizQuestionsTableProcessedTableManager get questionId {
    final $_column = $_itemColumn<String>('question_id')!;

    final manager = $$QuizQuestionsTableTableManager(
      $_db,
      $_db.quizQuestions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_questionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QuizFeedbackItemsTableFilterComposer
    extends Composer<_$AppDatabase, $QuizFeedbackItemsTable> {
  $$QuizFeedbackItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get feedbackText => $composableBuilder(
    column: $table.feedbackText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnFilters(column),
  );

  $$QuizAttemptsTableFilterComposer get attemptId {
    final $$QuizAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.quizAttempts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.quizAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$QuizQuestionsTableFilterComposer get questionId {
    final $$QuizQuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.quizQuestions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizQuestionsTableFilterComposer(
            $db: $db,
            $table: $db.quizQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizFeedbackItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizFeedbackItemsTable> {
  $$QuizFeedbackItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get feedbackText => $composableBuilder(
    column: $table.feedbackText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnOrderings(column),
  );

  $$QuizAttemptsTableOrderingComposer get attemptId {
    final $$QuizAttemptsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.quizAttempts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAttemptsTableOrderingComposer(
            $db: $db,
            $table: $db.quizAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$QuizQuestionsTableOrderingComposer get questionId {
    final $$QuizQuestionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.quizQuestions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizQuestionsTableOrderingComposer(
            $db: $db,
            $table: $db.quizQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizFeedbackItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizFeedbackItemsTable> {
  $$QuizFeedbackItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  GeneratedColumn<String> get feedbackText => $composableBuilder(
    column: $table.feedbackText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => column,
  );

  $$QuizAttemptsTableAnnotationComposer get attemptId {
    final $$QuizAttemptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.quizAttempts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAttemptsTableAnnotationComposer(
            $db: $db,
            $table: $db.quizAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$QuizQuestionsTableAnnotationComposer get questionId {
    final $$QuizQuestionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.quizQuestions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizQuestionsTableAnnotationComposer(
            $db: $db,
            $table: $db.quizQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizFeedbackItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizFeedbackItemsTable,
          QuizFeedbackRow,
          $$QuizFeedbackItemsTableFilterComposer,
          $$QuizFeedbackItemsTableOrderingComposer,
          $$QuizFeedbackItemsTableAnnotationComposer,
          $$QuizFeedbackItemsTableCreateCompanionBuilder,
          $$QuizFeedbackItemsTableUpdateCompanionBuilder,
          (QuizFeedbackRow, $$QuizFeedbackItemsTableReferences),
          QuizFeedbackRow,
          PrefetchHooks Function({bool attemptId, bool questionId})
        > {
  $$QuizFeedbackItemsTableTableManager(
    _$AppDatabase db,
    $QuizFeedbackItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizFeedbackItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizFeedbackItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizFeedbackItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> attemptId = const Value.absent(),
                Value<String> questionId = const Value.absent(),
                Value<bool> isCorrect = const Value.absent(),
                Value<String> feedbackText = const Value.absent(),
                Value<String?> explanation = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizFeedbackItemsCompanion(
                id: id,
                attemptId: attemptId,
                questionId: questionId,
                isCorrect: isCorrect,
                feedbackText: feedbackText,
                explanation: explanation,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String attemptId,
                required String questionId,
                required bool isCorrect,
                required String feedbackText,
                Value<String?> explanation = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizFeedbackItemsCompanion.insert(
                id: id,
                attemptId: attemptId,
                questionId: questionId,
                isCorrect: isCorrect,
                feedbackText: feedbackText,
                explanation: explanation,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuizFeedbackItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({attemptId = false, questionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (attemptId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.attemptId,
                                referencedTable:
                                    $$QuizFeedbackItemsTableReferences
                                        ._attemptIdTable(db),
                                referencedColumn:
                                    $$QuizFeedbackItemsTableReferences
                                        ._attemptIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (questionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.questionId,
                                referencedTable:
                                    $$QuizFeedbackItemsTableReferences
                                        ._questionIdTable(db),
                                referencedColumn:
                                    $$QuizFeedbackItemsTableReferences
                                        ._questionIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$QuizFeedbackItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizFeedbackItemsTable,
      QuizFeedbackRow,
      $$QuizFeedbackItemsTableFilterComposer,
      $$QuizFeedbackItemsTableOrderingComposer,
      $$QuizFeedbackItemsTableAnnotationComposer,
      $$QuizFeedbackItemsTableCreateCompanionBuilder,
      $$QuizFeedbackItemsTableUpdateCompanionBuilder,
      (QuizFeedbackRow, $$QuizFeedbackItemsTableReferences),
      QuizFeedbackRow,
      PrefetchHooks Function({bool attemptId, bool questionId})
    >;
typedef $$ProgressMetricsTableCreateCompanionBuilder =
    ProgressMetricsCompanion Function({
      required String userId,
      required String subjectId,
      required int readinessScore,
      required DateTime lastUpdatedAt,
      Value<int?> predictedScoreMin,
      Value<int?> predictedScoreMax,
      Value<int?> weeklyGain,
      Value<String?> aiInsight,
      Value<int> rowid,
    });
typedef $$ProgressMetricsTableUpdateCompanionBuilder =
    ProgressMetricsCompanion Function({
      Value<String> userId,
      Value<String> subjectId,
      Value<int> readinessScore,
      Value<DateTime> lastUpdatedAt,
      Value<int?> predictedScoreMin,
      Value<int?> predictedScoreMax,
      Value<int?> weeklyGain,
      Value<String?> aiInsight,
      Value<int> rowid,
    });

final class $$ProgressMetricsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ProgressMetricsTable,
          ProgressMetricRow
        > {
  $$ProgressMetricsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SubjectsTable _subjectIdTable(_$AppDatabase db) =>
      db.subjects.createAlias(
        $_aliasNameGenerator(db.progressMetrics.subjectId, db.subjects.id),
      );

  $$SubjectsTableProcessedTableManager get subjectId {
    final $_column = $_itemColumn<String>('subject_id')!;

    final manager = $$SubjectsTableTableManager(
      $_db,
      $_db.subjects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProgressMetricsTableFilterComposer
    extends Composer<_$AppDatabase, $ProgressMetricsTable> {
  $$ProgressMetricsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get readinessScore => $composableBuilder(
    column: $table.readinessScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get predictedScoreMin => $composableBuilder(
    column: $table.predictedScoreMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get predictedScoreMax => $composableBuilder(
    column: $table.predictedScoreMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weeklyGain => $composableBuilder(
    column: $table.weeklyGain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiInsight => $composableBuilder(
    column: $table.aiInsight,
    builder: (column) => ColumnFilters(column),
  );

  $$SubjectsTableFilterComposer get subjectId {
    final $$SubjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableFilterComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProgressMetricsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgressMetricsTable> {
  $$ProgressMetricsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get readinessScore => $composableBuilder(
    column: $table.readinessScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get predictedScoreMin => $composableBuilder(
    column: $table.predictedScoreMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get predictedScoreMax => $composableBuilder(
    column: $table.predictedScoreMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weeklyGain => $composableBuilder(
    column: $table.weeklyGain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiInsight => $composableBuilder(
    column: $table.aiInsight,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubjectsTableOrderingComposer get subjectId {
    final $$SubjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableOrderingComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProgressMetricsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgressMetricsTable> {
  $$ProgressMetricsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get readinessScore => $composableBuilder(
    column: $table.readinessScore,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get predictedScoreMin => $composableBuilder(
    column: $table.predictedScoreMin,
    builder: (column) => column,
  );

  GeneratedColumn<int> get predictedScoreMax => $composableBuilder(
    column: $table.predictedScoreMax,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weeklyGain => $composableBuilder(
    column: $table.weeklyGain,
    builder: (column) => column,
  );

  GeneratedColumn<String> get aiInsight =>
      $composableBuilder(column: $table.aiInsight, builder: (column) => column);

  $$SubjectsTableAnnotationComposer get subjectId {
    final $$SubjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProgressMetricsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProgressMetricsTable,
          ProgressMetricRow,
          $$ProgressMetricsTableFilterComposer,
          $$ProgressMetricsTableOrderingComposer,
          $$ProgressMetricsTableAnnotationComposer,
          $$ProgressMetricsTableCreateCompanionBuilder,
          $$ProgressMetricsTableUpdateCompanionBuilder,
          (ProgressMetricRow, $$ProgressMetricsTableReferences),
          ProgressMetricRow,
          PrefetchHooks Function({bool subjectId})
        > {
  $$ProgressMetricsTableTableManager(
    _$AppDatabase db,
    $ProgressMetricsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgressMetricsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgressMetricsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgressMetricsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> subjectId = const Value.absent(),
                Value<int> readinessScore = const Value.absent(),
                Value<DateTime> lastUpdatedAt = const Value.absent(),
                Value<int?> predictedScoreMin = const Value.absent(),
                Value<int?> predictedScoreMax = const Value.absent(),
                Value<int?> weeklyGain = const Value.absent(),
                Value<String?> aiInsight = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgressMetricsCompanion(
                userId: userId,
                subjectId: subjectId,
                readinessScore: readinessScore,
                lastUpdatedAt: lastUpdatedAt,
                predictedScoreMin: predictedScoreMin,
                predictedScoreMax: predictedScoreMax,
                weeklyGain: weeklyGain,
                aiInsight: aiInsight,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String subjectId,
                required int readinessScore,
                required DateTime lastUpdatedAt,
                Value<int?> predictedScoreMin = const Value.absent(),
                Value<int?> predictedScoreMax = const Value.absent(),
                Value<int?> weeklyGain = const Value.absent(),
                Value<String?> aiInsight = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgressMetricsCompanion.insert(
                userId: userId,
                subjectId: subjectId,
                readinessScore: readinessScore,
                lastUpdatedAt: lastUpdatedAt,
                predictedScoreMin: predictedScoreMin,
                predictedScoreMax: predictedScoreMax,
                weeklyGain: weeklyGain,
                aiInsight: aiInsight,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProgressMetricsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({subjectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (subjectId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.subjectId,
                                referencedTable:
                                    $$ProgressMetricsTableReferences
                                        ._subjectIdTable(db),
                                referencedColumn:
                                    $$ProgressMetricsTableReferences
                                        ._subjectIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProgressMetricsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProgressMetricsTable,
      ProgressMetricRow,
      $$ProgressMetricsTableFilterComposer,
      $$ProgressMetricsTableOrderingComposer,
      $$ProgressMetricsTableAnnotationComposer,
      $$ProgressMetricsTableCreateCompanionBuilder,
      $$ProgressMetricsTableUpdateCompanionBuilder,
      (ProgressMetricRow, $$ProgressMetricsTableReferences),
      ProgressMetricRow,
      PrefetchHooks Function({bool subjectId})
    >;
typedef $$StudyStreaksTableCreateCompanionBuilder =
    StudyStreaksCompanion Function({
      required String userId,
      required int dayCount,
      required DateTime lastStudiedDate,
      required DateTime startDate,
      Value<int> rowid,
    });
typedef $$StudyStreaksTableUpdateCompanionBuilder =
    StudyStreaksCompanion Function({
      Value<String> userId,
      Value<int> dayCount,
      Value<DateTime> lastStudiedDate,
      Value<DateTime> startDate,
      Value<int> rowid,
    });

class $$StudyStreaksTableFilterComposer
    extends Composer<_$AppDatabase, $StudyStreaksTable> {
  $$StudyStreaksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayCount => $composableBuilder(
    column: $table.dayCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastStudiedDate => $composableBuilder(
    column: $table.lastStudiedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StudyStreaksTableOrderingComposer
    extends Composer<_$AppDatabase, $StudyStreaksTable> {
  $$StudyStreaksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayCount => $composableBuilder(
    column: $table.dayCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastStudiedDate => $composableBuilder(
    column: $table.lastStudiedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudyStreaksTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudyStreaksTable> {
  $$StudyStreaksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get dayCount =>
      $composableBuilder(column: $table.dayCount, builder: (column) => column);

  GeneratedColumn<DateTime> get lastStudiedDate => $composableBuilder(
    column: $table.lastStudiedDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);
}

class $$StudyStreaksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudyStreaksTable,
          StudyStreakRow,
          $$StudyStreaksTableFilterComposer,
          $$StudyStreaksTableOrderingComposer,
          $$StudyStreaksTableAnnotationComposer,
          $$StudyStreaksTableCreateCompanionBuilder,
          $$StudyStreaksTableUpdateCompanionBuilder,
          (
            StudyStreakRow,
            BaseReferences<_$AppDatabase, $StudyStreaksTable, StudyStreakRow>,
          ),
          StudyStreakRow,
          PrefetchHooks Function()
        > {
  $$StudyStreaksTableTableManager(_$AppDatabase db, $StudyStreaksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudyStreaksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudyStreaksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudyStreaksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<int> dayCount = const Value.absent(),
                Value<DateTime> lastStudiedDate = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyStreaksCompanion(
                userId: userId,
                dayCount: dayCount,
                lastStudiedDate: lastStudiedDate,
                startDate: startDate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required int dayCount,
                required DateTime lastStudiedDate,
                required DateTime startDate,
                Value<int> rowid = const Value.absent(),
              }) => StudyStreaksCompanion.insert(
                userId: userId,
                dayCount: dayCount,
                lastStudiedDate: lastStudiedDate,
                startDate: startDate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StudyStreaksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudyStreaksTable,
      StudyStreakRow,
      $$StudyStreaksTableFilterComposer,
      $$StudyStreaksTableOrderingComposer,
      $$StudyStreaksTableAnnotationComposer,
      $$StudyStreaksTableCreateCompanionBuilder,
      $$StudyStreaksTableUpdateCompanionBuilder,
      (
        StudyStreakRow,
        BaseReferences<_$AppDatabase, $StudyStreaksTable, StudyStreakRow>,
      ),
      StudyStreakRow,
      PrefetchHooks Function()
    >;
typedef $$DailyScoresTableCreateCompanionBuilder =
    DailyScoresCompanion Function({
      Value<int> id,
      required String userId,
      required DateTime date,
      required int score,
      Value<String?> topicId,
    });
typedef $$DailyScoresTableUpdateCompanionBuilder =
    DailyScoresCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<DateTime> date,
      Value<int> score,
      Value<String?> topicId,
    });

final class $$DailyScoresTableReferences
    extends BaseReferences<_$AppDatabase, $DailyScoresTable, DailyScoreRow> {
  $$DailyScoresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TopicsTable _topicIdTable(_$AppDatabase db) => db.topics.createAlias(
    $_aliasNameGenerator(db.dailyScores.topicId, db.topics.id),
  );

  $$TopicsTableProcessedTableManager? get topicId {
    final $_column = $_itemColumn<String>('topic_id');
    if ($_column == null) return null;
    final manager = $$TopicsTableTableManager(
      $_db,
      $_db.topics,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_topicIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DailyScoresTableFilterComposer
    extends Composer<_$AppDatabase, $DailyScoresTable> {
  $$DailyScoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  $$TopicsTableFilterComposer get topicId {
    final $$TopicsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topicId,
      referencedTable: $db.topics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsTableFilterComposer(
            $db: $db,
            $table: $db.topics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyScoresTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyScoresTable> {
  $$DailyScoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  $$TopicsTableOrderingComposer get topicId {
    final $$TopicsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topicId,
      referencedTable: $db.topics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsTableOrderingComposer(
            $db: $db,
            $table: $db.topics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyScoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyScoresTable> {
  $$DailyScoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  $$TopicsTableAnnotationComposer get topicId {
    final $$TopicsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topicId,
      referencedTable: $db.topics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsTableAnnotationComposer(
            $db: $db,
            $table: $db.topics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyScoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyScoresTable,
          DailyScoreRow,
          $$DailyScoresTableFilterComposer,
          $$DailyScoresTableOrderingComposer,
          $$DailyScoresTableAnnotationComposer,
          $$DailyScoresTableCreateCompanionBuilder,
          $$DailyScoresTableUpdateCompanionBuilder,
          (DailyScoreRow, $$DailyScoresTableReferences),
          DailyScoreRow,
          PrefetchHooks Function({bool topicId})
        > {
  $$DailyScoresTableTableManager(_$AppDatabase db, $DailyScoresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyScoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyScoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyScoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<String?> topicId = const Value.absent(),
              }) => DailyScoresCompanion(
                id: id,
                userId: userId,
                date: date,
                score: score,
                topicId: topicId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                required DateTime date,
                required int score,
                Value<String?> topicId = const Value.absent(),
              }) => DailyScoresCompanion.insert(
                id: id,
                userId: userId,
                date: date,
                score: score,
                topicId: topicId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DailyScoresTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({topicId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (topicId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.topicId,
                                referencedTable: $$DailyScoresTableReferences
                                    ._topicIdTable(db),
                                referencedColumn: $$DailyScoresTableReferences
                                    ._topicIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DailyScoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyScoresTable,
      DailyScoreRow,
      $$DailyScoresTableFilterComposer,
      $$DailyScoresTableOrderingComposer,
      $$DailyScoresTableAnnotationComposer,
      $$DailyScoresTableCreateCompanionBuilder,
      $$DailyScoresTableUpdateCompanionBuilder,
      (DailyScoreRow, $$DailyScoresTableReferences),
      DailyScoreRow,
      PrefetchHooks Function({bool topicId})
    >;
typedef $$SessionMetricsTableCreateCompanionBuilder =
    SessionMetricsCompanion Function({
      Value<int> id,
      required String userId,
      required DateTime date,
      required int durationMinutes,
      required String topicIds,
    });
typedef $$SessionMetricsTableUpdateCompanionBuilder =
    SessionMetricsCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<DateTime> date,
      Value<int> durationMinutes,
      Value<String> topicIds,
    });

class $$SessionMetricsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionMetricsTable> {
  $$SessionMetricsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topicIds => $composableBuilder(
    column: $table.topicIds,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionMetricsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionMetricsTable> {
  $$SessionMetricsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topicIds => $composableBuilder(
    column: $table.topicIds,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionMetricsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionMetricsTable> {
  $$SessionMetricsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get topicIds =>
      $composableBuilder(column: $table.topicIds, builder: (column) => column);
}

class $$SessionMetricsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionMetricsTable,
          SessionMetricRow,
          $$SessionMetricsTableFilterComposer,
          $$SessionMetricsTableOrderingComposer,
          $$SessionMetricsTableAnnotationComposer,
          $$SessionMetricsTableCreateCompanionBuilder,
          $$SessionMetricsTableUpdateCompanionBuilder,
          (
            SessionMetricRow,
            BaseReferences<
              _$AppDatabase,
              $SessionMetricsTable,
              SessionMetricRow
            >,
          ),
          SessionMetricRow,
          PrefetchHooks Function()
        > {
  $$SessionMetricsTableTableManager(
    _$AppDatabase db,
    $SessionMetricsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionMetricsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionMetricsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionMetricsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<String> topicIds = const Value.absent(),
              }) => SessionMetricsCompanion(
                id: id,
                userId: userId,
                date: date,
                durationMinutes: durationMinutes,
                topicIds: topicIds,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                required DateTime date,
                required int durationMinutes,
                required String topicIds,
              }) => SessionMetricsCompanion.insert(
                id: id,
                userId: userId,
                date: date,
                durationMinutes: durationMinutes,
                topicIds: topicIds,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionMetricsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionMetricsTable,
      SessionMetricRow,
      $$SessionMetricsTableFilterComposer,
      $$SessionMetricsTableOrderingComposer,
      $$SessionMetricsTableAnnotationComposer,
      $$SessionMetricsTableCreateCompanionBuilder,
      $$SessionMetricsTableUpdateCompanionBuilder,
      (
        SessionMetricRow,
        BaseReferences<_$AppDatabase, $SessionMetricsTable, SessionMetricRow>,
      ),
      SessionMetricRow,
      PrefetchHooks Function()
    >;
typedef $$TutorConversationsTableCreateCompanionBuilder =
    TutorConversationsCompanion Function({
      required String id,
      required String userId,
      required String subjectId,
      Value<String?> topicId,
      Value<String?> title,
      required int groundedSourceCount,
      required DateTime createdAt,
      required DateTime lastMessageAt,
      Value<int> rowid,
    });
typedef $$TutorConversationsTableUpdateCompanionBuilder =
    TutorConversationsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> subjectId,
      Value<String?> topicId,
      Value<String?> title,
      Value<int> groundedSourceCount,
      Value<DateTime> createdAt,
      Value<DateTime> lastMessageAt,
      Value<int> rowid,
    });

final class $$TutorConversationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TutorConversationsTable,
          TutorConversationRow
        > {
  $$TutorConversationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SubjectsTable _subjectIdTable(_$AppDatabase db) =>
      db.subjects.createAlias(
        $_aliasNameGenerator(db.tutorConversations.subjectId, db.subjects.id),
      );

  $$SubjectsTableProcessedTableManager get subjectId {
    final $_column = $_itemColumn<String>('subject_id')!;

    final manager = $$SubjectsTableTableManager(
      $_db,
      $_db.subjects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TopicsTable _topicIdTable(_$AppDatabase db) => db.topics.createAlias(
    $_aliasNameGenerator(db.tutorConversations.topicId, db.topics.id),
  );

  $$TopicsTableProcessedTableManager? get topicId {
    final $_column = $_itemColumn<String>('topic_id');
    if ($_column == null) return null;
    final manager = $$TopicsTableTableManager(
      $_db,
      $_db.topics,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_topicIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TutorMessagesTable, List<TutorMessageRow>>
  _tutorMessagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.tutorMessages,
    aliasName: $_aliasNameGenerator(
      db.tutorConversations.id,
      db.tutorMessages.conversationId,
    ),
  );

  $$TutorMessagesTableProcessedTableManager get tutorMessagesRefs {
    final manager = $$TutorMessagesTableTableManager(
      $_db,
      $_db.tutorMessages,
    ).filter((f) => f.conversationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tutorMessagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TutorConversationsTableFilterComposer
    extends Composer<_$AppDatabase, $TutorConversationsTable> {
  $$TutorConversationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get groundedSourceCount => $composableBuilder(
    column: $table.groundedSourceCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastMessageAt => $composableBuilder(
    column: $table.lastMessageAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SubjectsTableFilterComposer get subjectId {
    final $$SubjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableFilterComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TopicsTableFilterComposer get topicId {
    final $$TopicsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topicId,
      referencedTable: $db.topics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsTableFilterComposer(
            $db: $db,
            $table: $db.topics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> tutorMessagesRefs(
    Expression<bool> Function($$TutorMessagesTableFilterComposer f) f,
  ) {
    final $$TutorMessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tutorMessages,
      getReferencedColumn: (t) => t.conversationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TutorMessagesTableFilterComposer(
            $db: $db,
            $table: $db.tutorMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TutorConversationsTableOrderingComposer
    extends Composer<_$AppDatabase, $TutorConversationsTable> {
  $$TutorConversationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get groundedSourceCount => $composableBuilder(
    column: $table.groundedSourceCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastMessageAt => $composableBuilder(
    column: $table.lastMessageAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubjectsTableOrderingComposer get subjectId {
    final $$SubjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableOrderingComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TopicsTableOrderingComposer get topicId {
    final $$TopicsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topicId,
      referencedTable: $db.topics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsTableOrderingComposer(
            $db: $db,
            $table: $db.topics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TutorConversationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TutorConversationsTable> {
  $$TutorConversationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get groundedSourceCount => $composableBuilder(
    column: $table.groundedSourceCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastMessageAt => $composableBuilder(
    column: $table.lastMessageAt,
    builder: (column) => column,
  );

  $$SubjectsTableAnnotationComposer get subjectId {
    final $$SubjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TopicsTableAnnotationComposer get topicId {
    final $$TopicsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.topicId,
      referencedTable: $db.topics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TopicsTableAnnotationComposer(
            $db: $db,
            $table: $db.topics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> tutorMessagesRefs<T extends Object>(
    Expression<T> Function($$TutorMessagesTableAnnotationComposer a) f,
  ) {
    final $$TutorMessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tutorMessages,
      getReferencedColumn: (t) => t.conversationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TutorMessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.tutorMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TutorConversationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TutorConversationsTable,
          TutorConversationRow,
          $$TutorConversationsTableFilterComposer,
          $$TutorConversationsTableOrderingComposer,
          $$TutorConversationsTableAnnotationComposer,
          $$TutorConversationsTableCreateCompanionBuilder,
          $$TutorConversationsTableUpdateCompanionBuilder,
          (TutorConversationRow, $$TutorConversationsTableReferences),
          TutorConversationRow,
          PrefetchHooks Function({
            bool subjectId,
            bool topicId,
            bool tutorMessagesRefs,
          })
        > {
  $$TutorConversationsTableTableManager(
    _$AppDatabase db,
    $TutorConversationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TutorConversationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TutorConversationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TutorConversationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> subjectId = const Value.absent(),
                Value<String?> topicId = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<int> groundedSourceCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastMessageAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TutorConversationsCompanion(
                id: id,
                userId: userId,
                subjectId: subjectId,
                topicId: topicId,
                title: title,
                groundedSourceCount: groundedSourceCount,
                createdAt: createdAt,
                lastMessageAt: lastMessageAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String subjectId,
                Value<String?> topicId = const Value.absent(),
                Value<String?> title = const Value.absent(),
                required int groundedSourceCount,
                required DateTime createdAt,
                required DateTime lastMessageAt,
                Value<int> rowid = const Value.absent(),
              }) => TutorConversationsCompanion.insert(
                id: id,
                userId: userId,
                subjectId: subjectId,
                topicId: topicId,
                title: title,
                groundedSourceCount: groundedSourceCount,
                createdAt: createdAt,
                lastMessageAt: lastMessageAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TutorConversationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                subjectId = false,
                topicId = false,
                tutorMessagesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (tutorMessagesRefs) db.tutorMessages,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (subjectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.subjectId,
                                    referencedTable:
                                        $$TutorConversationsTableReferences
                                            ._subjectIdTable(db),
                                    referencedColumn:
                                        $$TutorConversationsTableReferences
                                            ._subjectIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (topicId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.topicId,
                                    referencedTable:
                                        $$TutorConversationsTableReferences
                                            ._topicIdTable(db),
                                    referencedColumn:
                                        $$TutorConversationsTableReferences
                                            ._topicIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (tutorMessagesRefs)
                        await $_getPrefetchedData<
                          TutorConversationRow,
                          $TutorConversationsTable,
                          TutorMessageRow
                        >(
                          currentTable: table,
                          referencedTable: $$TutorConversationsTableReferences
                              ._tutorMessagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TutorConversationsTableReferences(
                                db,
                                table,
                                p0,
                              ).tutorMessagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.conversationId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TutorConversationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TutorConversationsTable,
      TutorConversationRow,
      $$TutorConversationsTableFilterComposer,
      $$TutorConversationsTableOrderingComposer,
      $$TutorConversationsTableAnnotationComposer,
      $$TutorConversationsTableCreateCompanionBuilder,
      $$TutorConversationsTableUpdateCompanionBuilder,
      (TutorConversationRow, $$TutorConversationsTableReferences),
      TutorConversationRow,
      PrefetchHooks Function({
        bool subjectId,
        bool topicId,
        bool tutorMessagesRefs,
      })
    >;
typedef $$TutorMessagesTableCreateCompanionBuilder =
    TutorMessagesCompanion Function({
      required String id,
      required String conversationId,
      required MessageSender sender,
      required String content,
      required DateTime timestamp,
      required List<FollowUpPoint> followUpPoints,
      required List<Citation> citations,
      Value<String?> kickerQuestion,
      Value<int> rowid,
    });
typedef $$TutorMessagesTableUpdateCompanionBuilder =
    TutorMessagesCompanion Function({
      Value<String> id,
      Value<String> conversationId,
      Value<MessageSender> sender,
      Value<String> content,
      Value<DateTime> timestamp,
      Value<List<FollowUpPoint>> followUpPoints,
      Value<List<Citation>> citations,
      Value<String?> kickerQuestion,
      Value<int> rowid,
    });

final class $$TutorMessagesTableReferences
    extends
        BaseReferences<_$AppDatabase, $TutorMessagesTable, TutorMessageRow> {
  $$TutorMessagesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TutorConversationsTable _conversationIdTable(_$AppDatabase db) =>
      db.tutorConversations.createAlias(
        $_aliasNameGenerator(
          db.tutorMessages.conversationId,
          db.tutorConversations.id,
        ),
      );

  $$TutorConversationsTableProcessedTableManager get conversationId {
    final $_column = $_itemColumn<String>('conversation_id')!;

    final manager = $$TutorConversationsTableTableManager(
      $_db,
      $_db.tutorConversations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_conversationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TutorMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $TutorMessagesTable> {
  $$TutorMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MessageSender, MessageSender, String>
  get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    List<FollowUpPoint>,
    List<FollowUpPoint>,
    String
  >
  get followUpPoints => $composableBuilder(
    column: $table.followUpPoints,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<Citation>, List<Citation>, String>
  get citations => $composableBuilder(
    column: $table.citations,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get kickerQuestion => $composableBuilder(
    column: $table.kickerQuestion,
    builder: (column) => ColumnFilters(column),
  );

  $$TutorConversationsTableFilterComposer get conversationId {
    final $$TutorConversationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.conversationId,
      referencedTable: $db.tutorConversations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TutorConversationsTableFilterComposer(
            $db: $db,
            $table: $db.tutorConversations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TutorMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $TutorMessagesTable> {
  $$TutorMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get followUpPoints => $composableBuilder(
    column: $table.followUpPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get citations => $composableBuilder(
    column: $table.citations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kickerQuestion => $composableBuilder(
    column: $table.kickerQuestion,
    builder: (column) => ColumnOrderings(column),
  );

  $$TutorConversationsTableOrderingComposer get conversationId {
    final $$TutorConversationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.conversationId,
      referencedTable: $db.tutorConversations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TutorConversationsTableOrderingComposer(
            $db: $db,
            $table: $db.tutorConversations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TutorMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TutorMessagesTable> {
  $$TutorMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MessageSender, String> get sender =>
      $composableBuilder(column: $table.sender, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<FollowUpPoint>, String>
  get followUpPoints => $composableBuilder(
    column: $table.followUpPoints,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<Citation>, String> get citations =>
      $composableBuilder(column: $table.citations, builder: (column) => column);

  GeneratedColumn<String> get kickerQuestion => $composableBuilder(
    column: $table.kickerQuestion,
    builder: (column) => column,
  );

  $$TutorConversationsTableAnnotationComposer get conversationId {
    final $$TutorConversationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.conversationId,
          referencedTable: $db.tutorConversations,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TutorConversationsTableAnnotationComposer(
                $db: $db,
                $table: $db.tutorConversations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$TutorMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TutorMessagesTable,
          TutorMessageRow,
          $$TutorMessagesTableFilterComposer,
          $$TutorMessagesTableOrderingComposer,
          $$TutorMessagesTableAnnotationComposer,
          $$TutorMessagesTableCreateCompanionBuilder,
          $$TutorMessagesTableUpdateCompanionBuilder,
          (TutorMessageRow, $$TutorMessagesTableReferences),
          TutorMessageRow,
          PrefetchHooks Function({bool conversationId})
        > {
  $$TutorMessagesTableTableManager(_$AppDatabase db, $TutorMessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TutorMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TutorMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TutorMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<MessageSender> sender = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<List<FollowUpPoint>> followUpPoints =
                    const Value.absent(),
                Value<List<Citation>> citations = const Value.absent(),
                Value<String?> kickerQuestion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TutorMessagesCompanion(
                id: id,
                conversationId: conversationId,
                sender: sender,
                content: content,
                timestamp: timestamp,
                followUpPoints: followUpPoints,
                citations: citations,
                kickerQuestion: kickerQuestion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String conversationId,
                required MessageSender sender,
                required String content,
                required DateTime timestamp,
                required List<FollowUpPoint> followUpPoints,
                required List<Citation> citations,
                Value<String?> kickerQuestion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TutorMessagesCompanion.insert(
                id: id,
                conversationId: conversationId,
                sender: sender,
                content: content,
                timestamp: timestamp,
                followUpPoints: followUpPoints,
                citations: citations,
                kickerQuestion: kickerQuestion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TutorMessagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({conversationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (conversationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.conversationId,
                                referencedTable: $$TutorMessagesTableReferences
                                    ._conversationIdTable(db),
                                referencedColumn: $$TutorMessagesTableReferences
                                    ._conversationIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TutorMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TutorMessagesTable,
      TutorMessageRow,
      $$TutorMessagesTableFilterComposer,
      $$TutorMessagesTableOrderingComposer,
      $$TutorMessagesTableAnnotationComposer,
      $$TutorMessagesTableCreateCompanionBuilder,
      $$TutorMessagesTableUpdateCompanionBuilder,
      (TutorMessageRow, $$TutorMessagesTableReferences),
      TutorMessageRow,
      PrefetchHooks Function({bool conversationId})
    >;
typedef $$TutorSettingsTableTableCreateCompanionBuilder =
    TutorSettingsTableCompanion Function({
      required String userId,
      Value<bool> showCitationsOnEveryReply,
      required TutorScope scope,
      required ReasoningDepth reasoningDepth,
      Value<int> rowid,
    });
typedef $$TutorSettingsTableTableUpdateCompanionBuilder =
    TutorSettingsTableCompanion Function({
      Value<String> userId,
      Value<bool> showCitationsOnEveryReply,
      Value<TutorScope> scope,
      Value<ReasoningDepth> reasoningDepth,
      Value<int> rowid,
    });

class $$TutorSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TutorSettingsTableTable> {
  $$TutorSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showCitationsOnEveryReply => $composableBuilder(
    column: $table.showCitationsOnEveryReply,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TutorScope, TutorScope, String> get scope =>
      $composableBuilder(
        column: $table.scope,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<ReasoningDepth, ReasoningDepth, String>
  get reasoningDepth => $composableBuilder(
    column: $table.reasoningDepth,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$TutorSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TutorSettingsTableTable> {
  $$TutorSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showCitationsOnEveryReply => $composableBuilder(
    column: $table.showCitationsOnEveryReply,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasoningDepth => $composableBuilder(
    column: $table.reasoningDepth,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TutorSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TutorSettingsTableTable> {
  $$TutorSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<bool> get showCitationsOnEveryReply => $composableBuilder(
    column: $table.showCitationsOnEveryReply,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TutorScope, String> get scope =>
      $composableBuilder(column: $table.scope, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ReasoningDepth, String> get reasoningDepth =>
      $composableBuilder(
        column: $table.reasoningDepth,
        builder: (column) => column,
      );
}

class $$TutorSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TutorSettingsTableTable,
          TutorSettingsRow,
          $$TutorSettingsTableTableFilterComposer,
          $$TutorSettingsTableTableOrderingComposer,
          $$TutorSettingsTableTableAnnotationComposer,
          $$TutorSettingsTableTableCreateCompanionBuilder,
          $$TutorSettingsTableTableUpdateCompanionBuilder,
          (
            TutorSettingsRow,
            BaseReferences<
              _$AppDatabase,
              $TutorSettingsTableTable,
              TutorSettingsRow
            >,
          ),
          TutorSettingsRow,
          PrefetchHooks Function()
        > {
  $$TutorSettingsTableTableTableManager(
    _$AppDatabase db,
    $TutorSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TutorSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TutorSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TutorSettingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<bool> showCitationsOnEveryReply = const Value.absent(),
                Value<TutorScope> scope = const Value.absent(),
                Value<ReasoningDepth> reasoningDepth = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TutorSettingsTableCompanion(
                userId: userId,
                showCitationsOnEveryReply: showCitationsOnEveryReply,
                scope: scope,
                reasoningDepth: reasoningDepth,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                Value<bool> showCitationsOnEveryReply = const Value.absent(),
                required TutorScope scope,
                required ReasoningDepth reasoningDepth,
                Value<int> rowid = const Value.absent(),
              }) => TutorSettingsTableCompanion.insert(
                userId: userId,
                showCitationsOnEveryReply: showCitationsOnEveryReply,
                scope: scope,
                reasoningDepth: reasoningDepth,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TutorSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TutorSettingsTableTable,
      TutorSettingsRow,
      $$TutorSettingsTableTableFilterComposer,
      $$TutorSettingsTableTableOrderingComposer,
      $$TutorSettingsTableTableAnnotationComposer,
      $$TutorSettingsTableTableCreateCompanionBuilder,
      $$TutorSettingsTableTableUpdateCompanionBuilder,
      (
        TutorSettingsRow,
        BaseReferences<
          _$AppDatabase,
          $TutorSettingsTableTable,
          TutorSettingsRow
        >,
      ),
      TutorSettingsRow,
      PrefetchHooks Function()
    >;
typedef $$NotificationSettingsTableTableCreateCompanionBuilder =
    NotificationSettingsTableCompanion Function({
      required String userId,
      Value<bool> blockReminders,
      Value<bool> dailyCheckIn,
      Value<bool> examCountdown,
      Value<int> rowid,
    });
typedef $$NotificationSettingsTableTableUpdateCompanionBuilder =
    NotificationSettingsTableCompanion Function({
      Value<String> userId,
      Value<bool> blockReminders,
      Value<bool> dailyCheckIn,
      Value<bool> examCountdown,
      Value<int> rowid,
    });

class $$NotificationSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationSettingsTableTable> {
  $$NotificationSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get blockReminders => $composableBuilder(
    column: $table.blockReminders,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dailyCheckIn => $composableBuilder(
    column: $table.dailyCheckIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get examCountdown => $composableBuilder(
    column: $table.examCountdown,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationSettingsTableTable> {
  $$NotificationSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get blockReminders => $composableBuilder(
    column: $table.blockReminders,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dailyCheckIn => $composableBuilder(
    column: $table.dailyCheckIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get examCountdown => $composableBuilder(
    column: $table.examCountdown,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationSettingsTableTable> {
  $$NotificationSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<bool> get blockReminders => $composableBuilder(
    column: $table.blockReminders,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get dailyCheckIn => $composableBuilder(
    column: $table.dailyCheckIn,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get examCountdown => $composableBuilder(
    column: $table.examCountdown,
    builder: (column) => column,
  );
}

class $$NotificationSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationSettingsTableTable,
          NotificationSettingsRow,
          $$NotificationSettingsTableTableFilterComposer,
          $$NotificationSettingsTableTableOrderingComposer,
          $$NotificationSettingsTableTableAnnotationComposer,
          $$NotificationSettingsTableTableCreateCompanionBuilder,
          $$NotificationSettingsTableTableUpdateCompanionBuilder,
          (
            NotificationSettingsRow,
            BaseReferences<
              _$AppDatabase,
              $NotificationSettingsTableTable,
              NotificationSettingsRow
            >,
          ),
          NotificationSettingsRow,
          PrefetchHooks Function()
        > {
  $$NotificationSettingsTableTableTableManager(
    _$AppDatabase db,
    $NotificationSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationSettingsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$NotificationSettingsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$NotificationSettingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<bool> blockReminders = const Value.absent(),
                Value<bool> dailyCheckIn = const Value.absent(),
                Value<bool> examCountdown = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationSettingsTableCompanion(
                userId: userId,
                blockReminders: blockReminders,
                dailyCheckIn: dailyCheckIn,
                examCountdown: examCountdown,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                Value<bool> blockReminders = const Value.absent(),
                Value<bool> dailyCheckIn = const Value.absent(),
                Value<bool> examCountdown = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationSettingsTableCompanion.insert(
                userId: userId,
                blockReminders: blockReminders,
                dailyCheckIn: dailyCheckIn,
                examCountdown: examCountdown,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationSettingsTableTable,
      NotificationSettingsRow,
      $$NotificationSettingsTableTableFilterComposer,
      $$NotificationSettingsTableTableOrderingComposer,
      $$NotificationSettingsTableTableAnnotationComposer,
      $$NotificationSettingsTableTableCreateCompanionBuilder,
      $$NotificationSettingsTableTableUpdateCompanionBuilder,
      (
        NotificationSettingsRow,
        BaseReferences<
          _$AppDatabase,
          $NotificationSettingsTableTable,
          NotificationSettingsRow
        >,
      ),
      NotificationSettingsRow,
      PrefetchHooks Function()
    >;
typedef $$AppearancePrefsTableTableCreateCompanionBuilder =
    AppearancePrefsTableCompanion Function({
      required String userId,
      required ThemeSetting theme,
      Value<bool> showDuaCard,
      Value<bool> showHijriDate,
      Value<String?> dailyDuaText,
      Value<int> rowid,
    });
typedef $$AppearancePrefsTableTableUpdateCompanionBuilder =
    AppearancePrefsTableCompanion Function({
      Value<String> userId,
      Value<ThemeSetting> theme,
      Value<bool> showDuaCard,
      Value<bool> showHijriDate,
      Value<String?> dailyDuaText,
      Value<int> rowid,
    });

class $$AppearancePrefsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppearancePrefsTableTable> {
  $$AppearancePrefsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ThemeSetting, ThemeSetting, String>
  get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get showDuaCard => $composableBuilder(
    column: $table.showDuaCard,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showHijriDate => $composableBuilder(
    column: $table.showHijriDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dailyDuaText => $composableBuilder(
    column: $table.dailyDuaText,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppearancePrefsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppearancePrefsTableTable> {
  $$AppearancePrefsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showDuaCard => $composableBuilder(
    column: $table.showDuaCard,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showHijriDate => $composableBuilder(
    column: $table.showHijriDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dailyDuaText => $composableBuilder(
    column: $table.dailyDuaText,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppearancePrefsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppearancePrefsTableTable> {
  $$AppearancePrefsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ThemeSetting, String> get theme =>
      $composableBuilder(column: $table.theme, builder: (column) => column);

  GeneratedColumn<bool> get showDuaCard => $composableBuilder(
    column: $table.showDuaCard,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showHijriDate => $composableBuilder(
    column: $table.showHijriDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dailyDuaText => $composableBuilder(
    column: $table.dailyDuaText,
    builder: (column) => column,
  );
}

class $$AppearancePrefsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppearancePrefsTableTable,
          AppearancePreferencesRow,
          $$AppearancePrefsTableTableFilterComposer,
          $$AppearancePrefsTableTableOrderingComposer,
          $$AppearancePrefsTableTableAnnotationComposer,
          $$AppearancePrefsTableTableCreateCompanionBuilder,
          $$AppearancePrefsTableTableUpdateCompanionBuilder,
          (
            AppearancePreferencesRow,
            BaseReferences<
              _$AppDatabase,
              $AppearancePrefsTableTable,
              AppearancePreferencesRow
            >,
          ),
          AppearancePreferencesRow,
          PrefetchHooks Function()
        > {
  $$AppearancePrefsTableTableTableManager(
    _$AppDatabase db,
    $AppearancePrefsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppearancePrefsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppearancePrefsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AppearancePrefsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<ThemeSetting> theme = const Value.absent(),
                Value<bool> showDuaCard = const Value.absent(),
                Value<bool> showHijriDate = const Value.absent(),
                Value<String?> dailyDuaText = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppearancePrefsTableCompanion(
                userId: userId,
                theme: theme,
                showDuaCard: showDuaCard,
                showHijriDate: showHijriDate,
                dailyDuaText: dailyDuaText,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required ThemeSetting theme,
                Value<bool> showDuaCard = const Value.absent(),
                Value<bool> showHijriDate = const Value.absent(),
                Value<String?> dailyDuaText = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppearancePrefsTableCompanion.insert(
                userId: userId,
                theme: theme,
                showDuaCard: showDuaCard,
                showHijriDate: showHijriDate,
                dailyDuaText: dailyDuaText,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppearancePrefsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppearancePrefsTableTable,
      AppearancePreferencesRow,
      $$AppearancePrefsTableTableFilterComposer,
      $$AppearancePrefsTableTableOrderingComposer,
      $$AppearancePrefsTableTableAnnotationComposer,
      $$AppearancePrefsTableTableCreateCompanionBuilder,
      $$AppearancePrefsTableTableUpdateCompanionBuilder,
      (
        AppearancePreferencesRow,
        BaseReferences<
          _$AppDatabase,
          $AppearancePrefsTableTable,
          AppearancePreferencesRow
        >,
      ),
      AppearancePreferencesRow,
      PrefetchHooks Function()
    >;
typedef $$LanguagePrefsTableTableCreateCompanionBuilder =
    LanguagePrefsTableCompanion Function({
      required String userId,
      required AppLanguage appLanguage,
      Value<bool> useUrduNastaliq,
      Value<int> rowid,
    });
typedef $$LanguagePrefsTableTableUpdateCompanionBuilder =
    LanguagePrefsTableCompanion Function({
      Value<String> userId,
      Value<AppLanguage> appLanguage,
      Value<bool> useUrduNastaliq,
      Value<int> rowid,
    });

class $$LanguagePrefsTableTableFilterComposer
    extends Composer<_$AppDatabase, $LanguagePrefsTableTable> {
  $$LanguagePrefsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AppLanguage, AppLanguage, String>
  get appLanguage => $composableBuilder(
    column: $table.appLanguage,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get useUrduNastaliq => $composableBuilder(
    column: $table.useUrduNastaliq,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LanguagePrefsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LanguagePrefsTableTable> {
  $$LanguagePrefsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appLanguage => $composableBuilder(
    column: $table.appLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get useUrduNastaliq => $composableBuilder(
    column: $table.useUrduNastaliq,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LanguagePrefsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LanguagePrefsTableTable> {
  $$LanguagePrefsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AppLanguage, String> get appLanguage =>
      $composableBuilder(
        column: $table.appLanguage,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get useUrduNastaliq => $composableBuilder(
    column: $table.useUrduNastaliq,
    builder: (column) => column,
  );
}

class $$LanguagePrefsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LanguagePrefsTableTable,
          LanguagePreferencesRow,
          $$LanguagePrefsTableTableFilterComposer,
          $$LanguagePrefsTableTableOrderingComposer,
          $$LanguagePrefsTableTableAnnotationComposer,
          $$LanguagePrefsTableTableCreateCompanionBuilder,
          $$LanguagePrefsTableTableUpdateCompanionBuilder,
          (
            LanguagePreferencesRow,
            BaseReferences<
              _$AppDatabase,
              $LanguagePrefsTableTable,
              LanguagePreferencesRow
            >,
          ),
          LanguagePreferencesRow,
          PrefetchHooks Function()
        > {
  $$LanguagePrefsTableTableTableManager(
    _$AppDatabase db,
    $LanguagePrefsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LanguagePrefsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LanguagePrefsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LanguagePrefsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<AppLanguage> appLanguage = const Value.absent(),
                Value<bool> useUrduNastaliq = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LanguagePrefsTableCompanion(
                userId: userId,
                appLanguage: appLanguage,
                useUrduNastaliq: useUrduNastaliq,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required AppLanguage appLanguage,
                Value<bool> useUrduNastaliq = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LanguagePrefsTableCompanion.insert(
                userId: userId,
                appLanguage: appLanguage,
                useUrduNastaliq: useUrduNastaliq,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LanguagePrefsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LanguagePrefsTableTable,
      LanguagePreferencesRow,
      $$LanguagePrefsTableTableFilterComposer,
      $$LanguagePrefsTableTableOrderingComposer,
      $$LanguagePrefsTableTableAnnotationComposer,
      $$LanguagePrefsTableTableCreateCompanionBuilder,
      $$LanguagePrefsTableTableUpdateCompanionBuilder,
      (
        LanguagePreferencesRow,
        BaseReferences<
          _$AppDatabase,
          $LanguagePrefsTableTable,
          LanguagePreferencesRow
        >,
      ),
      LanguagePreferencesRow,
      PrefetchHooks Function()
    >;
typedef $$PrivacySettingsTableTableCreateCompanionBuilder =
    PrivacySettingsTableCompanion Function({
      required String userId,
      Value<bool> onDeviceProcessing,
      Value<bool> cloudBackupEnabled,
      Value<DateTime?> cloudBackupLastSync,
      Value<int> rowid,
    });
typedef $$PrivacySettingsTableTableUpdateCompanionBuilder =
    PrivacySettingsTableCompanion Function({
      Value<String> userId,
      Value<bool> onDeviceProcessing,
      Value<bool> cloudBackupEnabled,
      Value<DateTime?> cloudBackupLastSync,
      Value<int> rowid,
    });

class $$PrivacySettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PrivacySettingsTableTable> {
  $$PrivacySettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onDeviceProcessing => $composableBuilder(
    column: $table.onDeviceProcessing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get cloudBackupEnabled => $composableBuilder(
    column: $table.cloudBackupEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cloudBackupLastSync => $composableBuilder(
    column: $table.cloudBackupLastSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PrivacySettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PrivacySettingsTableTable> {
  $$PrivacySettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onDeviceProcessing => $composableBuilder(
    column: $table.onDeviceProcessing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get cloudBackupEnabled => $composableBuilder(
    column: $table.cloudBackupEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cloudBackupLastSync => $composableBuilder(
    column: $table.cloudBackupLastSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PrivacySettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrivacySettingsTableTable> {
  $$PrivacySettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<bool> get onDeviceProcessing => $composableBuilder(
    column: $table.onDeviceProcessing,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get cloudBackupEnabled => $composableBuilder(
    column: $table.cloudBackupEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cloudBackupLastSync => $composableBuilder(
    column: $table.cloudBackupLastSync,
    builder: (column) => column,
  );
}

class $$PrivacySettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PrivacySettingsTableTable,
          PrivacySettingsRow,
          $$PrivacySettingsTableTableFilterComposer,
          $$PrivacySettingsTableTableOrderingComposer,
          $$PrivacySettingsTableTableAnnotationComposer,
          $$PrivacySettingsTableTableCreateCompanionBuilder,
          $$PrivacySettingsTableTableUpdateCompanionBuilder,
          (
            PrivacySettingsRow,
            BaseReferences<
              _$AppDatabase,
              $PrivacySettingsTableTable,
              PrivacySettingsRow
            >,
          ),
          PrivacySettingsRow,
          PrefetchHooks Function()
        > {
  $$PrivacySettingsTableTableTableManager(
    _$AppDatabase db,
    $PrivacySettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrivacySettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrivacySettingsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PrivacySettingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<bool> onDeviceProcessing = const Value.absent(),
                Value<bool> cloudBackupEnabled = const Value.absent(),
                Value<DateTime?> cloudBackupLastSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PrivacySettingsTableCompanion(
                userId: userId,
                onDeviceProcessing: onDeviceProcessing,
                cloudBackupEnabled: cloudBackupEnabled,
                cloudBackupLastSync: cloudBackupLastSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                Value<bool> onDeviceProcessing = const Value.absent(),
                Value<bool> cloudBackupEnabled = const Value.absent(),
                Value<DateTime?> cloudBackupLastSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PrivacySettingsTableCompanion.insert(
                userId: userId,
                onDeviceProcessing: onDeviceProcessing,
                cloudBackupEnabled: cloudBackupEnabled,
                cloudBackupLastSync: cloudBackupLastSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PrivacySettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PrivacySettingsTableTable,
      PrivacySettingsRow,
      $$PrivacySettingsTableTableFilterComposer,
      $$PrivacySettingsTableTableOrderingComposer,
      $$PrivacySettingsTableTableAnnotationComposer,
      $$PrivacySettingsTableTableCreateCompanionBuilder,
      $$PrivacySettingsTableTableUpdateCompanionBuilder,
      (
        PrivacySettingsRow,
        BaseReferences<
          _$AppDatabase,
          $PrivacySettingsTableTable,
          PrivacySettingsRow
        >,
      ),
      PrivacySettingsRow,
      PrefetchHooks Function()
    >;
typedef $$OnboardingDataTableTableCreateCompanionBuilder =
    OnboardingDataTableCompanion Function({
      required String userId,
      Value<int> step,
      Value<String?> institution,
      Value<int> rowid,
    });
typedef $$OnboardingDataTableTableUpdateCompanionBuilder =
    OnboardingDataTableCompanion Function({
      Value<String> userId,
      Value<int> step,
      Value<String?> institution,
      Value<int> rowid,
    });

class $$OnboardingDataTableTableFilterComposer
    extends Composer<_$AppDatabase, $OnboardingDataTableTable> {
  $$OnboardingDataTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get step => $composableBuilder(
    column: $table.step,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get institution => $composableBuilder(
    column: $table.institution,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OnboardingDataTableTableOrderingComposer
    extends Composer<_$AppDatabase, $OnboardingDataTableTable> {
  $$OnboardingDataTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get step => $composableBuilder(
    column: $table.step,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get institution => $composableBuilder(
    column: $table.institution,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OnboardingDataTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $OnboardingDataTableTable> {
  $$OnboardingDataTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get step =>
      $composableBuilder(column: $table.step, builder: (column) => column);

  GeneratedColumn<String> get institution => $composableBuilder(
    column: $table.institution,
    builder: (column) => column,
  );
}

class $$OnboardingDataTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OnboardingDataTableTable,
          OnboardingDataRow,
          $$OnboardingDataTableTableFilterComposer,
          $$OnboardingDataTableTableOrderingComposer,
          $$OnboardingDataTableTableAnnotationComposer,
          $$OnboardingDataTableTableCreateCompanionBuilder,
          $$OnboardingDataTableTableUpdateCompanionBuilder,
          (
            OnboardingDataRow,
            BaseReferences<
              _$AppDatabase,
              $OnboardingDataTableTable,
              OnboardingDataRow
            >,
          ),
          OnboardingDataRow,
          PrefetchHooks Function()
        > {
  $$OnboardingDataTableTableTableManager(
    _$AppDatabase db,
    $OnboardingDataTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OnboardingDataTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OnboardingDataTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$OnboardingDataTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<int> step = const Value.absent(),
                Value<String?> institution = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OnboardingDataTableCompanion(
                userId: userId,
                step: step,
                institution: institution,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                Value<int> step = const Value.absent(),
                Value<String?> institution = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OnboardingDataTableCompanion.insert(
                userId: userId,
                step: step,
                institution: institution,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OnboardingDataTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OnboardingDataTableTable,
      OnboardingDataRow,
      $$OnboardingDataTableTableFilterComposer,
      $$OnboardingDataTableTableOrderingComposer,
      $$OnboardingDataTableTableAnnotationComposer,
      $$OnboardingDataTableTableCreateCompanionBuilder,
      $$OnboardingDataTableTableUpdateCompanionBuilder,
      (
        OnboardingDataRow,
        BaseReferences<
          _$AppDatabase,
          $OnboardingDataTableTable,
          OnboardingDataRow
        >,
      ),
      OnboardingDataRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SubjectsTableTableManager get subjects =>
      $$SubjectsTableTableManager(_db, _db.subjects);
  $$TopicsTableTableManager get topics =>
      $$TopicsTableTableManager(_db, _db.topics);
  $$ExamsTableTableManager get exams =>
      $$ExamsTableTableManager(_db, _db.exams);
  $$StudyWindowsTableTableManager get studyWindows =>
      $$StudyWindowsTableTableManager(_db, _db.studyWindows);
  $$SchedulesTableTableManager get schedules =>
      $$SchedulesTableTableManager(_db, _db.schedules);
  $$StudyBlocksTableTableManager get studyBlocks =>
      $$StudyBlocksTableTableManager(_db, _db.studyBlocks);
  $$LibraryItemsTableTableManager get libraryItems =>
      $$LibraryItemsTableTableManager(_db, _db.libraryItems);
  $$MaterialTextsTableTableManager get materialTexts =>
      $$MaterialTextsTableTableManager(_db, _db.materialTexts);
  $$QuizzesTableTableManager get quizzes =>
      $$QuizzesTableTableManager(_db, _db.quizzes);
  $$QuizQuestionsTableTableManager get quizQuestions =>
      $$QuizQuestionsTableTableManager(_db, _db.quizQuestions);
  $$QuizAttemptsTableTableManager get quizAttempts =>
      $$QuizAttemptsTableTableManager(_db, _db.quizAttempts);
  $$QuizFeedbackItemsTableTableManager get quizFeedbackItems =>
      $$QuizFeedbackItemsTableTableManager(_db, _db.quizFeedbackItems);
  $$ProgressMetricsTableTableManager get progressMetrics =>
      $$ProgressMetricsTableTableManager(_db, _db.progressMetrics);
  $$StudyStreaksTableTableManager get studyStreaks =>
      $$StudyStreaksTableTableManager(_db, _db.studyStreaks);
  $$DailyScoresTableTableManager get dailyScores =>
      $$DailyScoresTableTableManager(_db, _db.dailyScores);
  $$SessionMetricsTableTableManager get sessionMetrics =>
      $$SessionMetricsTableTableManager(_db, _db.sessionMetrics);
  $$TutorConversationsTableTableManager get tutorConversations =>
      $$TutorConversationsTableTableManager(_db, _db.tutorConversations);
  $$TutorMessagesTableTableManager get tutorMessages =>
      $$TutorMessagesTableTableManager(_db, _db.tutorMessages);
  $$TutorSettingsTableTableTableManager get tutorSettingsTable =>
      $$TutorSettingsTableTableTableManager(_db, _db.tutorSettingsTable);
  $$NotificationSettingsTableTableTableManager get notificationSettingsTable =>
      $$NotificationSettingsTableTableTableManager(
        _db,
        _db.notificationSettingsTable,
      );
  $$AppearancePrefsTableTableTableManager get appearancePrefsTable =>
      $$AppearancePrefsTableTableTableManager(_db, _db.appearancePrefsTable);
  $$LanguagePrefsTableTableTableManager get languagePrefsTable =>
      $$LanguagePrefsTableTableTableManager(_db, _db.languagePrefsTable);
  $$PrivacySettingsTableTableTableManager get privacySettingsTable =>
      $$PrivacySettingsTableTableTableManager(_db, _db.privacySettingsTable);
  $$OnboardingDataTableTableTableManager get onboardingDataTable =>
      $$OnboardingDataTableTableTableManager(_db, _db.onboardingDataTable);
}

mixin _$SubjectDaoMixin on DatabaseAccessor<AppDatabase> {
  $SubjectsTable get subjects => attachedDatabase.subjects;
  $TopicsTable get topics => attachedDatabase.topics;
  $ExamsTable get exams => attachedDatabase.exams;
  SubjectDaoManager get managers => SubjectDaoManager(this);
}

class SubjectDaoManager {
  final _$SubjectDaoMixin _db;
  SubjectDaoManager(this._db);
  $$SubjectsTableTableManager get subjects =>
      $$SubjectsTableTableManager(_db.attachedDatabase, _db.subjects);
  $$TopicsTableTableManager get topics =>
      $$TopicsTableTableManager(_db.attachedDatabase, _db.topics);
  $$ExamsTableTableManager get exams =>
      $$ExamsTableTableManager(_db.attachedDatabase, _db.exams);
}

mixin _$ScheduleDaoMixin on DatabaseAccessor<AppDatabase> {
  $StudyWindowsTable get studyWindows => attachedDatabase.studyWindows;
  $SchedulesTable get schedules => attachedDatabase.schedules;
  $SubjectsTable get subjects => attachedDatabase.subjects;
  $TopicsTable get topics => attachedDatabase.topics;
  $StudyBlocksTable get studyBlocks => attachedDatabase.studyBlocks;
  ScheduleDaoManager get managers => ScheduleDaoManager(this);
}

class ScheduleDaoManager {
  final _$ScheduleDaoMixin _db;
  ScheduleDaoManager(this._db);
  $$StudyWindowsTableTableManager get studyWindows =>
      $$StudyWindowsTableTableManager(_db.attachedDatabase, _db.studyWindows);
  $$SchedulesTableTableManager get schedules =>
      $$SchedulesTableTableManager(_db.attachedDatabase, _db.schedules);
  $$SubjectsTableTableManager get subjects =>
      $$SubjectsTableTableManager(_db.attachedDatabase, _db.subjects);
  $$TopicsTableTableManager get topics =>
      $$TopicsTableTableManager(_db.attachedDatabase, _db.topics);
  $$StudyBlocksTableTableManager get studyBlocks =>
      $$StudyBlocksTableTableManager(_db.attachedDatabase, _db.studyBlocks);
}

mixin _$LibraryDaoMixin on DatabaseAccessor<AppDatabase> {
  $SubjectsTable get subjects => attachedDatabase.subjects;
  $LibraryItemsTable get libraryItems => attachedDatabase.libraryItems;
  LibraryDaoManager get managers => LibraryDaoManager(this);
}

class LibraryDaoManager {
  final _$LibraryDaoMixin _db;
  LibraryDaoManager(this._db);
  $$SubjectsTableTableManager get subjects =>
      $$SubjectsTableTableManager(_db.attachedDatabase, _db.subjects);
  $$LibraryItemsTableTableManager get libraryItems =>
      $$LibraryItemsTableTableManager(_db.attachedDatabase, _db.libraryItems);
}

mixin _$MaterialTextsDaoMixin on DatabaseAccessor<AppDatabase> {
  $SubjectsTable get subjects => attachedDatabase.subjects;
  $LibraryItemsTable get libraryItems => attachedDatabase.libraryItems;
  $MaterialTextsTable get materialTexts => attachedDatabase.materialTexts;
  MaterialTextsDaoManager get managers => MaterialTextsDaoManager(this);
}

class MaterialTextsDaoManager {
  final _$MaterialTextsDaoMixin _db;
  MaterialTextsDaoManager(this._db);
  $$SubjectsTableTableManager get subjects =>
      $$SubjectsTableTableManager(_db.attachedDatabase, _db.subjects);
  $$LibraryItemsTableTableManager get libraryItems =>
      $$LibraryItemsTableTableManager(_db.attachedDatabase, _db.libraryItems);
  $$MaterialTextsTableTableManager get materialTexts =>
      $$MaterialTextsTableTableManager(_db.attachedDatabase, _db.materialTexts);
}

mixin _$QuizDaoMixin on DatabaseAccessor<AppDatabase> {
  $SubjectsTable get subjects => attachedDatabase.subjects;
  $TopicsTable get topics => attachedDatabase.topics;
  $QuizzesTable get quizzes => attachedDatabase.quizzes;
  $QuizQuestionsTable get quizQuestions => attachedDatabase.quizQuestions;
  $QuizAttemptsTable get quizAttempts => attachedDatabase.quizAttempts;
  $QuizFeedbackItemsTable get quizFeedbackItems =>
      attachedDatabase.quizFeedbackItems;
  QuizDaoManager get managers => QuizDaoManager(this);
}

class QuizDaoManager {
  final _$QuizDaoMixin _db;
  QuizDaoManager(this._db);
  $$SubjectsTableTableManager get subjects =>
      $$SubjectsTableTableManager(_db.attachedDatabase, _db.subjects);
  $$TopicsTableTableManager get topics =>
      $$TopicsTableTableManager(_db.attachedDatabase, _db.topics);
  $$QuizzesTableTableManager get quizzes =>
      $$QuizzesTableTableManager(_db.attachedDatabase, _db.quizzes);
  $$QuizQuestionsTableTableManager get quizQuestions =>
      $$QuizQuestionsTableTableManager(_db.attachedDatabase, _db.quizQuestions);
  $$QuizAttemptsTableTableManager get quizAttempts =>
      $$QuizAttemptsTableTableManager(_db.attachedDatabase, _db.quizAttempts);
  $$QuizFeedbackItemsTableTableManager get quizFeedbackItems =>
      $$QuizFeedbackItemsTableTableManager(
        _db.attachedDatabase,
        _db.quizFeedbackItems,
      );
}

mixin _$ProgressDaoMixin on DatabaseAccessor<AppDatabase> {
  $SubjectsTable get subjects => attachedDatabase.subjects;
  $ProgressMetricsTable get progressMetrics => attachedDatabase.progressMetrics;
  $StudyStreaksTable get studyStreaks => attachedDatabase.studyStreaks;
  $TopicsTable get topics => attachedDatabase.topics;
  $DailyScoresTable get dailyScores => attachedDatabase.dailyScores;
  $SessionMetricsTable get sessionMetrics => attachedDatabase.sessionMetrics;
  ProgressDaoManager get managers => ProgressDaoManager(this);
}

class ProgressDaoManager {
  final _$ProgressDaoMixin _db;
  ProgressDaoManager(this._db);
  $$SubjectsTableTableManager get subjects =>
      $$SubjectsTableTableManager(_db.attachedDatabase, _db.subjects);
  $$ProgressMetricsTableTableManager get progressMetrics =>
      $$ProgressMetricsTableTableManager(
        _db.attachedDatabase,
        _db.progressMetrics,
      );
  $$StudyStreaksTableTableManager get studyStreaks =>
      $$StudyStreaksTableTableManager(_db.attachedDatabase, _db.studyStreaks);
  $$TopicsTableTableManager get topics =>
      $$TopicsTableTableManager(_db.attachedDatabase, _db.topics);
  $$DailyScoresTableTableManager get dailyScores =>
      $$DailyScoresTableTableManager(_db.attachedDatabase, _db.dailyScores);
  $$SessionMetricsTableTableManager get sessionMetrics =>
      $$SessionMetricsTableTableManager(
        _db.attachedDatabase,
        _db.sessionMetrics,
      );
}

mixin _$TutorDaoMixin on DatabaseAccessor<AppDatabase> {
  $SubjectsTable get subjects => attachedDatabase.subjects;
  $TopicsTable get topics => attachedDatabase.topics;
  $TutorConversationsTable get tutorConversations =>
      attachedDatabase.tutorConversations;
  $TutorMessagesTable get tutorMessages => attachedDatabase.tutorMessages;
  $TutorSettingsTableTable get tutorSettingsTable =>
      attachedDatabase.tutorSettingsTable;
  TutorDaoManager get managers => TutorDaoManager(this);
}

class TutorDaoManager {
  final _$TutorDaoMixin _db;
  TutorDaoManager(this._db);
  $$SubjectsTableTableManager get subjects =>
      $$SubjectsTableTableManager(_db.attachedDatabase, _db.subjects);
  $$TopicsTableTableManager get topics =>
      $$TopicsTableTableManager(_db.attachedDatabase, _db.topics);
  $$TutorConversationsTableTableManager get tutorConversations =>
      $$TutorConversationsTableTableManager(
        _db.attachedDatabase,
        _db.tutorConversations,
      );
  $$TutorMessagesTableTableManager get tutorMessages =>
      $$TutorMessagesTableTableManager(_db.attachedDatabase, _db.tutorMessages);
  $$TutorSettingsTableTableTableManager get tutorSettingsTable =>
      $$TutorSettingsTableTableTableManager(
        _db.attachedDatabase,
        _db.tutorSettingsTable,
      );
}

mixin _$SettingsDaoMixin on DatabaseAccessor<AppDatabase> {
  $NotificationSettingsTableTable get notificationSettingsTable =>
      attachedDatabase.notificationSettingsTable;
  $AppearancePrefsTableTable get appearancePrefsTable =>
      attachedDatabase.appearancePrefsTable;
  $LanguagePrefsTableTable get languagePrefsTable =>
      attachedDatabase.languagePrefsTable;
  $PrivacySettingsTableTable get privacySettingsTable =>
      attachedDatabase.privacySettingsTable;
  SettingsDaoManager get managers => SettingsDaoManager(this);
}

class SettingsDaoManager {
  final _$SettingsDaoMixin _db;
  SettingsDaoManager(this._db);
  $$NotificationSettingsTableTableTableManager get notificationSettingsTable =>
      $$NotificationSettingsTableTableTableManager(
        _db.attachedDatabase,
        _db.notificationSettingsTable,
      );
  $$AppearancePrefsTableTableTableManager get appearancePrefsTable =>
      $$AppearancePrefsTableTableTableManager(
        _db.attachedDatabase,
        _db.appearancePrefsTable,
      );
  $$LanguagePrefsTableTableTableManager get languagePrefsTable =>
      $$LanguagePrefsTableTableTableManager(
        _db.attachedDatabase,
        _db.languagePrefsTable,
      );
  $$PrivacySettingsTableTableTableManager get privacySettingsTable =>
      $$PrivacySettingsTableTableTableManager(
        _db.attachedDatabase,
        _db.privacySettingsTable,
      );
}

mixin _$OnboardingDaoMixin on DatabaseAccessor<AppDatabase> {
  $OnboardingDataTableTable get onboardingDataTable =>
      attachedDatabase.onboardingDataTable;
  OnboardingDaoManager get managers => OnboardingDaoManager(this);
}

class OnboardingDaoManager {
  final _$OnboardingDaoMixin _db;
  OnboardingDaoManager(this._db);
  $$OnboardingDataTableTableTableManager get onboardingDataTable =>
      $$OnboardingDataTableTableTableManager(
        _db.attachedDatabase,
        _db.onboardingDataTable,
      );
}
