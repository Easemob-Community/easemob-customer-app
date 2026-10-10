class SessionState {
  final String? sessionId;
  final String? groupId;
  final String status;
  final String handlerType;
  final int queuePosition;
  final Map<String, dynamic>? aiAccount;
  final Map<String, dynamic>? agent;

  const SessionState({
    this.sessionId,
    this.groupId,
    this.status = 'CREATED',
    this.handlerType = 'AI',
    this.queuePosition = 0,
    this.aiAccount,
    this.agent,
  });

  SessionState copyWith({
    String? sessionId,
    String? groupId,
    String? status,
    String? handlerType,
    int? queuePosition,
    Map<String, dynamic>? aiAccount,
    Map<String, dynamic>? agent,
  }) {
    return SessionState(
      sessionId: sessionId ?? this.sessionId,
      groupId: groupId ?? this.groupId,
      status: status ?? this.status,
      handlerType: handlerType ?? this.handlerType,
      queuePosition: queuePosition ?? this.queuePosition,
      aiAccount: aiAccount ?? this.aiAccount,
      agent: agent ?? this.agent,
    );
  }
}
