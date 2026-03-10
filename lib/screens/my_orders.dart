import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  bool isScrolled = true;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF0EB154),

        /// vibrant green color code.
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction == ScrollDirection.forward) {
              setState(() {
                isScrolled = true;
              });
            } else if (notification.direction == ScrollDirection.reverse) {
              setState(() {
                isScrolled = false;
              });
            }
            return true;
          },
          child: ListView.builder(
            itemCount:
                7, // You can change this to the number of cards you want to show
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 18,
                    bottom: 18,
                    left: 12,
                    right: 12,
                  ),
                  child: Row(
                    children: [
                      // Image of the product
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(
                          'assets/mainrdc.png', // Add your product image here
                          width: 90,
                          height: 80,
                          fit: BoxFit.fitWidth,
                        ),
                      ),

                      const SizedBox(
                        width: 12,
                      ), // Space between image and text content
                      // Product Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Title
                            Text(
                              'Heavy Duty Concrete Mixer - (10 HP/500L Drum Capacity/Steel Construction)',
                              style: TextStyle(
                                fontSize:
                                    16, // Slightly bigger size for readability
                                fontWeight:
                                    FontWeight.bold, // Bold to evoke strength
                                color: Color(
                                  0xFF333333,
                                ), // Dark grey color for an industrial look
                                letterSpacing:
                                    1, // Adds space between letters for a solid look
                                fontFamily: 'Roboto Slab', // A more rugged font
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 8),

                            // Product Sub-title (like description or size)
                            Text(
                              '12mm Reinforced Steel Rod - High Strength',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                            ),

                            const SizedBox(height: 8),
                            // Rating Box
                            // Container(
                            //   padding: const EdgeInsets.symmetric(horizontal: 15),
                            //   decoration: BoxDecoration(
                            //     color: Colors.red,
                            //     borderRadius: BorderRadius.circular(8),
                            //   ),
                            //   child: Text(
                            //     '4.7',
                            //     style: TextStyle(
                            //       color: Colors.white,
                            //       fontSize: 14,
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),

                      // Action Buttons (Edit and Delete)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.mode_edit_outline,
                              color: Colors.grey,
                            ),
                            iconSize: 24,
                          ),
                          // IconButton(
                          //   onPressed: () {},
                          //   icon: Icon(
                          //     Icons.delete,
                          //     color: Colors.red,
                          //   ),
                          //   iconSize: 24,
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        isExtended: isScrolled,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.green),
        ),
        backgroundColor: primaryColor, // Optional: Set background color
        label: Text(
          'New Vendor Available to Map',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ), // Adjust color as needed
        ),
        icon: Icon(Icons.arrow_forward_outlined, color: Colors.white),
      ),
    );
  }
}
