import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

abstract final class AppIcons {
  static IconData get about => light(FontAwesomeIcons.user);
  static IconData get projects => light(FontAwesomeIcons.layerGroup);
  static IconData get contact => light(FontAwesomeIcons.commentDots);
  static IconData get send => solid(FontAwesomeIcons.paperPlane);
  static IconData get menu => light(FontAwesomeIcons.bars);
  static IconData get work => solid(FontAwesomeIcons.briefcase);
  static IconData get mail => solid(FontAwesomeIcons.envelope);
  static IconData get location => light(FontAwesomeIcons.locationDot);
  static IconData get folder => light(FontAwesomeIcons.folderOpen);
  static IconData get arrowForward => solid(FontAwesomeIcons.arrowRight);
  static IconData get arrowExternal => solid(FontAwesomeIcons.arrowUpRightFromSquare);
  static IconData get code => solid(FontAwesomeIcons.code);
  static IconData get resume => solid(FontAwesomeIcons.fileLines);
  static IconData get github => brandIcon(FontAwesomeIcons.github);
  static IconData get linkedin => brandIcon(FontAwesomeIcons.linkedin);
  static IconData get mobile => light(FontAwesomeIcons.mobile);
  static IconData get bolt => solid(FontAwesomeIcons.bolt);
  static IconData get calendar => solid(FontAwesomeIcons.calendarCheck);
  static IconData get remote => solid(FontAwesomeIcons.houseLaptop);
  static IconData get android => brandIcon(FontAwesomeIcons.android);
  static IconData get apple => brandIcon(FontAwesomeIcons.apple);
  static IconData get googlePlay => brandIcon(FontAwesomeIcons.googlePlay);

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
