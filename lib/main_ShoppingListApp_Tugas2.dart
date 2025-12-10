import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(MaterialApp(home: ShoppingListScreen()));
}

// Model Shopping Item
class ShoppingItem {
  String name;
  int quantity;
  String category;
  bool isBought;

  ShoppingItem({
    required this.name,
    required this.quantity,
    required this.category,
    this.isBought = false,
  });

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      name: json['name'],
      quantity: json['quantity'],
      category: json['category'],
      isBought: json['isBought'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'category': category,
      'isBought': isBought,
    };
  }
}

class ShoppingListScreen extends StatefulWidget {
  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<ShoppingItem> items = [];

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    String? itemsString = prefs.getString('shopping_items');
    if (itemsString != null) {
      List<dynamic> jsonList = jsonDecode(itemsString);
      setState(() {
        items = jsonList.map((json) => ShoppingItem.fromJson(json)).toList();
      });
    }
  }

  Future<void> saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString('shopping_items', jsonString);
  }

  void _addItem(String name, int qty, String cat) {
    setState(() {
      items.add(ShoppingItem(name: name, quantity: qty, category: cat));
    });
    saveItems();
  }

  void _toggleStatus(int index) {
    setState(() {
      items[index].isBought = !items[index].isBought;
    });
    saveItems();
  }

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
    saveItems();
  }

  // Menghitung Total
  int get totalBought => items.where((i) => i.isBought).length;
  int get totalPending => items.where((i) => !i.isBought).length;

  void _showAddDialog() {
    final nameController = TextEditingController();
    final qtyController = TextEditingController();
    String selectedCategory = 'Makanan';
    final categories = ['Makanan', 'Minuman', 'Elektronik', 'Lainnya'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text('Tambah Barang'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nama Barang'),
                ),
                TextField(
                  controller: qtyController,
                  decoration: InputDecoration(labelText: 'Jumlah'),
                  keyboardType: TextInputType.number,
                ),
                DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  items: categories.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setStateDialog(() {
                      selectedCategory = val!;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Batal')),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      qtyController.text.isNotEmpty) {
                    _addItem(nameController.text,
                        int.parse(qtyController.text), selectedCategory);
                    Navigator.pop(context);
                  }
                },
                child: Text('Simpan'),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Belanja')),
      body: Column(
        children: [
          // Summary Container
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Sudah Dibeli: $totalBought',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Belum Dibeli: $totalPending',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? Center(child: Text("Daftar belanja kosong"))
                : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  color: item.isBought ? Colors.green[50] : null,
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${item.quantity}'),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    title: Text(item.name,
                        style: TextStyle(
                            decoration: item.isBought
                                ? TextDecoration.lineThrough
                                : null)),
                    subtitle: Text('Kategori: ${item.category}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: item.isBought,
                          onChanged: (_) => _toggleStatus(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.grey),
                          onPressed: () => _deleteItem(index),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}