import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RetryAgain extends StatelessWidget {
  final Function()? onRetry;
  final String error;

  const RetryAgain({
    super.key,
    required this.onRetry,
    required this.error
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRetry,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.refresh,color: Colors.redAccent,size: 35,),
            const SizedBox(height: 12),
            Text(error,style: const TextStyle(color: Colors.redAccent,fontFamily: 'monospace',fontSize: 16),softWrap: true)
          ],
        ),
      ),
    );
  }
}
