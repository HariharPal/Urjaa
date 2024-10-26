import 'package:flutter/material.dart';
import 'package:solar/core/theme/app_pallete.dart';
import 'package:solar/features/home/model/project_model.dart';
import 'package:solar/features/home/view/pages/homeScreen/project_page.dart';

class CustomTile extends StatelessWidget {
  final ProjectModel projectModel;

  const CustomTile({
    super.key,
    required this.projectModel,
  });

  @override
  Widget build(BuildContext context) {
    String truncateString(String text, int maxWords) {
      List<String> words = text.split(' ');
      if (words.length <= maxWords) {
        return text;
      }
      return '${words.take(maxWords).join(' ')}...';
    }

    return Card(
      margin: const EdgeInsets.all(10),
      color: Palette.smokeWhite,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(
          color: Colors.white,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              projectModel.name,
              style: const TextStyle(color: Palette.textColor, fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              truncateString(projectModel.description, 8),
              style: const TextStyle(
                color: Palette.textColor,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[900],
              ),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProjectPage(projectModel: projectModel),
                  )),
              child: const Text(
                'View Details',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
