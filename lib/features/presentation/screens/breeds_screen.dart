import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/usecases/get_breeds_usecase.dart';
import '../utils/colors.dart';
import '../viewmodels/breeds_viewmodel.dart';
import '../widgets/error_view.dart';
import 'detail_breed_screen.dart';

class BreedsScreen extends StatelessWidget {
  const BreedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          BreedsViewModel(getBreeds: context.read<GetBreedsUseCase>())
            ..loadBreeds(),
      child: const _BreedsBody(),
    );
  }
}

class _BreedsBody extends StatelessWidget {
  const _BreedsBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BreedsViewModel>();

    return Container(
      decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: vm.updateSearch,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Поиск по названию или стране...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: vm.loading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : vm.error != null
                  ? ErrorView(message: vm.error!, onRetry: vm.loadBreeds)
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: vm.filteredBreeds.length,
                      itemBuilder: (_, i) {
                        final breed = vm.filteredBreeds[i];

                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailBreedScreen(breed: breed),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              gradient: AppColors.cardGradient,
                              borderRadius: BorderRadius.circular(26),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.28),
                                  blurRadius: 26,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        breed.name,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  breed.description.length > 120
                                      ? '${breed.description.substring(0, 120)}...'
                                      : breed.description,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white70,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  breed.origin,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
