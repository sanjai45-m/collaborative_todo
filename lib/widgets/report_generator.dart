import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';

class ReportGenerator {

  static Future<void> generatePDFReport(
      BuildContext context,
      TodoProvider provider,
      ) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => pw.Container(
          alignment: pw.Alignment.center,
          margin: const pw.EdgeInsets.only(bottom: 20),
          child: pw.Text(
            'Todo List Report',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
        ),
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 20),
          child: pw.Text(
            'Generated on: ${dateFormat.format(now)}',
            style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
          ),
        ),
        build: (context) => [
          _buildSummarySection(provider),
          pw.Divider(),
          pw.SizedBox(height: 20),
          _buildTasksSection(provider, dateFormat),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final fileName = 'todo_report_${now.millisecondsSinceEpoch}.pdf';
    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Todo List Report',
    );

    print('✅ PDF report generated: $fileName');
  }

  static Future<void> shareTextReport(
      BuildContext context,
      TodoProvider provider,
      ) async {
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    final StringBuffer report = StringBuffer();
    report.writeln('📋 TODO LIST REPORT');
    report.writeln('=' * 40);
    report.writeln('Generated: ${dateFormat.format(now)}');
    report.writeln('=' * 40);
    report.writeln();

    report.writeln('📊 SUMMARY');
    report.writeln('-' * 20);
    report.writeln('Total Tasks: ${provider.todos.length}');
    report.writeln('Pending: ${provider.getStatusCounts()[TodoStatus.pending]}');
    report.writeln('In Progress: ${provider.getStatusCounts()[TodoStatus.in_progress]}');
    report.writeln('Completed: ${provider.getStatusCounts()[TodoStatus.completed]}');
    report.writeln();

    report.writeln('📝 TASKS');
    report.writeln('-' * 40);
    report.writeln();

    for (var i = 0; i < provider.todos.length; i++) {
      final todo = provider.todos[i];
      report.writeln('${i + 1}. ${todo.title}');
      report.writeln('   Status: ${todo.status.displayName}');
      report.writeln('   Description: ${todo.description}');
      report.writeln('   Created by: ${todo.createdBy}');
      report.writeln('   Last updated: ${dateFormat.format(todo.updatedAt)}');
      report.writeln();
    }

    report.writeln('=' * 40);
    report.writeln('End of Report');

    final output = await getTemporaryDirectory();
    final fileName = 'todo_report_${now.millisecondsSinceEpoch}.txt';
    final file = File('${output.path}/$fileName');
    await file.writeAsString(report.toString());

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Todo List Report',
    );

    print('✅ Text report generated: $fileName');
  }

  static pw.Widget _buildSummarySection(TodoProvider provider) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Summary',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem('Total Tasks', provider.todos.length.toString()),
              _buildSummaryItem(
                'Pending',
                provider.getStatusCounts()[TodoStatus.pending].toString(),
              ),
              _buildSummaryItem(
                'In Progress',
                provider.getStatusCounts()[TodoStatus.in_progress].toString(),
              ),
              _buildSummaryItem(
                'Completed',
                provider.getStatusCounts()[TodoStatus.completed].toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryItem(String label, String value) {
    return pw.Container(
      width: 100,
      child: pw.Column(
        children: [
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            label,
            style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTasksSection(TodoProvider provider, DateFormat dateFormat) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Tasks',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        ...provider.todos.map((todo) => _buildTaskItem(todo, dateFormat)).toList(),
      ],
    );
  }

  static pw.Widget _buildTaskItem(Todo todo, DateFormat dateFormat) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 15),
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                todo.title,
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: pw.BoxDecoration(
                  color: _getStatusColor(todo.status),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
                ),
                child: pw.Text(
                  todo.status.displayName,
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.white),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            todo.description,
            style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Created by: ${todo.createdBy}',
                style: pw.TextStyle(fontSize: 8, color: PdfColors.grey),
              ),
              pw.Text(
                'Updated: ${dateFormat.format(todo.updatedAt)}',
                style: pw.TextStyle(fontSize: 8, color: PdfColors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static PdfColor _getStatusColor(TodoStatus status) {
    switch (status) {
      case TodoStatus.pending:
        return PdfColors.orange;
      case TodoStatus.in_progress:
        return PdfColors.blue;
      case TodoStatus.completed:
        return PdfColors.green;
    }
  }
}
