import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class TrialShare extends StatelessWidget {
  const TrialShare({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Share.share(
            'Check out this app:https://www.amazon.in/s?k=amazon+store&adgrpid=1324913119028843&hvadid=82807336469050&hvbmt=be&hvdev=c&hvlocphy=156819&hvnetw=o&hvqmt=e&hvtargid=kwd-82807953181429%3Aloc-90&hydadcr=5841_2377831&mcid=d17f61a153c834b29fc5bdc0513a116c&msclkid=a40b52a996a712b201e53aeb1a27cf63&tag=msndeskstdin-21&ref=pd_sl_9j8zni217u_e');
      },
      child: Icon(Icons.share, color: Colors.white, size: 30),
    );
  }
}
