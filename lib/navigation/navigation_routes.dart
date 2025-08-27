import 'package:mydrivenepal/feature/auth/data/model/verify_code_response.dart';
import 'package:mydrivenepal/feature/auth/screen/reset_password/reset_password_screen.dart';
import 'package:mydrivenepal/feature/auth/screen/user-activation/user_activation_screen.dart';
import 'package:mydrivenepal/feature/auth/screen/user-activation/user_welcome_screen.dart';
import 'package:mydrivenepal/feature/communications/screens/comet_chat_messages_screen.dart';
import 'package:mydrivenepal/feature/dashboard/screen/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/feature/dashboard/screen/ride_booking_screen.dart';
import 'package:mydrivenepal/feature/episode/data/model/milestone_detail_screen_params.dart';
import 'package:mydrivenepal/feature/episode/episode.dart';
import 'package:mydrivenepal/feature/tasks/data/model/status_model_for_callback.dart';
import 'package:mydrivenepal/feature/tasks/screen/task-types/message_screen.dart';
import 'package:mydrivenepal/feature/tasks/screen/task-types/signature_screen.dart';
import 'package:mydrivenepal/feature/topic/screen/topic_screen.dart';
import 'package:mydrivenepal/feature/landing/landing_screen.dart';
import 'package:mydrivenepal/feature/profile/screen/profile_screen.dart';
import 'package:mydrivenepal/feature/user-mode/user_mode.dart';
import 'package:mydrivenepal/feature/tasks/screen/task-types/acknowledgement_screen.dart';
import 'package:mydrivenepal/feature/tasks/screen/task-types/question_screen.dart';
import 'package:mydrivenepal/feature/tasks/screen/task-types/questionnaire_screen.dart';
import 'package:mydrivenepal/feature/tasks/screen/task-types/todo_screen.dart';
import 'package:mydrivenepal/shared/constant/route_names.dart';

import '../di/service_locator.dart';
import '../feature/auth/auth.dart';
import '../feature/auth/screen/forgot_password/forgot_password_screen.dart';
import '../feature/auth/screen/forgot_password/otp_verification_screen.dart';
import '../feature/auth/screen/forgot_password/set_password_screen.dart';
import '../feature/id-card/id_card.dart';
import '../feature/info/info.dart';
import '../feature/onboarding/onboarding_screen.dart';
import '../feature/request-eoc/request_eoc.dart';
import '../feature/request-eoc/screen/select_episode_screen.dart';
import '../feature/request-eoc/screen/success_screen.dart';
import '../feature/tasks/screen/task_screen.dart';
import 'navigation_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final NavigationService navigationService = locator<NavigationService>();

