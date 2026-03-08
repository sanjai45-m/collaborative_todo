import 'package:flutter/material.dart';
import '../../providers/todo_provider.dart';
import '../common/export_button.dart';
import '../status_chart.dart';
import '../report_generator.dart';

class ExportSection extends StatelessWidget {
  final TodoProvider provider;

  const ExportSection({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'EXPORT OPTIONS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),

          ExportButton(
            label: 'Export as PDF',
            icon: Icons.picture_as_pdf,
            color: Colors.red,
            onPressed: () => _generatePDFReport(context),
          ),
          const SizedBox(height: 8),

          ExportButton(
            label: 'View Chart',
            icon: Icons.pie_chart,
            color: Colors.purple,
            onPressed: () {
              Navigator.pop(context);
              _showStatusChart(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _generatePDFReport(BuildContext context) async {
    try {
      if (!context.mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialog(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Generating PDF report...'),
                ],
              ),
            ),
          );
        },
      );

      await ReportGenerator.generatePDFReport(context, provider);

      if (context.mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF report generated and shared successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating PDF: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showStatusChart(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const StatusChart(),
    );
  }
}
