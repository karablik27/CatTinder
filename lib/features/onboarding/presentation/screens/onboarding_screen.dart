import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../presentation/utils/colors.dart';
import '../viewmodels/onboarding_viewmodel.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _controller;
  int _page = 0;

  static const _steps = [
    _OnboardingStep(
      title: 'Свайпай котиков',
      description:
          'Свайп вправо для лайка и влево для дизлайка. Можно использовать и кнопки снизу.',
      imageAsset: 'assets/onboarding_cat1.png',
    ),
    _OnboardingStep(
      title: 'Смотри детали',
      description:
          'Нажми на карточку кота, чтобы открыть подробную информацию о породе и характеристиках.',
      imageAsset: 'assets/onboarding_cat2.png',
    ),
    _OnboardingStep(
      title: 'Изучай породы',
      description:
          'Во второй вкладке доступен список пород с поиском и быстрым переходом в подробности.',
      imageAsset: 'assets/onboarding_cat3.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _nextOrFinish() async {
    final isLast = _page == _steps.length - 1;
    if (!isLast) {
      await _controller.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
      return;
    }

    await context.read<OnboardingViewModel>().finish();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OnboardingViewModel>();

    return Container(
      decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: vm.busy ? null : () => vm.finish(),
                    child: const Text('Пропустить'),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _steps.length,
                  onPageChanged: (index) => setState(() => _page = index),
                  itemBuilder: (context, index) {
                    final step = _steps[index];

                    return AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        final page = _controller.hasClients
                            ? (_controller.page ??
                                  _controller.initialPage.toDouble())
                            : 0.0;
                        final delta = (index - page).clamp(-1.0, 1.0);
                        final progress = 1 - delta.abs();
                        final scale = 0.88 + (progress * 0.12);
                        final translateX = delta * 42;
                        final translateY = (1 - progress) * 24;
                        final rotation = delta * 0.12;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                step.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 28,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                step.description,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 26),
                              Expanded(
                                child: Transform.translate(
                                  offset: Offset(translateX, translateY),
                                  child: Transform.rotate(
                                    angle: rotation,
                                    child: Transform.scale(
                                      scale: scale,
                                      child: Image.asset(
                                        step.imageAsset,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              _PageIndicator(
                                current: _page,
                                total: _steps.length,
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: vm.busy ? null : _nextOrFinish,
                    child: vm.busy
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_page == _steps.length - 1 ? 'Начать' : 'Далее'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int current;
  final int total;

  const _PageIndicator({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final selected = current == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          width: selected ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: selected ? 1 : 0.45),
            borderRadius: BorderRadius.circular(100),
          ),
        );
      }),
    );
  }
}

class _OnboardingStep {
  final String title;
  final String description;
  final String imageAsset;

  const _OnboardingStep({
    required this.title,
    required this.description,
    required this.imageAsset,
  });
}
