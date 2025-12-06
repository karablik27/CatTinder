import 'package:cattinder/models/cat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/detail_cat_viewmodel.dart';

import '../utils/colors.dart';
import '../widgets/error_view.dart';
import '../widgets/title_text.dart';
import '../widgets/app_card.dart';
import '../widgets/section_block.dart';
import '../widgets/rating_stars.dart';
import '../widgets/back_button_circle.dart';

class DetailCatScreen extends StatelessWidget {
  final Cat cat;

  const DetailCatScreen({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailCatViewModel(cat),
      child: const _DetailCatBody(),
    );
  }
}

class _DetailCatBody extends StatelessWidget {
  const _DetailCatBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DetailCatViewModel>();
    final breed = vm.cat.fullBreed;
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
            Column(
              children: [
                SizedBox(height: topPad + 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      TitleText(vm.cat.generatedName ?? "Без имени"),
                      const SizedBox(height: 6),
                      Text(
                        vm.cat.breedName ?? "Без породы",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                AppCard(
                  padding: EdgeInsets.zero,
                  child: Image.network(
                    vm.cat.url,
                    height: 330,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.error, color: Colors.red, size: 64),
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: AppCard(
                    child: breed == null ? _noBreedInfo() : _breedInfo(breed),
                  ),
                ),
              ],
            ),

            Positioned(
              top: topPad + 12,
              left: 16,
              child: BackButtonCircle(onTap: () => Navigator.pop(context)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _breedInfo(breed) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(breed.name),
          const SizedBox(height: 14),

          SectionBlock(title: "Описание", text: breed.description),
          SectionBlock(title: "Страна происхождения", text: breed.origin),
          SectionBlock(title: "Темперамент", text: breed.temperament),

          const SizedBox(height: 20),

          _ratingRow("Интеллект", breed.intelligence),
          _ratingRow("Энергичность", breed.energyLevel),
          _ratingRow("Ласковость", breed.affectionLevel),
          _ratingRow("Социализация", breed.socialNeeds),
        ],
      ),
    );
  }

  Widget _noBreedInfo() {
    return const Center(
      child: Text(
        "У этого котика нет информации о породе 🐾",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          height: 1.4,
          fontWeight: FontWeight.w600,
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
