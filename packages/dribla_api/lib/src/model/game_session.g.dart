// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_session.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GameSession extends GameSession {
  @override
  final String? id;
  @override
  final String? userId;
  @override
  final String? game;
  @override
  final int? duration;
  @override
  final int? score;
  @override
  final DateTime? createdAt;

  factory _$GameSession([void Function(GameSessionBuilder)? updates]) =>
      (GameSessionBuilder()..update(updates))._build();

  _$GameSession._(
      {this.id,
      this.userId,
      this.game,
      this.duration,
      this.score,
      this.createdAt})
      : super._();
  @override
  GameSession rebuild(void Function(GameSessionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GameSessionBuilder toBuilder() => GameSessionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GameSession &&
        id == other.id &&
        userId == other.userId &&
        game == other.game &&
        duration == other.duration &&
        score == other.score &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, game.hashCode);
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jc(_$hash, score.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GameSession')
          ..add('id', id)
          ..add('userId', userId)
          ..add('game', game)
          ..add('duration', duration)
          ..add('score', score)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class GameSessionBuilder implements Builder<GameSession, GameSessionBuilder> {
  _$GameSession? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _game;
  String? get game => _$this._game;
  set game(String? game) => _$this._game = game;

  int? _duration;
  int? get duration => _$this._duration;
  set duration(int? duration) => _$this._duration = duration;

  int? _score;
  int? get score => _$this._score;
  set score(int? score) => _$this._score = score;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  GameSessionBuilder() {
    GameSession._defaults(this);
  }

  GameSessionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _userId = $v.userId;
      _game = $v.game;
      _duration = $v.duration;
      _score = $v.score;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GameSession other) {
    _$v = other as _$GameSession;
  }

  @override
  void update(void Function(GameSessionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GameSession build() => _build();

  _$GameSession _build() {
    final _$result = _$v ??
        _$GameSession._(
          id: id,
          userId: userId,
          game: game,
          duration: duration,
          score: score,
          createdAt: createdAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
