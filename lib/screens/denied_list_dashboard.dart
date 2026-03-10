import 'package:flutter/material.dart';

class DeniedListDashboard extends StatefulWidget {
  const DeniedListDashboard({super.key});

  @override
  State<DeniedListDashboard> createState() => _DeniedListDashboardState();
}

class _DeniedListDashboardState extends State<DeniedListDashboard> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: primaryColor),
              child: Text(
                'Navigation',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text("Your Dashboard", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(icon: Image.asset("assets/one.png"), onPressed: () {}),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg_image/RDC.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          RefreshIndicator(
            onRefresh: () async {
              // Add refresh logic
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        _buildDashboardCard(
                          "Complete Orders",
                          "11",
                          Colors.grey.shade500,
                          Icon(
                            Icons.shopping_bag,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        _buildDashboardCard(
                          "Pending Orders",
                          "9",
                          Colors.grey.shade500,
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        _buildDashboardCard(
                          "Cancelled Orders",
                          "2",
                          Colors.grey.shade500,
                          Icon(
                            Icons.cancel_presentation,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(16.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Order List",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 9, // Example item count
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Icon(Icons.shopping_cart),
                              title: Text("Order ${index + 1}"),
                              subtitle: Text("Status: Pending"),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
    String title,
    String count,
    Color color,
    Icon icon,
  ) {
    return Card(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon(Icons.shopping_bag, size: 40, color: Colors.white),
          icon,
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            count,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
