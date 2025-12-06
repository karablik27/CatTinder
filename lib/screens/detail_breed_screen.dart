import 'package:cattinder/models/breed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/detail_breed_viewmodel.dart';

import '../widgets/error_view.dart';
import '../widgets/title_text.dart';
import '../widgets/app_card.dart';
import '../widgets/section_block.dart';
import '../widgets/rating_stars.dart';
import '../widgets/back_button_circle.dart';
import '../utils/colors.dart';

class DetailBreedScreen extends StatelessWidget {
  final Breed breed;

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
    final b = vm.breed;

    final topPad = MediaQuery.of(context).padding.top;

    if (vm.error != null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
          child: ErrorView(
            message: vm.error!,
            onRetry: vm.retry,
          ),
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
                      TitleText(b.name),
                      const SizedBox(height: 20),

                      SectionBlock(
                        title: "Описание",
                        text: b.description,
                      ),
                      SectionBlock(
                        title: "Страна происхождения",
                        text: b.origin,
                      ),
                      SectionBlock(
                        title: "Темперамент",
                        text: b.temperament,
                      ),

                      const SizedBox(height: 20),

                      _ratingRow("Интеллект", b.intelligence),
                      _ratingRow("Энергичность", b.energyLevel),
                      _ratingRow("Ласковость", b.affectionLevel),
                      _ratingRow("Социализация", b.socialNeeds),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              top: topPad + 8,
              left: 16,
              child: BackButtonCircle(
                onTap: () => Navigator.pop(context),
              ),
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
