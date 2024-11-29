import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cricet_score.dart';

class LiveScoreScreen extends StatefulWidget {
  const LiveScoreScreen({super.key});

  @override
  State<LiveScoreScreen> createState() => _LiveScoreScreenState();
}

class _LiveScoreScreenState extends State<LiveScoreScreen> {
  List<CricketScore> _cricketScoreList = <CricketScore>[];

  void _extractData(QuerySnapshot<Map<String, dynamic>>? snapshot) {
    _cricketScoreList.clear();
    _cricketScoreList = snapshot!.docs
        .map((e) => CricketScore.fromJson(e.id, e.data()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('cricket').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No data found'),
            );
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            _extractData(snapshot.data);
            return ListView.separated(
              itemBuilder: (context, index) {
                CricketScore cricketScore = _cricketScoreList[index];
                return ListTile(
                  leading: Badge(
                    backgroundColor:
                        _indicatorColor(cricketScore.isMatchRunning),
                    label: const Padding(
                      padding: EdgeInsets.all(4.0),
                    ),
                  ),
                  title: Text('Match id: ${cricketScore.matchId}'),
                  subtitle: Text("Team 1: ${cricketScore.teamOne}\n"
                      "Team 2: ${cricketScore.teamTwo}\n"
                      "${cricketScore.isMatchRunning ? "Match Running" : "Winner: ${cricketScore.winnerTeam}"}"),
                  trailing: Text(
                      "${cricketScore.teamOneScore}/${cricketScore.teamTwoScore}"),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: _cricketScoreList.length,
            );
          }

          return const Center(
            child: Text('No data found'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addMatch(
            CricketScore(
              matchId: "afgvsban",
              teamOne: 'Afghanistan',
              teamTwo: 'Bangladesh',
              teamOneScore: 200,
              teamTwoScore: 150,
              isMatchRunning: true,
              winnerTeam: '',
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _addMatch(CricketScore cricketScore) {
    FirebaseFirestore.instance
        .collection('cricket')
        .doc(cricketScore.matchId)
        .set(cricketScore.toJson());
  }

  Color _indicatorColor(bool isMatchRunning) {
    return isMatchRunning ? Colors.green : Colors.grey;
  }
}
