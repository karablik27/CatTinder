import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/usecases/get_random_cat_with_generated_name_usecase.dart';
import '../utils/colors.dart';
import '../viewmodels/main_viewmodel.dart';
import '../widgets/app_card.dart';
import '../widgets/error_view.dart';
import '../widgets/title_text.dart';
import 'detail_cat_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainViewModel(
        getRandomCatWithGeneratedName: context
            .read<GetRandomCatWithGeneratedNameUseCase>(),
      )..loadCat(),
      child: const _MainBody(),
    );
  }
}

class _MainBody extends StatefulWidget {
  const _MainBody();

  @override
  State<_MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<_MainBody> with TickerProviderStateMixin {
  double dragX = 0;
  double dragY = 0;

  late AnimationController swipeController;
  late Animation<Offset> swipeOffset;
  late AnimationController likePulseController;

  @override
  void initState() {
    super.initState();

    swipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    likePulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
  }

  @override
  void dispose() {
    swipeController.dispose();
    likePulseController.dispose();
    super.dispose();
  }

  void animateSwipe(bool toRight, VoidCallback onEnd) {
    swipeOffset = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(toRight ? 3 : -3, 0.5),
    ).animate(CurvedAnimation(parent: swipeController, curve: Curves.easeOut));

    swipeController.forward().then((_) {
      swipeController.reset();
      dragX = 0;
      dragY = 0;
      onEnd();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MainViewModel>();
    final cat = vm.cat;

    if (vm.error != null && !vm.snackbarShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        vm.snackbarShown = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(vm.error!), backgroundColor: Colors.red),
        );
      });
    }

    return Container(
      decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
      child: SafeArea(
        child: vm.loading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : vm.error != null && cat == null
            ? ErrorView(
                message: vm.error!,
                onRetry: () {
                  vm.snackbarShown = false;
                  vm.loadCat();
                },
              )
            : cat == null
            ? const Center(
                child: Text(
                  'Нет данных 😿',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              )
            : _mainUI(context, vm),
      ),
    );
  }

  Widget _mainUI(BuildContext context, MainViewModel vm) {
    final cat = vm.cat!;

    return Column(
      children: [
        const SizedBox(height: 20),
        const TitleText('CatTinder', fontSize: 28),
        const SizedBox(height: 12),
        ScaleTransition(
          scale: Tween<double>(begin: 1.0, end: 1.25).animate(
            CurvedAnimation(parent: likePulseController, curve: Curves.easeOut),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.favorite, color: Colors.redAccent, size: 22),
                const SizedBox(width: 8),
                Text(
                  vm.likes.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 25),
        Expanded(
          child: GestureDetector(
            onPanUpdate: (d) {
              setState(() {
                dragX += d.delta.dx;
                dragY += d.delta.dy;
              });
            },
            onPanEnd: (_) {
              if (dragX > 120) {
                animateSwipe(true, () {
                  vm.like();
                  likePulseController.forward(from: 0);
                });
              } else if (dragX < -120) {
                animateSwipe(false, vm.dislike);
              } else {
                dragX = 0;
                dragY = 0;
                setState(() {});
              }
            },
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DetailCatScreen(cat: cat)),
            ),
            child: Center(
              child: AnimatedBuilder(
                animation: swipeController,
                builder: (context, child) {
                  final offset = swipeController.isAnimating
                      ? swipeOffset.value
                      : Offset(dragX / 300, dragY / 300);

                  final rotation = swipeController.isAnimating
                      ? swipeOffset.value.dx * 0.4
                      : dragX / 300;

                  return Transform.translate(
                    offset: Offset(offset.dx * 300, offset.dy * 60),
                    child: Transform.rotate(angle: rotation, child: child),
                  );
                },
                child: AppCard(
                  padding: EdgeInsets.zero,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 360,
                          child: Image.network(
                            cat.url,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              TitleText(
                                cat.generatedName ?? 'Без имени',
                                fontSize: 26,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                cat.breedName ?? 'Без породы',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 26),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _roundButton(Icons.close, Colors.redAccent, () {
              animateSwipe(false, vm.dislike);
            }),
            const SizedBox(width: 40),
            _roundButton(Icons.favorite, Colors.greenAccent, () {
              likePulseController.forward(from: 0);
              animateSwipe(true, vm.like);
            }),
          ],
        ),
        const SizedBox(height: 26),
      ],
    );
  }

  Widget _roundButton(IconData icon, Color glow, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: glow.withValues(alpha: 0.5),
              blurRadius: 28,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(icon, color: glow, size: 36),
      ),
    );
  }
}
