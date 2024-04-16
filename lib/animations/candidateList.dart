import 'package:flutter/material.dart';
import 'package:group6_project2/candidate.dart';
import 'package:group6_project2/candidateDetails.dart';
class CandidateListAnimation extends StatefulWidget {
  final Candidate candidate;
  final Duration animationDuration;
  final int index;

  const CandidateListAnimation({
    Key? key,
    required this.candidate,
    required this.animationDuration,
    required this.index,
  }) : super(key: key);

  @override
  _CandidateListAnimationState createState() => _CandidateListAnimationState();
}

class _CandidateListAnimationState extends State<CandidateListAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    final double delayFactor = 0.1;
    final double animationDelay = widget.index * delayFactor;

    Future.delayed(Duration(milliseconds: (animationDelay * 1000).toInt()), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: buildListItem(context),
    );
  }

  Widget buildListItem(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CandidateDetail(candidate: widget.candidate),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                widget.candidate.Photo,
                width: 60.0,
                height: 60.0,
                fit: BoxFit.cover,
              ),
            ),
            title: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                widget.candidate.Name,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            subtitle: Text(
              widget.candidate.skills,
              style: TextStyle(fontSize: 16.0),
            ),
            trailing: Icon(Icons.read_more),
          ),
        ),
      ),
    );
  }
}
