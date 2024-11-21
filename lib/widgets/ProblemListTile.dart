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

  const ProblemListTile({super.key, required this.problem, this.onTap,this.onPlatformTap});
  
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Wrap(spacing: 16,children: [Text(problem.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),Text(problem.category.value.capitalize(),style: TextStyle(letterSpacing: 1.1,color: problem.category==ProblemCategory.EASY ? Colors.green : (problem.category==ProblemCategory.MEDIUM ? Colors.orangeAccent : Colors.red),fontWeight: FontWeight.bold),)],),
      backgroundColor: Colors.green.withOpacity(0.1),
      collapsedBackgroundColor: Colors.green.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0),side: const BorderSide(color: Colors.black)),
      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0),side: const BorderSide(color: Colors.black)),
      subtitle: Wrap(
        children: problem.platforms
            .map((platform) => IconButton(
            onPressed: onPlatformTap!=null ? ()=>onPlatformTap!(platform.redirectUrl):null,
            icon: SvgPicture.asset(
                  'assets/platforms/${platform.title.toLowerCase()}.svg',
                  width: 24,fit: BoxFit.fitHeight,
                )))
            .toList()..add(IconButton(onPressed:() => _sharePlatformLinks(problem.platforms) , icon: const Icon(Icons.share))),
      ),
      trailing: IconButton(
          onPressed: onTap,
          icon: const Icon(Icons.read_more,color: Colors.black)),
      controlAffinity: ListTileControlAffinity.leading,
      leading: const Icon(Icons.numbers,color: Colors.black),
      children: [Text(problem.description ?? "")],
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