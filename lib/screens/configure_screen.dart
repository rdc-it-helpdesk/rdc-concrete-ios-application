import 'package:flutter/material.dart';
import 'package:rdc_concrete/screens/denied_list_dashboard.dart';

class ConfigureScreen extends StatefulWidget {
  const ConfigureScreen({super.key});

  @override
  State<ConfigureScreen> createState() => _ConfigureScreenState();
}

class _ConfigureScreenState extends State<ConfigureScreen> {
  String? selectedItem;
  List<String> spinnerItems = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];
  String stringData = '';
  TextEditingController unwantedTextController = TextEditingController();
  List<String> bleDevices = ['Device 1', 'Device 2', 'Device 3'];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text('Configure Items', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSpinner(),
              SizedBox(height: 16),
              _buildStringDataDisplay(),
              SizedBox(height: 16),
              _buildUnwantedTextInput(),
              SizedBox(height: 16),
              _buildActionButtons(),
              SizedBox(height: 16),
              _buildBleDevicesList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpinner() {
    return DropdownButtonFormField<String>(
      initialValue: selectedItem,
      items:
          spinnerItems.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedItem = newValue;
        });
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Select an item',
      ),
    );
  }

  Widget _buildStringDataDisplay() {
    return Container(
      height: 250,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        child: Text(stringData, style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildUnwantedTextInput() {
    return TextFormField(
      controller: unwantedTextController,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Select Non-require /Unwanted Text',
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            // Edit logic
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
          child: Text('Edit', style: TextStyle(color: Colors.black)),
        ),
        ElevatedButton(
          onPressed: () {
            // Save logic
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DeniedListDashboard()),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: Text('Save', style: TextStyle(color: Colors.black)),
        ),
        ElevatedButton(
          onPressed: () {
            // Cancel logic
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: Text('Cancel', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  Widget _buildBleDevicesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BLE Devices',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: bleDevices.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(bleDevices[index]),
                trailing: Icon(Icons.bluetooth),
                onTap: () {
                  // Handle device selection
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
