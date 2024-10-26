import 'package:flutter/material.dart';
import 'package:solar/core/theme/app_pallete.dart';
import 'package:solar/core/widget/utils.dart';
import 'package:solar/features/home/model/project_model.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key, required this.projectModel});
  final ProjectModel projectModel;

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  final TextEditingController _stockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(widget.projectModel);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Details",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 22,
                color: Palette.smokeWhite,
                fontWeight: FontWeight.w600,
              ),
        ),
        backgroundColor: Palette.secondaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
          child: Column(
            children: [
              Text(
                widget.projectModel.name,
                style: const TextStyle(
                  color: Palette.textColor,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                widget.projectModel.description,
                style: const TextStyle(
                  color: Palette.secondaryTextColor,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Text(
                    "Total Shares: ",
                    style: TextStyle(color: Palette.textColor, fontSize: 17),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${widget.projectModel.totalShares}",
                    style:
                        const TextStyle(color: Palette.textColor, fontSize: 17),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    "Shares Available: ",
                    style: TextStyle(color: Palette.textColor, fontSize: 17),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${widget.projectModel.sharesAvailable}",
                    style:
                        const TextStyle(color: Palette.textColor, fontSize: 17),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    "Carbon Reduction Per Stock: ",
                    style: TextStyle(color: Palette.textColor, fontSize: 17),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${widget.projectModel.carbonReducedPerStock}",
                    style:
                        const TextStyle(color: Palette.textColor, fontSize: 17),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    "Total Carbon Reduction ",
                    style: TextStyle(color: Palette.textColor, fontSize: 17),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${widget.projectModel.totalCarbonReduced}",
                    style:
                        const TextStyle(color: Palette.textColor, fontSize: 17),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter number of stocks',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String input = _stockController.text;
                  int? numberOfStocks = int.tryParse(input);

                  if (numberOfStocks != null && numberOfStocks > 0) {
                    //api calling

                    showToast(context,
                        content: 'Buying $numberOfStocks stocks',
                        type: ToastType.warning);
                  } else {
                    showToast(context,
                        content: "Please enter a valid number of stocks",
                        type: ToastType.warning);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Palette.secondaryColor, // Customize the button color
                ),
                child: const Text(
                  'Buy',
                  style: TextStyle(color: Palette.smokeWhite, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
