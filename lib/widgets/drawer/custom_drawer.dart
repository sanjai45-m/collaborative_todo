import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/todo_provider.dart';
import 'drawer_header.dart';
import 'connection_status_card.dart';
import 'export_section.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, provider, child) {
        return Drawer(
          child: Container(
            color: Colors.white70,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeaderWidget(),
                ConnectionStatusCard(provider: provider),
                const Divider(),
                ExportSection(provider: provider),
              ],
            ),
          ),
        );
      },
    );
  }
}
