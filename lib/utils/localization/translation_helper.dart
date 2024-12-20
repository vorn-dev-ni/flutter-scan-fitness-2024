import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension TranslationHelperStateless on StatelessWidget {
  AppLocalizations tr(BuildContext context) {
    return AppLocalizations.of(context)!;
  }
}

extension TranslationHelperStateful<T extends StatefulWidget> on State<T> {
  AppLocalizations tr(BuildContext context) {
    return AppLocalizations.of(context)!;
  }
}
