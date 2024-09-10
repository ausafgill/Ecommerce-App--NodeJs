import 'package:amazon/features/account/models/order_model.dart';
import 'package:amazon/features/admin/admin%20services/admin_repo.dart';
import 'package:amazon/features/order%20details/screens/order_details.dart';
import 'package:flutter/material.dart';

class AdminOrderDetails extends StatefulWidget {
  static const routeName = 'order-detail';
  const AdminOrderDetails({super.key});

  @override
  State<AdminOrderDetails> createState() => _AdminOrderDetailsState();
}

class _AdminOrderDetailsState extends State<AdminOrderDetails> {
  final AdminRepo adminRepo = AdminRepo();

  List<Order>? orders;

  void fetchAllOrders() async {
    List<Order>? o = await adminRepo.fetchAllOrders();
    setState(() {
      orders = o;
    });
  }

  @override
  void initState() {
    super.initState();

    fetchAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Center(
            child: SingleChildScrollView(),
          )
        : Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Current Orders",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () {
                          adminRepo.logout(context);
                        },
                        icon: Icon(Icons.logout))
                  ],
                ),
                Container(
                  height: 3,
                  color: Colors.black12,
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: GridView.builder(
                      itemCount: orders!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        var order = orders![
                            index]; // Get the order for the current index
                        var product = order.products[
                            0]; // Get the first product or use another index

                        return Column(
                          children: [
                            SizedBox(
                              height: 140,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    OrderDetails.routeName,
                                    arguments: orders![index],
                                  );
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black12,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                    ),
                                    child: Container(
                                      width: 180,
                                      padding: const EdgeInsets.all(10),
                                      child: Image.network(
                                        product.images[
                                            0], // Display the first product's image
                                        fit: BoxFit.fitHeight,
                                        width: 180,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  product.name, // Display the product's name
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                ),
              ],
            ),
          );
  }
}
