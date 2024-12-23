import 'package:code_sprout/extensions/string-etension.dart';
import 'package:code_sprout/models/ProblemArchive.dart';
import 'package:code_sprout/models/ProblemPlatform.dart';
import 'package:code_sprout/models/enums/ProblemCategory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

class ProblemListTile extends StatelessWidget {
  final VoidCallback? onTap;
  final Function(String url)? onPlatformTap;
  final ProblemArchive problem;
  final bool allowExpansion = false;

  const ProblemListTile(
      {super.key, required this.problem, this.onTap, this.onPlatformTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        Positioned(
          bottom: 5,
          right: 12,
          child: Text(problem.difficulty.value.capitalize(),
              style: TextStyle(
                  letterSpacing: 1.1,
                  color: problem.difficulty == ProblemDifficulty.EASY
                      ? Colors.green
                      : (problem.difficulty == ProblemDifficulty.MEDIUM
                          ? Colors.orangeAccent
                          : Colors.red),
                  fontWeight: FontWeight.bold)),
        ),
        ExpansionTile(
          dense: true,
          title: Text(problem.title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black)),
          tilePadding: const EdgeInsets.only(left: 8, right: 54),
          backgroundColor: Colors.green.withOpacity(0.1),
          collapsedBackgroundColor: Colors.green.withOpacity(0.05),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              side: const BorderSide(color: Colors.black)),
          collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              side: const BorderSide(color: Colors.black)),
          subtitle: problem.platforms.isEmpty ? Text("No platforms found") : Padding(
            padding: const EdgeInsets.all(8.0).copyWith(left: 0),
            child: Wrap(
              spacing: 12,
              children: [...problem.platforms
                  .map((platform) => GestureDetector(
                      onTap: onPlatformTap != null
                          ? () => onPlatformTap!(platform.redirectUrl)
                          : null,
                      child: SvgPicture.asset(
                        'assets/platforms/${platform.title.toLowerCase()}.svg',
                        width: 24,
                        fit: BoxFit.cover,
                      ))),GestureDetector(
                  onTap: () => _sharePlatformLinks(problem.platforms),
                  child: const Icon(
                    Icons.share,
                    size: 24,
                    color: Colors.black,
                  ))],
            ),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          leading: const Icon(Icons.numbers, color: Colors.black),
          childrenPadding: const EdgeInsets.all(12).copyWith(top: 0),
          children: [Text(problem.description ?? "")],
        ),
        Positioned(
            top: 5,
            right: 5,
            child: IconButton(
                onPressed: onTap,
                icon: const Icon(Icons.ads_click, color: Colors.black))),
      ],
    );
  }

  void _sharePlatformLinks(List<ProblemPlatform> platforms) {
    // Format the array into a string
    String formattedString = platforms.map((platform) {
      return '${platform.title} : ${platform.redirectUrl}';
    }).join('\n\n'); // Double newlines for separation

    // Share the formatted string
    Share.share(formattedString);
  }
}
