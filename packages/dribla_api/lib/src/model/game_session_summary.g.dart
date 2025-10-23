// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_session_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GameSessionSummary extends GameSessionSummary {
  @override
  final int? totalDuration;
  @override
  final int? totalScore;

  factory _$GameSessionSummary(
          [void Function(GameSessionSummaryBuilder)? updates]) =>
      (GameSessionSummaryBuilder()..update(updates))._build();

  _$GameSessionSummary._({this.totalDuration, this.totalScore}) : super._();
  @override
  GameSessionSummary rebuild(
          void Function(GameSessionSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GameSessionSummaryBuilder toBuilder() =>
      GameSessionSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GameSessionSummary &&
        totalDuration == other.totalDuration &&
        totalScore == other.totalScore;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, totalDuration.hashCode);
    _$hash = $jc(_$hash, totalScore.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GameSessionSummary')
          ..add('totalDuration', totalDuration)
          ..add('totalScore', totalScore))
        .toString();
  }
}

class GameSessionSummaryBuilder
    implements Builder<GameSessionSummary, GameSessionSummaryBuilder> {
  _$GameSessionSummary? _$v;

  int? _totalDuration;
  int? get totalDuration => _$this._totalDuration;
  set totalDuration(int? totalDuration) =>
      _$this._totalDuration = totalDuration;

  int? _totalScore;
  int? get totalScore => _$this._totalScore;
  set totalScore(int? totalScore) => _$this._totalScore = totalScore;

  GameSessionSummaryBuilder() {
    GameSessionSummary._defaults(this);
  }

  GameSessionSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _totalDuration = $v.totalDuration;
      _totalScore = $v.totalScore;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GameSessionSummary other) {
    _$v = other as _$GameSessionSummary;
  }

  @override
  void update(void Function(GameSessionSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GameSessionSummary build() => _build();

  _$GameSessionSummary _build() {
    final _$result = _$v ??
        _$GameSessionSummary._(
          totalDuration: totalDuration,
          totalScore: totalScore,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
