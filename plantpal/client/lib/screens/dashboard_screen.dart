import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/plant_provider.dart';
import '../providers/auth_provider.dart';
import 'plant_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlantProvider>().fetchPlants();
    });
  }

  @override
  Widget build(BuildContext context) {
    final plantProvider = context.watch<PlantProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои растения 🌱'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: plantProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : plantProvider.plants.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.local_florist, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Пока нет растений', style: TextStyle(fontSize: 20)),
                      Text('Нажмите "+" чтобы добавить', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.78,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: plantProvider.plants.length,
                  itemBuilder: (context, index) {
                    final plant = plantProvider.plants[index];
                    final plantLogs = plantProvider.getCareLogsForPlant(plant.id).take(3).toList();

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PlantDetailScreen(plant: plant),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.local_florist, size: 48, color: Colors.green),
                              const SizedBox(height: 12),

                              Text(
                                plant.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                plant.species,
                                style: const TextStyle(color: Colors.grey, fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 16),

                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Последний уход",
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.green),
                                    ),
                                    const SizedBox(height: 8),
                                    if (plantLogs.isEmpty)
                                      const Text(
                                        "Пока нет записей",
                                        style: TextStyle(fontSize: 13, color: Colors.grey),
                                      )
                                    else
                                      Column(
                                        children: plantLogs.map((log) {
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 4),
                                            child: Row(
                                              children: [
                                                _getActionIcon(log.action),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    log.action,
                                                    style: const TextStyle(fontSize: 13),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text(
                                                  DateFormat('dd.MM').format(log.date),
                                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                  ],
                                ),
                              ),

                              const Spacer(),
                              if (plant.location != null)
                                Text(
                                  "📍 ${plant.location}",
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPlantDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _getActionIcon(String action) {
    final lower = action.toLowerCase();
    if (lower.contains('полив')) return const Icon(Icons.water_drop, size: 16, color: Colors.blue);
    if (lower.contains('удобр')) return const Icon(Icons.eco, size: 16, color: Colors.orange);
    if (lower.contains('пересад')) return const Icon(Icons.change_circle, size: 16, color: Colors.brown);
    if (lower.contains('опрыск')) return const Icon(Icons.spa, size: 16, color: Colors.lightBlue);
    if (lower.contains('обрез')) return const Icon(Icons.content_cut, size: 16, color: Colors.green);
    return const Icon(Icons.history, size: 16, color: Colors.grey);
  }

  void _showAddPlantDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final speciesCtrl = TextEditingController();
    int categoryId = 1;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Новое растение'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Название')),
            const SizedBox(height: 12),
            TextField(controller: speciesCtrl, decoration: const InputDecoration(labelText: 'Вид / сорт')),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              value: categoryId,
              decoration: const InputDecoration(labelText: 'Категория'),
              items: const [
                DropdownMenuItem(value: 1, child: Text('Суккуленты')),
                DropdownMenuItem(value: 2, child: Text('Тропические')),
                DropdownMenuItem(value: 3, child: Text('Цветущие')),
                DropdownMenuItem(value: 4, child: Text('Папоротники')),
                DropdownMenuItem(value: 5, child: Text('Кактусы')),
                DropdownMenuItem(value: 6, child: Text('Пальмы')),
                DropdownMenuItem(value: 7, child: Text('Бонсай')),
                DropdownMenuItem(value: 8, child: Text('Орхидеи')),
              ],
              onChanged: (v) => categoryId = v ?? 1,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty || speciesCtrl.text.trim().isEmpty) return;
              await context.read<PlantProvider>().addPlant(
                    name: nameCtrl.text.trim(),
                    species: speciesCtrl.text.trim(),
                    categoryId: categoryId,
                  );
              Navigator.pop(ctx);
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }
}
