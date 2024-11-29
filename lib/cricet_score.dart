class CricketScore {
  final String matchId;
  final String teamOne;
  final String teamTwo;
  final int teamOneScore;
  final int teamTwoScore;
  final bool isMatchRunning;
  final String winnerTeam;

  CricketScore({
    required this.matchId,
    required this.teamOne,
    required this.teamTwo,
    required this.teamOneScore,
    required this.teamTwoScore,
    required this.isMatchRunning,
    required this.winnerTeam,
  });

  factory CricketScore.fromJson(String id,Map<String, dynamic> data) {
    return CricketScore(
      matchId: id,
      teamOne: data['teamOne'],
      teamTwo: data['teamTwo'],
      teamOneScore: data['teamOneScore'],
      teamTwoScore: data['teamTwoScore'],
      isMatchRunning: data['isMatchRunning'],
      winnerTeam: data['winnerTeam'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teamOne': teamOne,
      'teamTwo': teamTwo,
      'teamOneScore': teamOneScore,
      'teamTwoScore': teamTwoScore,
      'isMatchRunning': isMatchRunning,
      'winnerTeam': winnerTeam,
    };
  }
}
