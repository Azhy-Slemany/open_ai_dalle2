import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:open_ai_dalle2/custom_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(AppLocalizations.of(context)!.about),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Text(AppLocalizations.of(context)!.aboutText)),
    );
  }
}
