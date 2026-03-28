import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/plant.dart';
import '../providers/plant_provider.dart';

class PlantDetailScreen extends StatefulWidget {
  final Plant plant;

  const PlantDetailScreen({super.key, required this.plant});

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Загружаем журнал именно для этого растения
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlantProvider>().fetchCareLogs(widget.plant.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final plantProvider = context.watch<PlantProvider>();
    final logs = plantProvider.getCareLogsForPlant(widget.plant.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plant.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.local_florist, size: 120, color: Colors.green),
            const SizedBox(height: 16),
            Text(widget.plant.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            Text(widget.plant.species, style: const TextStyle(fontSize: 20, color: Colors.grey)),
            if (widget.plant.location != null) ...[
              const SizedBox(height: 8),
              Text("📍 ${widget.plant.location!}", style: const TextStyle(fontSize: 16)),
            ],

            const SizedBox(height: 32),
            const Text("Журнал ухода", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            if (logs.isEmpty)
              const Text("Пока нет записей ухода")
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  return ListTile(
                    leading: const Icon(Icons.history, color: Colors.green),
                    title: Text(log.action),
                    subtitle: Text(log.notes ?? ''),
                    trailing: Text(
                      DateFormat('dd.MM.yyyy HH:mm').format(log.date),
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                },
              ),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Добавить запись ухода"),
              onPressed: () => _showAddCareLogDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCareLogDialog(BuildContext context) {
    final actions = ["Полив", "Удобрение", "Пересадка", "Опрыскивание", "Обрезка"];
    String selectedAction = actions[0];
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Новая запись ухода"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: selectedAction,
              items: actions.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
              onChanged: (v) => selectedAction = v ?? actions[0],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(labelText: "Примечание (необязательно)"),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Отмена")),
          ElevatedButton(
            onPressed: () async {
              final success = await context.read<PlantProvider>().addCareLog(
                widget.plant.id,
                selectedAction,
                notesController.text.isEmpty ? null : notesController.text,
              );
              if (success) Navigator.pop(ctx);
            },
            child: const Text("Сохранить"),
          ),
        ],
      ),
    );
  }
}
