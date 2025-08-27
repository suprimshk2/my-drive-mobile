import 'package:mydrivenepal/feature/auth/screen/widgets/banner_widget.dart';
import 'package:mydrivenepal/feature/banner/banner_viewmodel.dart';
import 'package:mydrivenepal/feature/banner/data/model/banner_response_model.dart';
import 'package:mydrivenepal/feature/dashboard/constant/dashboard_string.dart';
import 'package:mydrivenepal/feature/tasks/task_listing_viewmodel.dart';
import 'package:mydrivenepal/feature/tasks/widgets/task_tile_widget.dart';
import 'package:mydrivenepal/feature/topic/data/model/topic_response_model.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/feature/dashboard/widgets/custom_appbar.dart';
import 'package:mydrivenepal/feature/episode/screen/widgets/support_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/widget/empty_state/empty_state_widget.dart';
import 'package:mydrivenepal/widget/error_states/connection_error_widget.dart';
import 'package:mydrivenepal/widget/error_states/generic_error_widget.dart';
import 'package:mydrivenepal/widget/scaffold/bottom_bar_viewmodel.dart';
import 'package:mydrivenepal/widget/shimmer/dashboard_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../di/di.dart';
import '../../../shared/shared.dart';
import '../../../widget/chip/rounded_chip_widget.dart';
import '../../../widget/widget.dart';
import '../../auth/screen/login/login_viewmodel.dart';
import '../../episode/episode.dart';
import '../../tasks/constants/task_strings.dart';
import '../dashboard_viewmodel.dart';
import '../disclaimer_viewmodel.dart';
import '../widgets/disclaimer_bottomsheet.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final viewModel = locator<DashboardViewModel>();
  final disclaimerViewModel = locator<DisclaimerViewModel>();
  final _bannerViewModel = locator<BannerViewModel>();
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _searchPickController = TextEditingController();

  @override
  void initState() {
    getData();
    _tabController = TabController(length: 3, vsync: this);

    super.initState();
  }

  Future<void> getData() async {
    viewModel.loadDashboardData();
  }

  Future<void> _onRefresh() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
    _refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ChangeNotifierProvider<DashboardViewModel>(
        create: (_) => viewModel,
        child: ChangeNotifierProvider<LoginViewModel>(
            create: (_) => locator<LoginViewModel>(),
            child: ScaffoldWidget(
              showTransparentStatusBar: true,
              bottom: 0,
              padding: Dimens.spacing_8,
              showAppbar: false,
              child: Consumer<DashboardViewModel>(
                  builder: (context, dashboardViewModel, child) {
                return Consumer<LoginViewModel>(
                  builder: (context, loginViewModel, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // CustomDashboardAppBar(
                        //   onIdCardTap: () =>
                        //       context.pushNamed(AppRoute.idCard.name),
                        //   userName: dashboardViewModel.name,
                        // ),
                        Expanded(
                          child: SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: false,
                            controller: _refreshController,
                            onRefresh: _onRefresh,
                            child: Column(
                              children: [
                                // Header
                                _buildHeader(),

                                // Search Bar
                                _buildSearchBar(),

                                // Tab Bar
                                _buildTabBar(),

                                // Content
                                Expanded(
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      _buildRecentTab(),
                                      _buildSavedTab(),
                                      _buildMissingPlaceTab(),
                                    ],
                                  ),
                                ),

                                // Bottom Action Bar
                                _buildBottomActionBar(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
            )));
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.navigation,
                size: 18,
                color: Colors.blue[600],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _searchPickController,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  hintText: 'Search for a place',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Handle custom address
                      },
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: Colors.black87,
                      ),
                      label: const Text(
                        'Custom Address',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Handle set on map
                      },
                      icon: const Icon(
                        Icons.navigation,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Set On Map',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context)
                            .extension<AppColorExtension>()!
                            .primary
                            .soft,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: 128,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                Icons.location_on,
                color: Theme.of(context)
                    .extension<AppColorExtension>()!
                    .primary
                    .main,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(fontSize: 16),
                  decoration: const InputDecoration(
                    hintText: 'Where are you going?',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .extension<AppColorExtension>()!
                      .primary
                      .main,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildTabButton('Recent', 0),
                const SizedBox(width: 4),
                _buildTabButton('Saved', 1),
                const SizedBox(width: 4),
                _buildTabButton('Missing Place', 2),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: Colors.grey[100],
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = _tabController.index == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _tabController.animateTo(index);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).extension<AppColorExtension>()!.primary.subtle
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(
                  color: Theme.of(context)
                      .extension<AppColorExtension>()!
                      .primary
                      .soft)
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? Theme.of(context).extension<AppColorExtension>()!.primary.main
                : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentTab() {
    return Container(
      color: Colors.white,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: recentLocations.length,
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(left: 72, right: 16),
          child: Container(height: 1, color: Colors.grey[100]),
        ),
        itemBuilder: (context, index) {
          final location = recentLocations[index];
          return _buildLocationItem(location);
        },
      ),
    );
  }

  Widget _buildSavedTab() {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No saved places yet',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissingPlaceTab() {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.help_outline,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Help us improve by reporting missing places',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationItem(LocationItem location) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          // Handle location selection
          Navigator.pop(context, location);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.history,
                  size: 20,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  location.name,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.grey[400],
                  size: 20,
                ),
                onPressed: () {
                  _showLocationOptions(location);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpSection() {
    return Container(
      margin: const EdgeInsets.only(top: 32),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Need Help?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          _buildHelpItem(
            icon: Icons.edit_outlined,
            iconColor: Colors.blue,
            title: 'Try Address Builder to create an address from scratch',
            onTap: () {
              // Handle address builder
            },
          ),
          _buildHelpItem(
            icon: Icons.add_circle_outline,
            iconColor: Colors.green,
            title:
                'If a place isn\'t showing up, help us improve by adding it to our system',
            onTap: () {
              // Handle add missing place
            },
          ),
        ],
      ),
    );
  }

  void _showLocationOptions(LocationItem location) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.bookmark_border),
                title: const Text('Save Location'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle save location
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle share
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context)
                      .extension<AppColorExtension>()!
                      .primary
                      .main,
                ),
                title: Text('Remove from Recent',
                    style: TextStyle(
                        color: Theme.of(context)
                            .extension<AppColorExtension>()!
                            .primary
                            .main)),
                onTap: () {
                  Navigator.pop(context);
                  // Handle remove
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _buildGreetingText(DashboardViewModel dashboardViewModel) {
    final appColors = context.appColors;

    final name = dashboardViewModel.name.split(' ').first;
    return Padding(
      padding: EdgeInsets.only(left: Dimens.spacing_8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
              text: greetingTime(),
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.caption.copyWith(
                    color: appColors.textSubtle,
                  )),
          TextWidget(
              text: name,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.subtitle.copyWith(
                    color: appColors.textInverse,
                  )),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// Models
class LocationItem {
  final int id;
  final String name;
  final LocationType type;

  LocationItem({
    required this.id,
    required this.name,
    required this.type,
  });
}

enum LocationType {
  recent,
  saved,
  missing,
}

final List<LocationItem> recentLocations = [
  LocationItem(
    id: 1,
    name: "Chetrapati, Paknajol, Chhetrapati Chowk, KTM",
    type: LocationType.recent,
  ),
  LocationItem(
    id: 2,
    name: "Stilly Inn, Maitri Marg, Bakhundol, Lalitpur",
    type: LocationType.recent,
  ),
  LocationItem(
    id: 3,
    name: "Purple Haze, Chaksibari Marg, Thamel, KTM",
    type: LocationType.recent,
  ),
  LocationItem(
    id: 4,
    name:
        "Eden Garden English School, 26DR002, Balkot, Anantalingeshwor, Bhaktapur, Ba...",
    type: LocationType.recent,
  ),
  LocationItem(
    id: 5,
    name:
        "Prayag Pokhari, Prayag Pokhari To Kumaripati Road, Prayag Pokhari, Patan, ...",
    type: LocationType.recent,
  ),
];
// ==================== MOCK MODELS ====================

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// // Mock LatLng class (replace with actual google_maps_flutter import)
// class LatLng {
//   final double latitude;
//   final double longitude;

//   const LatLng(this.latitude, this.longitude);

//   @override
//   String toString() => 'LatLng($latitude, $longitude)';

//   @override
//   bool operator ==(Object other) =>
//       other is LatLng &&
//       other.latitude == latitude &&
//       other.longitude == longitude;

//   @override
//   int get hashCode => latitude.hashCode ^ longitude.hashCode;
// }

// class PlacemarkData {
//   final String? name;
//   final String? address;
//   final LatLng latLng;
//   final Map<String, dynamic>? metadata;

//   const PlacemarkData({
//     this.name,
//     this.address,
//     required this.latLng,
//     this.metadata,
//   });

//   PlacemarkData copyWith({
//     String? name,
//     String? address,
//     LatLng? latLng,
//     Map<String, dynamic>? metadata,
//   }) {
//     return PlacemarkData(
//       name: name ?? this.name,
//       address: address ?? this.address,
//       latLng: latLng ?? this.latLng,
//       metadata: metadata ?? this.metadata,
//     );
//   }
// }

// class NavigationData {
//   final PlacemarkData start;
//   final PlacemarkData end;
//   final List<LatLng>? route;
//   final double? distance;
//   final Duration? estimatedTime;

//   const NavigationData({
//     required this.start,
//     required this.end,
//     this.route,
//     this.distance,
//     this.estimatedTime,
//   });
// }

// enum MapMode {
//   idle,
//   navigation,
//   locationPicker,
//   event,
//   form,
// }

// class MapState {
//   final MapMode mode;
//   final NavigationData? navigationData;
//   final PlacemarkData? selectedLocation;
//   final LatLng? currentPosition;
//   final bool isLoading;
//   final String? error;
//   final bool isDiversionVisible;
//   final String? title;

//   const MapState({
//     this.mode = MapMode.idle,
//     this.navigationData,
//     this.selectedLocation,
//     this.currentPosition,
//     this.isLoading = false,
//     this.error,
//     this.isDiversionVisible = false,
//     this.title,
//   });

//   MapState copyWith({
//     MapMode? mode,
//     NavigationData? navigationData,
//     PlacemarkData? selectedLocation,
//     LatLng? currentPosition,
//     bool? isLoading,
//     String? error,
//     bool? isDiversionVisible,
//     String? title,
//   }) {
//     return MapState(
//       mode: mode ?? this.mode,
//       navigationData: navigationData ?? this.navigationData,
//       selectedLocation: selectedLocation ?? this.selectedLocation,
//       currentPosition: currentPosition ?? this.currentPosition,
//       isLoading: isLoading ?? this.isLoading,
//       error: error ?? this.error,
//       isDiversionVisible: isDiversionVisible ?? this.isDiversionVisible,
//       title: title ?? this.title,
//     );
//   }
// }

// // ==================== MOCK VIEWMODEL ====================

// class MockMapViewModel extends ChangeNotifier {
//   MapState _state = const MapState();
//   MapState get state => _state;

//   // Mock data
//   static const _mockCurrentPosition =
//       LatLng(37.7749, -122.4194); // San Francisco
//   static const _mockDestination = LatLng(37.7849, -122.4094); // Near SF

//   MockMapViewModel() {
//     // Initialize with current position
//     _state = _state.copyWith(currentPosition: _mockCurrentPosition);
//   }

//   void _updateState(MapState newState) {
//     _state = newState;
//     notifyListeners();
//   }

//   // ==================== NAVIGATION METHODS ====================

//   Future<void> startNavigation({PlacemarkData? destination}) async {
//     if (_state.mode == MapMode.navigation) return;

//     _updateState(_state.copyWith(isLoading: true));

//     // Simulate API delay
//     await Future.delayed(const Duration(seconds: 1));

//     final destinationData = destination ??
//         const PlacemarkData(
//           name: 'Mock Destination',
//           address: '123 Mock Street, San Francisco, CA',
//           latLng: _mockDestination,
//         );

//     final mockNavigationData = NavigationData(
//       start: const PlacemarkData(
//         name: 'Current Location',
//         address: 'Your current location',
//         latLng: _mockCurrentPosition,
//       ),
//       end: destinationData,
//       route: _generateMockRoute(_mockCurrentPosition, destinationData.latLng),
//       distance: 2.5, // km
//       estimatedTime: const Duration(minutes: 8),
//     );

//     _updateState(_state.copyWith(
//       mode: MapMode.navigation,
//       navigationData: mockNavigationData,
//       isLoading: false,
//       title: destinationData.name ?? 'Navigate',
//     ));
//   }

//   Future<void> stopNavigation() async {
//     _updateState(_state.copyWith(
//       mode: MapMode.idle,
//       navigationData: null,
//       isDiversionVisible: false,
//       title: null,
//     ));
//   }

//   // ==================== LOCATION PICKER METHODS ====================

//   void startLocationPicker({
//     LatLng? initialPoint,
//     String? title,
//     required Function(PlacemarkData?) onConfirm,
//   }) {
//     _onConfirmCallback = onConfirm;

//     _updateState(_state.copyWith(
//       mode: MapMode.locationPicker,
//       selectedLocation:
//           initialPoint != null ? PlacemarkData(latLng: initialPoint) : null,
//       title: title ?? 'Select Location',
//     ));
//   }

//   Function(PlacemarkData?)? _onConfirmCallback;

//   void confirmLocationSelection() {
//     final selectedLocation = _state.selectedLocation;

//     _updateState(_state.copyWith(
//       mode: MapMode.idle,
//       selectedLocation: null,
//       title: null,
//     ));

//     _onConfirmCallback?.call(selectedLocation);
//     _onConfirmCallback = null;
//   }

//   void updateSelectedLocation(LatLng location) {
//     if (_state.mode == MapMode.locationPicker ||
//         _state.mode == MapMode.event ||
//         _state.mode == MapMode.form) {
//       _updateState(_state.copyWith(
//         selectedLocation: PlacemarkData(
//           name: 'Selected Location',
//           address:
//               'Lat: ${location.latitude.toStringAsFixed(4)}, Lng: ${location.longitude.toStringAsFixed(4)}',
//           latLng: location,
//         ),
//       ));
//     }
//   }

//   // ==================== EVENT MODE METHODS ====================

//   void startEventMode({
//     LatLng? initialPoint,
//     String? title,
//     required VoidCallback onComplete,
//   }) {
//     _onEventCompleteCallback = onComplete;

//     _updateState(_state.copyWith(
//       mode: MapMode.event,
//       selectedLocation:
//           initialPoint != null ? PlacemarkData(latLng: initialPoint) : null,
//       title: title ?? 'Event Location',
//     ));
//   }

//   VoidCallback? _onEventCompleteCallback;

//   // ==================== FORM MODE METHODS ====================

//   void startFormMode({
//     LatLng? initialPoint,
//     String? title,
//     required Function(PlacemarkData?) onConfirm,
//   }) {
//     _onFormConfirmCallback = onConfirm;

//     _updateState(_state.copyWith(
//       mode: MapMode.form,
//       selectedLocation:
//           initialPoint != null ? PlacemarkData(latLng: initialPoint) : null,
//       title: title,
//     ));
//   }

//   Function(PlacemarkData?)? _onFormConfirmCallback;

//   // ==================== GENERAL METHODS ====================

//   void exitCurrentMode() {
//     switch (_state.mode) {
//       case MapMode.locationPicker:
//         confirmLocationSelection();
//         break;
//       case MapMode.event:
//         _onEventCompleteCallback?.call();
//         _onEventCompleteCallback = null;
//         _updateState(_state.copyWith(mode: MapMode.idle, title: null));
//         break;
//       case MapMode.form:
//         _onFormConfirmCallback?.call(_state.selectedLocation);
//         _onFormConfirmCallback = null;
//         _updateState(_state.copyWith(mode: MapMode.idle, title: null));
//         break;
//       case MapMode.navigation:
//         stopNavigation();
//         break;
//       default:
//         _updateState(_state.copyWith(mode: MapMode.idle));
//     }
//   }

//   void clearError() {
//     _updateState(_state.copyWith(error: null));
//   }

//   void setDiversionVisibility(bool visible) {
//     _updateState(_state.copyWith(isDiversionVisible: visible));
//   }

//   // Mock methods for testing different states
//   void simulateError() {
//     _updateState(_state.copyWith(
//       error: 'Mock error: Unable to connect to navigation service',
//       isLoading: false,
//     ));
//   }

//   void simulateLoading() {
//     _updateState(_state.copyWith(isLoading: true));
//   }

//   void simulateDiversion() {
//     _updateState(_state.copyWith(isDiversionVisible: true));
//   }

//   // Helper method to generate mock route
//   List<LatLng> _generateMockRoute(LatLng start, LatLng end) {
//     // Generate a simple route with some waypoints
//     final route = <LatLng>[];
//     route.add(start);

//     // Add some intermediate points to simulate a route
//     final latDiff = (end.latitude - start.latitude) / 4;
//     final lngDiff = (end.longitude - start.longitude) / 4;

//     for (int i = 1; i < 4; i++) {
//       route.add(LatLng(
//         start.latitude + (latDiff * i),
//         start.longitude + (lngDiff * i),
//       ));
//     }

//     route.add(end);
//     return route;
//   }
// }

// // ==================== MOCK MAP SCREEN ====================

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   late MockMapViewModel _viewModel;

//   @override
//   void initState() {
//     super.initState();
//     _viewModel = MockMapViewModel();
//   }

//   @override
//   void dispose() {
//     _viewModel.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Mock Map UI'),
//         actions: [
//           // Debug buttons for testing different states
//           PopupMenuButton<String>(
//             onSelected: (value) {
//               switch (value) {
//                 case 'error':
//                   _viewModel.simulateError();
//                   break;
//                 case 'loading':
//                   _viewModel.simulateLoading();
//                   break;
//                 case 'diversion':
//                   _viewModel.simulateDiversion();
//                   break;
//                 case 'picker':
//                   _showLocationPicker();
//                   break;
//                 case 'event':
//                   _showEventMode();
//                   break;
//                 case 'form':
//                   _showFormMode();
//                   break;
//               }
//             },
//             itemBuilder: (context) => [
//               const PopupMenuItem(value: 'error', child: Text('Test Error')),
//               const PopupMenuItem(
//                   value: 'loading', child: Text('Test Loading')),
//               const PopupMenuItem(
//                   value: 'diversion', child: Text('Test Diversion')),
//               const PopupMenuItem(
//                   value: 'picker', child: Text('Location Picker')),
//               const PopupMenuItem(value: 'event', child: Text('Event Mode')),
//               const PopupMenuItem(value: 'form', child: Text('Form Mode')),
//             ],
//           ),
//         ],
//       ),
//       body: AnimatedBuilder(
//         animation: _viewModel,
//         builder: (context, child) {
//           return Stack(
//             children: [
//               // Mock Map (colored container)
//               _buildMockMap(),

//               // Mode-specific overlays
//               _buildModeOverlay(_viewModel),

//               // Loading indicator
//               if (_viewModel.state.isLoading)
//                 Container(
//                   color: Colors.black26,
//                   child: const Center(
//                     child: CircularProgressIndicator(),
//                   ),
//                 ),

//               // Error display
//               if (_viewModel.state.error != null)
//                 _buildErrorOverlay(_viewModel),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildMockMap() {
//     return Container(
//       color: Colors.grey[200],
//       child: Stack(
//         children: [
//           // Mock map background
//           const Center(
//             child: Text(
//               '🗺️ MOCK MAP',
//               style: TextStyle(fontSize: 24, color: Colors.grey),
//             ),
//           ),

//           // Mock markers
//           if (_viewModel.state.currentPosition != null)
//             const Positioned(
//               left: 100,
//               top: 200,
//               child: Icon(Icons.my_location, color: Colors.blue, size: 30),
//             ),

//           if (_viewModel.state.navigationData != null)
//             const Positioned(
//               right: 100,
//               top: 300,
//               child: Icon(Icons.location_on, color: Colors.red, size: 30),
//             ),

//           if (_viewModel.state.selectedLocation != null)
//             const Positioned(
//               left: 150,
//               top: 250,
//               child: Icon(Icons.place, color: Colors.orange, size: 30),
//             ),

//           // Tap detector for mock map interaction
//           Positioned.fill(
//             child: GestureDetector(
//               onTapUp: (details) {
//                 final position = LatLng(
//                   37.7749 + (details.localPosition.dy / 1000 - 0.2),
//                   -122.4194 + (details.localPosition.dx / 1000 - 0.2),
//                 );
//                 _handleMapTap(position);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _handleMapTap(LatLng position) {
//     switch (_viewModel.state.mode) {
//       case MapMode.locationPicker:
//       case MapMode.event:
//       case MapMode.form:
//         _viewModel.updateSelectedLocation(position);
//         break;
//       default:
//         break;
//     }
//   }

//   Widget _buildModeOverlay(MockMapViewModel viewModel) {
//     switch (viewModel.state.mode) {
//       case MapMode.navigation:
//         return _buildNavigationOverlay(viewModel);
//       case MapMode.locationPicker:
//         return _buildLocationPickerOverlay(viewModel);
//       case MapMode.event:
//         return _buildEventModeOverlay(viewModel);
//       case MapMode.form:
//         return _buildFormModeOverlay(viewModel);
//       case MapMode.idle:
//       default:
//         return _buildIdleModeOverlay(viewModel);
//     }
//   }

//   Widget _buildNavigationOverlay(MockMapViewModel viewModel) {
//     final navData = viewModel.state.navigationData;

//     return Positioned(
//       top: MediaQuery.of(context).padding.top + 16,
//       left: 16,
//       right: 16,
//       child: Card(
//         elevation: 8,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     viewModel.state.title ?? 'Navigation',
//                     style: Theme.of(context).textTheme.headlineSmall,
//                   ),
//                   IconButton(
//                     onPressed: () => viewModel.stopNavigation(),
//                     icon: const Icon(Icons.close),
//                   ),
//                 ],
//               ),
//               if (navData != null) ...[
//                 const SizedBox(height: 8),
//                 Text(
//                     'From: ${navData.start.name ?? navData.start.address ?? 'Unknown'}'),
//                 Text(
//                     'To: ${navData.end.name ?? navData.end.address ?? 'Unknown'}'),
//                 if (navData.distance != null)
//                   Text('Distance: ${navData.distance!.toStringAsFixed(1)} km'),
//                 if (navData.estimatedTime != null)
//                   Text('ETA: ${navData.estimatedTime!.inMinutes} minutes'),
//               ],
//               if (viewModel.state.isDiversionVisible) ...[
//                 const SizedBox(height: 8),
//                 const Text(
//                   'Diversion detected',
//                   style: TextStyle(
//                       color: Colors.orange, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLocationPickerOverlay(MockMapViewModel viewModel) {
//     return Positioned(
//       bottom: 32,
//       left: 16,
//       right: 16,
//       child: Card(
//         elevation: 8,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 viewModel.state.title ?? 'Select Location',
//                 style: Theme.of(context).textTheme.headlineSmall,
//               ),
//               const SizedBox(height: 8),
//               const Text('Tap on the mock map to select a location'),
//               if (viewModel.state.selectedLocation != null) ...[
//                 const SizedBox(height: 8),
//                 Text(
//                   'Selected: ${viewModel.state.selectedLocation!.latLng}',
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ],
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () => viewModel.exitCurrentMode(),
//                     child: const Text('Cancel'),
//                   ),
//                   ElevatedButton(
//                     onPressed: viewModel.state.selectedLocation != null
//                         ? () => viewModel.confirmLocationSelection()
//                         : null,
//                     child: const Text('Confirm'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEventModeOverlay(MockMapViewModel viewModel) {
//     return Positioned(
//       bottom: 32,
//       left: 16,
//       right: 16,
//       child: Card(
//         elevation: 8,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 viewModel.state.title ?? 'Event Location',
//                 style: Theme.of(context).textTheme.headlineSmall,
//               ),
//               const SizedBox(height: 8),
//               const Text('Select event location on the mock map'),
//               if (viewModel.state.selectedLocation != null) ...[
//                 const SizedBox(height: 8),
//                 Text(
//                   'Event at: ${viewModel.state.selectedLocation!.latLng}',
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ],
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () => viewModel.exitCurrentMode(),
//                     child: const Text('Cancel'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () => viewModel.exitCurrentMode(),
//                     child: const Text('Save Event'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFormModeOverlay(MockMapViewModel viewModel) {
//     return Positioned(
//       bottom: 32,
//       left: 16,
//       right: 16,
//       child: Card(
//         elevation: 8,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 viewModel.state.title ?? 'Form Location',
//                 style: Theme.of(context).textTheme.headlineSmall,
//               ),
//               if (viewModel.state.selectedLocation != null) ...[
//                 const SizedBox(height: 8),
//                 Text(
//                   'Form location: ${viewModel.state.selectedLocation!.latLng}',
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ],
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () => viewModel.exitCurrentMode(),
//                 child: const Text('Done'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildIdleModeOverlay(MockMapViewModel viewModel) {
//     return Positioned(
//       bottom: 32,
//       right: 16,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           FloatingActionButton(
//             heroTag: 'location_picker',
//             onPressed: () => _showLocationPicker(),
//             child: const Icon(Icons.location_on),
//           ),
//           const SizedBox(height: 8),
//           FloatingActionButton(
//             heroTag: 'navigation',
//             onPressed: () => _startNavigation(),
//             child: const Icon(Icons.navigation),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorOverlay(MockMapViewModel viewModel) {
//     return Positioned(
//       top: MediaQuery.of(context).padding.top + 16,
//       left: 16,
//       right: 16,
//       child: Card(
//         color: Colors.red.shade100,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             children: [
//               const Icon(Icons.error, color: Colors.red),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   viewModel.state.error!,
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               ),
//               IconButton(
//                 onPressed: () => viewModel.clearError(),
//                 icon: const Icon(Icons.close, color: Colors.red),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showLocationPicker() {
//     _viewModel.startLocationPicker(
//       title: 'Pick a Location',
//       onConfirm: (location) {
//         if (location != null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                   'Selected: ${location.name ?? location.latLng.toString()}'),
//             ),
//           );
//         }
//       },
//     );
//   }

//   void _showEventMode() {
//     _viewModel.startEventMode(
//       title: 'Create Event',
//       onComplete: () {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Event created!')),
//         );
//       },
//     );
//   }

//   void _showFormMode() {
//     _viewModel.startFormMode(
//       title: 'Address Form',
//       onConfirm: (location) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//                 'Form submitted with: ${location?.latLng ?? 'No location'}'),
//           ),
//         );
//       },
//     );
//   }

//   void _startNavigation() {
//     final destination = const PlacemarkData(
//       name: 'Sample Destination',
//       address: 'Downtown San Francisco',
//       latLng: LatLng(37.7849, -122.4094),
//     );

//     _viewModel.startNavigation(destination: destination);
//   }
// }

// // ==================== MAIN APP ====================

// void main() {
//   runApp(const MockMapApp());
// }

// class MockMapApp extends StatelessWidget {
//   const MockMapApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Mock Map UI',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         useMaterial3: true,
//       ),
//       home: const DashboardScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
