import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

abstract final class AppIcons {
  static IconData get about => light(FontAwesomeIcons.user);
  static IconData get projects => light(FontAwesomeIcons.layerGroup);
  static IconData get contact => light(FontAwesomeIcons.commentDots);
  static IconData get logo => solid(FontAwesomeIcons.bolt);
  static IconData get send => solid(FontAwesomeIcons.paperPlane);
  static IconData get menu => light(FontAwesomeIcons.bars);
  static IconData get work => solid(FontAwesomeIcons.briefcase);
  static IconData get mail => solid(FontAwesomeIcons.envelope);
  static IconData get location => light(FontAwesomeIcons.locationDot);
  static IconData get folder => light(FontAwesomeIcons.folderOpen);
  static IconData get arrowForward => solid(FontAwesomeIcons.arrowRight);
  static IconData get arrowExternal => solid(FontAwesomeIcons.arrowUpRightFromSquare);
  static IconData get code => solid(FontAwesomeIcons.code);

  static IconData solid(IconData icon) => IconData(
        icon.codePoint,
        fontFamily: 'FontAwesomeSolid',
        matchTextDirection: icon.matchTextDirection,
      );

  static IconData regular(IconData icon) => IconData(
        icon.codePoint,
        fontFamily: 'FontAwesomeRegular',
        matchTextDirection: icon.matchTextDirection,
      );

  static IconData light(IconData icon) => IconData(
        icon.codePoint,
        fontFamily: 'FontAwesomeLight',
        matchTextDirection: icon.matchTextDirection,
      );

  static IconData brandIcon(IconData icon) => IconData(
        icon.codePoint,
        fontFamily: 'FontAwesomeBrands',
        matchTextDirection: icon.matchTextDirection,
      );
}
