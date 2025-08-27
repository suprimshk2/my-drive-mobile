import 'package:flutter/material.dart';
import 'package:mydrivenepal/feature/communications/screens/comms-listing/comms_screen.dart';
import 'package:mydrivenepal/feature/dashboard/screen/dashboard_screen.dart';

import 'package:mydrivenepal/shared/constant/image_constants.dart';
import '../../episode/episode.dart';
import '../../info/info.dart';
import '../../tasks/screen/task_screen.dart';

const List<NavItem> NAV_ITEMS = [
  NavItem(
    icon: ImageConstants.IC_LAYERS,
    activeIcon: ImageConstants.IC_LAYERS_FILL,
    label: 'Activity',
  ),
  NavItem(
    icon: ImageConstants.IC_CHECKLIST,
    activeIcon: ImageConstants.IC_CHECKLIST,
    label: 'Offers',
  ),
  NavItem(
    icon: '',
    activeIcon: '',
    label: 'Home',
  ),
  NavItem(
    icon: ImageConstants.IC_MAIL,
    activeIcon: ImageConstants.IC_MAIL_FILL,
    label: 'Communications',
  ),
  NavItem(
    icon: ImageConstants.IC_INFO_CIRCLE,
    activeIcon: ImageConstants.IC_INFO_CIRCLE_FILL,
    label: 'Info',
  ),
];

final List<Widget> PAGES = [
  EpisodeScreen(),
  TaskScreen(),
  DashboardScreen(),
  CommsScreen(),
  InformationScreen(),
];

class NavItem {
  final String icon;
  final String activeIcon;
  final String label;

  const NavItem(
      {required this.icon, required this.activeIcon, required this.label});
}
