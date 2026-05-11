import 'package:flutter/material.dart';
// import 'package:frontend/utils/size_utils.dart';
import 'package:frontend/viewmodel/archive_view_model.dart';
import 'package:frontend/widgets/ces_archive_widget.dart';
import 'package:provider/provider.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key});

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  @override
  void initState() {
    super.initState();
    final viewModel = context.read<ArchiveViewModel>();

    viewModel.fetch();
  }

    // return Text("HELLO");
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ArchiveViewModel>();


    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1.8,
          crossAxisCount: 3
        ), 
        itemCount: viewModel.box.length,

        itemBuilder: (context, index) { 
          final cesInfo = viewModel.box[index];

          return CesArchiveWidget(infoActivity: cesInfo);

        }
      )
    );
  }
}