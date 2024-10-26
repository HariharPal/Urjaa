import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar/core/theme/app_pallete.dart';
import 'package:solar/features/home/view/widgets/custom_tile.dart';
import 'package:solar/features/home/view/widgets/search_tile.dart';
import 'package:solar/features/home/viewmodel/home_viewmodel.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final allProjects = ref.watch(fetchProductsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Urjaa",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 22,
                color: Palette.smokeWhite,
                fontWeight: FontWeight.w600,
              ),
        ),
        backgroundColor: Palette.secondaryColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/op90.png"), fit: BoxFit.cover),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const SizedBox(height: 10),
            SearchTile(hintText: "Search", controller: _searchController),
            const SizedBox(height: 20),
            Expanded(
              child: allProjects.when(
                data: (projects) => ListView.builder(
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final project = projects[index];
                    print(project);
                    return CustomTile(
                      projectModel: project,
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text(error.toString())),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