final navigationRouter = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: navigationService.initialRoute,
  routes: [
    GoRoute(
      pageBuilder: (context, state) => horizontalSlideTransitionNavigation(
          context, state, const OnBoardingScreen()),
      path: RouteNames.onBoarding,
      name: AppRoute.onBoarding.name,
    ),
    GoRoute(
      pageBuilder: (context, state) => horizontalSlideTransitionNavigation(
          context, state, const LoginScreen()),
      path: RouteNames.login,
      name: AppRoute.login.name,
    ),
    GoRoute(
      pageBuilder: (context, state) => horizontalSlideTransitionNavigation(
          context, state, const RequestEpisodeOfCareScreen()),
      path: RouteNames.requestEOC,
      name: RouteNames.requestEOC,
    ),
    GoRoute(
      pageBuilder: (context, state) => horizontalSlideTransitionNavigation(
          context, state, const EocSelectScreen()),
      path: RouteNames.selectEOC,
      name: AppRoute.selectEOC.name,
      builder: (context, state) => const EocSelectScreen(),
    ),
    GoRoute(
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        final isPasswordSet = (data['isPasswordSet'] as bool?) ?? false;
        final isPasswordChanged = (data['isPasswordChanged'] as bool?) ?? false;
        final isRequestEOC = (data['isRequestEOC'] as bool?) ?? false;

        return horizontalSlideTransitionNavigation(
          context,
          state,
          SuccessScreen(
            isPasswordChanged: isPasswordChanged,
            isPasswordSet: isPasswordSet,
            isRequestEOC: isRequestEOC,
          ),
        );
      },
      path: RouteNames.success,
      name: AppRoute.success.name,
    ),
    GoRoute(
      pageBuilder: (context, state) => horizontalSlideTransitionNavigation(
          context, state, const ForgotPasswordScreen()),
      path: RouteNames.forgotPassword,
      name: AppRoute.forgotPassword.name,
    ),
    GoRoute(
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        final phoneNumber = data['phoneNumber'] ?? "";
        return horizontalSlideTransitionNavigation(
            context, state, OtpVerificationScreen(phoneNumber: phoneNumber));
      },
      path: RouteNames.otpVerification,
      name: AppRoute.otpVerification.name,
    ),
    GoRoute(
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        final phoneNumber = data['phoneNumber'] ?? "";
        final uuId = data['uuId'] ?? "";
        return horizontalSlideTransitionNavigation(
          context,
          state,
          SetPasswordScreen(phoneNumber: phoneNumber, uuId: uuId),
        );
      },
      path: RouteNames.setPasswordForgot,
      name: AppRoute.setPasswordForgot.name,
    ),
    GoRoute(
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        final code = data['code'] ?? '';
        return horizontalSlideTransitionNavigation(
            context, state, ResetPasswordScreen(code: code));
      },
      path: RouteNames.resetPassword,
      name: AppRoute.resetPassword.name,
    ),
    GoRoute(
      pageBuilder: (context, state) {
        final code = state.uri.query.replaceAll("code=", "");

        return horizontalSlideTransitionNavigation(
            context,
            state,
            WelcomeToSwaddleScreen(
              code: code,
            ));
      },
      path: RouteNames.activateAccount,
      name: AppRoute.activateAccount.name,
    ),
    GoRoute(
      path: RouteNames.setPasswordForActivation,
      name: AppRoute.setPasswordForActivation.name,
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        String code = data['code'] ?? '';
        User? user = data['user'] as User?;

        return horizontalSlideTransitionNavigation(context, state,
            SetPasswordToActivateScreen(code: code, user: user));
      },
    ),
    GoRoute(
      pageBuilder: (context, state) {
        return horizontalSlideTransitionNavigation(
            context, state, const DashboardScreen());
      },
      path: RouteNames.dashboard,
      name: AppRoute.dashboard.name,
    ),
    GoRoute(
      pageBuilder: (context, state) => horizontalSlideTransitionNavigation(
          context, state, const InformationScreen()),
      path: RouteNames.info,
      name: AppRoute.info.name,
    ),
    // GoRoute(
    //   pageBuilder: (context, state) =>
    //       fadeTransitionNavigation(context, state, const LoginScreen()),
    //   path: RouteNames.login,
    //   name: RouteNames.login,
    //   builder: (context, state) => const LoginScreen(),
    //   routes: [
    //     // GoRoute(
    //     //   path: 'review',
    //     //   name: RouteNames.leaveReview.name,
    //     //   pageBuilder: (context, state) {
    //     //     final productId = state.pathParameters['id']!;
    //     //     return MaterialPage(
    //     //       fullscreenDialog: true,
    //     //       child: LeaveReviewScreen(productId: productId),
    //     //     );
    //     //   },
    //     // ),
    //   ],
    // ),
    GoRoute(
      pageBuilder: (context, state) => horizontalSlideTransitionNavigation(
          context, state, const RequestEpisodeOfCareScreen()),
      path: RouteNames.requestEOC,
      name: AppRoute.requestEOC.name,
    ),
    GoRoute(
      pageBuilder: (context, state) {
        return horizontalSlideTransitionNavigation(
            context, state, RideBookingScreen());
      },
      path: RouteNames.landing,
      name: AppRoute.landing.name,
    ),
    GoRoute(
      pageBuilder: (context, state) {
        return horizontalSlideTransitionNavigation(
            context, state, const MemberIdCardsScreen());
      },
      path: RouteNames.idCard,
      name: AppRoute.idCard.name,
    ),
    GoRoute(
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        final episodeId = data['episodeId'] ?? "";
        return horizontalSlideTransitionNavigation(
            context, state, EpisodeDetailScreen(episodeId: episodeId));
      },
      path: RouteNames.episodeDetail,
      name: AppRoute.episodeDetail.name,
    ),
    GoRoute(
      pageBuilder: (context, state) => horizontalSlideTransitionNavigation(
          context, state, const ProfileScreen()),
      path: RouteNames.profile,
      name: AppRoute.profile.name,
    ),
    GoRoute(
      pageBuilder: (context, state) {
        final milestoneDetailScreenParams =
            state.extra as MilestoneDetailScreenParams;

        return horizontalSlideTransitionNavigation(
          context,
          state,
          TopicScreen(milestoneDetailScreenParams: milestoneDetailScreenParams),
        );
      },
      path: RouteNames.milestoneDetail,
      name: AppRoute.milestoneDetail.name,
    ),
    GoRoute(
      pageBuilder: (context, state) => horizontalSlideTransitionNavigation(
          context, state, const TaskScreen()),
      path: RouteNames.task,
      name: AppRoute.task.name,
    ),
    // task-types
    GoRoute(
      path: RouteNames.todo,
      name: AppRoute.todo.name,
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        // Task task = data['task'] as Task;
        final taskId = data['taskId'] as String;
        final milestoneId = data['milestoneId'] as String;
        final episodeId = data['episodeId'] as String;

        return horizontalSlideTransitionNavigation(
            context,
            state,
            TodoScreen(
              isFromNotification: data['isFromNotification'] as bool,
              taskId: taskId,
              milestoneId: milestoneId,
              episodeId: episodeId,
            ));
      },
    ),
    GoRoute(
      path: RouteNames.acknowledgement,
      name: AppRoute.acknowledgement.name,
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final isFromNotification = data['isFromNotification'] as bool;
        final taskId = data['taskId'] as String;
        final milestoneId = data['milestoneId'] as String;
        final episodeId = data['episodeId'] as String;

        return horizontalSlideTransitionNavigation(
            context,
            state,
            AcknowledgementScreen(
              isFromNotification: isFromNotification,
              taskId: taskId,
              milestoneId: milestoneId,
              episodeId: episodeId,
            ));
      },
    ),

    GoRoute(
      path: RouteNames.question,
      name: AppRoute.question.name,
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final taskId = data['taskId'] as String;
        final milestoneId = data['milestoneId'] as String;
        final episodeId = data['episodeId'] as String;
        return horizontalSlideTransitionNavigation(
            context,
            state,
            QuestionScreen(
                isFromNotification: data['isFromNotification'] as bool,
                taskId: taskId,
                milestoneId: milestoneId,
                episodeId: episodeId));
      },
    ),

    GoRoute(
      path: RouteNames.qnr,
      name: AppRoute.qnr.name,
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final taskId = data['taskId'] as String;
        final milestoneId = data['milestoneId'] as String;
        final episodeId = data['episodeId'] as String;

        return horizontalSlideTransitionNavigation(
            context,
            state,
            QuestionnaireScreen(
                isFromNotification: data['isFromNotification'] as bool,
                taskId: taskId,
                milestoneId: milestoneId,
                episodeId: episodeId));
      },
    ),

    GoRoute(
      path: RouteNames.signature,
      name: AppRoute.signature.name,
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final isFromNotification = data['isFromNotification'] as bool;
        final taskId = data['taskId'] as String;
        final milestoneId = data['milestoneId'] as String;
        final episodeId = data['episodeId'] as String;

        return horizontalSlideTransitionNavigation(
            context,
            state,
            SignatureScreen(
              isFromNotification: isFromNotification,
              taskId: taskId,
              milestoneId: milestoneId,
              episodeId: episodeId,
            ));
      },
    ),

    GoRoute(
      path: RouteNames.message,
      name: AppRoute.message.name,
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final taskId = data['taskId'] as String;
        final milestoneId = data['milestoneId'] as String;
        final episodeId = data['episodeId'] as String;

        return horizontalSlideTransitionNavigation(
            context,
            state,
            MessageScreen(
              isFromNotification: data['isFromNotification'] as bool,
              taskId: taskId,
              milestoneId: milestoneId,
              episodeId: episodeId,
            ));
      },
    ),

    GoRoute(
      path: RouteNames.chat,
      name: AppRoute.chat.name,
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        String userId = data['userId'] as String;
        String fullName = data['fullName'] as String;
        bool isFromNotification = data['isFromNotification'] == true;

        return horizontalSlideTransitionNavigation(
          context,
          state,
          CometChatMessagesScreen(
            userId: userId,
            fullName: fullName,
            isFromNotification: isFromNotification,
          ),
        );
      },
    ),
    GoRoute(
      pageBuilder: (context, state) =>
          horizontalSlideTransitionNavigation(context, state, UserModeScreen()),
      path: RouteNames.userMode,
      name: AppRoute.userMode.name,
    ),
  ],
  // TODO: for 404 routes
  // errorBuilder: (context, state) => const NotFoundScreen(),
);

slideTransitionNavigation(
    BuildContext context, GoRouterState state, Widget widget) {
  const begin = Offset(1.0, 0.0);
  const end = Offset.zero;
  const curve = Curves.ease;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

  return CustomTransitionPage(
    transitionDuration: const Duration(milliseconds: 500),
    key: state.pageKey,
    child: widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeIn;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

horizontalSlideTransitionNavigation(
    BuildContext context, GoRouterState state, Widget widget) {
  const begin = Offset(0.0, 1.0);
  const end = Offset(1.0, 0.0);
  const curve = Curves.ease;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

  return CustomTransitionPage(
    transitionDuration: const Duration(milliseconds: 192),
    key: state.pageKey,
    child: widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeIn;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

fadeTransitionNavigation(
    BuildContext context, GoRouterState state, Widget widget) {
  const begin = Offset(0.0, 1.0);
  const end = Offset.zero;
  const curve = Curves.ease;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

  return CustomTransitionPage(
    transitionDuration: const Duration(milliseconds: 500),
    fullscreenDialog: true,
    key: state.pageKey,
    child: widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: child,
      );
    },
  );
}

PageRouteBuilder<T> fadePageRoute<T>({
  required Widget page,
  Duration duration = const Duration(milliseconds: 300),
}) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
