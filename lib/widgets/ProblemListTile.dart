import 'package:code_sprout/models/ProblemArchive.dart';
import 'package:flutter/material.dart';

class ProblemListTile extends StatelessWidget {
  final VoidCallback? onTap;
  final ProblemArchive problem;

  const ProblemListTile({super.key, required this.problem, this.onTap});
  
  @override
  Widget build(BuildContext context) {
    final theme=Theme.of(context);
    
    return ExpansionTile(
      title: Text(
        problem.title,
        style: const TextStyle(color: Colors.white)),
      textColor: Colors.white,
      iconColor: Colors.white,
      backgroundColor: theme.primaryColor,
      collapsedBackgroundColor: theme.primaryColor.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      trailing: IconButton(
          onPressed: onTap,
          icon: Icon(Icons.read_more, color: Colors.white)),
      children: [Text(problem.description ?? "")],
      controlAffinity: ListTileControlAffinity.leading,
      leading: Icon(Icons.numbers,color: Colors.white,),
    );
  }
}

/*
ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text('$itemNo', style: const TextStyle(color: Colors.white)),
      ),
      trailing: imageUrl!=null ? ClipOval(child: CircleAvatar(radius: 24,child: Image.network(fit: BoxFit.fitHeight,imageUrl!,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const CircularProgressIndicator();
          },
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported_outlined)),)) : null,
      key: key,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64), side: BorderSide(color: Theme.of(context).primaryColor)),
      title: Text(text,softWrap: false,maxLines: 1,overflow: TextOverflow.ellipsis,),
      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      onTap: onTap,
    )
* */