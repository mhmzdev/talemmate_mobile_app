import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/router/routes.dart';
import 'package:taleemmate/ui/widgets/core/bottom_bar/bottom_bar.dart';
import 'package:taleemmate/ui/widgets/headless/focus_handler.dart';

class Screen extends StatefulWidget {
  const Screen({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.keyboardHandler = false,
    this.resizeToAvoidBottomInset = false,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.scaffoldBackgroundColor,
    this.belowBuilders,
    this.overlayBuilders,
    this.initialFormValue,
    this.formKey,
    this.onBackPressed,
    this.canPop,
    this.appBar,
    this.bottomBarHeightChanged,
  });

  final Widget child;
  final EdgeInsets padding;
  final bool keyboardHandler;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? scaffoldBackgroundColor;
  final List<Widget>? belowBuilders; // listeners
  final List<Widget>? overlayBuilders; // builders
  final Map<String, dynamic>? initialFormValue;
  final GlobalKey<FormBuilderState>? formKey;
  final bool resizeToAvoidBottomInset;
  final void Function()? onBackPressed;
  final bool? canPop;
  final PreferredSizeWidget? appBar;
  final void Function(double height)? bottomBarHeightChanged;

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  final bottomBarKey = GlobalKey();

  double get _getBottomBarHeight {
    final renderBox =
        bottomBarKey.currentContext?.findRenderObject() as RenderBox?;
    final height = renderBox?.size.height ?? context.bottomSafe();
    return height;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.bottomBarHeightChanged?.call(_getBottomBarHeight);
    });
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);

    var body = widget.child;
    var onWillPop = widget.onBackPressed;
    var canPopValue = widget.canPop ?? true;

    const bottomBarRoutes = <String>[
      AppRoutes.home,
      AppRoutes.library,
      AppRoutes.tutor,
      AppRoutes.plan,
      AppRoutes.progress,
    ];

    final currentRoute = context.currentPath;
    final hasBottomBar = bottomBarRoutes.contains(currentRoute);

    if (widget.formKey != null) {
      body = FormBuilder(
        key: widget.formKey,
        initialValue: widget.initialFormValue ?? {},
        child: body,
      );
    }

    if (widget.keyboardHandler) {
      body = FocusHandler(child: body);
    }

    if (onWillPop == null && bottomBarRoutes.contains(currentRoute)) {
      onWillPop = () {
        const homeRoute = AppRoutes.home;
        homeRoute.pushReplace(context);
      };
      canPopValue = false;
    }

    if (onWillPop != null || !canPopValue) {
      body = PopScope(
        canPop: canPopValue,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && onWillPop != null) {
            onWillPop();
          }
        },
        child: body,
      );
    }

    body = Padding(padding: widget.padding, child: body);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarBrightness: Brightness.light, // for IOS
        statusBarIconBrightness: Brightness.dark, // for Android
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        backgroundColor:
            widget.scaffoldBackgroundColor ?? AppTheme.c.background,
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        appBar: widget.appBar,
        body: Stack(
          fit: StackFit.expand,
          children: [
            if (widget.belowBuilders != null) ...widget.belowBuilders!,
            Positioned.fill(child: body),
            if (hasBottomBar)
              Positioned(
                key: bottomBarKey,
                left: 0,
                right: 0,
                bottom: 0,
                child: const BottomBar(),
              ),
            if (widget.overlayBuilders != null) ...widget.overlayBuilders!,
          ],
        ),
      ),
    );
  }
}
