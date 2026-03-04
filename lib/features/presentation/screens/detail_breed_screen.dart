import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/breed_entity.dart';
import '../utils/colors.dart';
import '../viewmodels/detail_breed_viewmodel.dart';
import '../widgets/app_card.dart';
import '../widgets/back_button_circle.dart';
import '../widgets/error_view.dart';
import '../widgets/rating_stars.dart';
import '../widgets/section_block.dart';
import '../widgets/title_text.dart';

class DetailBreedScreen extends StatelessWidget {
  final BreedEntity breed;

  const DetailBreedScreen({super.key, required this.breed});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailBreedViewModel(breed),
      child: const _BreedDetailBody(),
    );
  }
}

class _BreedDetailBody extends StatelessWidget {
  const _BreedDetailBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DetailBreedViewModel>();
    final breed = vm.breed;
    final topPad = MediaQuery.of(context).padding.top;

    if (vm.error != null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
          child: ErrorView(message: vm.error!, onRetry: vm.retry),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: topPad + 80, bottom: 40),
                child: AppCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleText(breed.name),
                      const SizedBox(height: 20),
                      SectionBlock(title: 'Описание', text: breed.description),
                      SectionBlock(
                        title: 'Страна происхождения',
                        text: breed.origin,
                      ),
                      SectionBlock(
                        title: 'Темперамент',
                        text: breed.temperament,
                      ),
                      const SizedBox(height: 20),
                      _ratingRow('Интеллект', breed.intelligence),
                      _ratingRow('Энергичность', breed.energyLevel),
                      _ratingRow('Ласковость', breed.affectionLevel),
                      _ratingRow('Социализация', breed.socialNeeds),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: topPad + 8,
              left: 16,
              child: BackButtonCircle(onTap: () => Navigator.pop(context)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ratingRow(String title, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white)),
          RatingStars(value: value),
        ],
      ),
    );
  }
}
