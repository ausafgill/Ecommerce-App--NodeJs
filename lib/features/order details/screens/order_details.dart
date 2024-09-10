import 'package:amazon/constants/gloabal_variable.dart';
import 'package:amazon/features/account/models/order_model.dart';
import 'package:amazon/features/admin/admin%20services/admin_repo.dart';
import 'package:amazon/features/providers/user.dart';
import 'package:amazon/features/search/screens/search_screen.dart';
import 'package:amazon/shared/widgets/helper_button.dart';
import 'package:amazon/shared/widgets/helper_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetails extends StatefulWidget {
  static const routeName = '/order-details';
  final Order order;
  OrderDetails({super.key, required this.order});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  TextEditingController searchController = TextEditingController();
  final AdminRepo adminRepo = AdminRepo();
  int currentStep = 0;
  @override
  void initState() {
    super.initState();
    currentStep = widget.order.status;
  }

  // !!! ONLY FOR ADMIN!!!
  void changeOrderStatus(int status) {
    adminRepo.changeOrderStatus(
      context,
      status + 1,
      widget.order,
    );
    setState(() {
      currentStep += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            flexibleSpace: Container(
              decoration:
                  const BoxDecoration(gradient: GlobalVariables.appBarGradient),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child:
                      // alignment: Alignment.topLeft,
                      Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: HelperTextField(
                        onChanged: (val) {
                          Navigator.pushNamed(context, SearchScreen.routeName,
                              arguments: searchController.text);
                        },
                        htxt: 'Search',
                        controller: searchController,
                        keyboardType: TextInputType.name),
                  ),
                ),
                const Row(
                  children: [
                    Icon(
                      Icons.mic,
                      color: Colors.black,
                    ),
                  ],
                )
              ],
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "View order Details",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 3,
                color: Colors.black12,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text("Order Date: "),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(DateTime.fromMillisecondsSinceEpoch(
                                widget.order.orderedAt)
                            .toString())
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Order ID: "),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(widget.order.id)
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Order Total: "),
                        const SizedBox(
                          width: 12,
                        ),
                        Text('\$${widget.order.totalPrice.toString()}')
                      ],
                    )
                  ],
                ),
              ),
              Container(
                height: 3,
                color: Colors.black12,
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Purchase Details",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 3,
                color: Colors.black12,
              ),
              SizedBox(
                height: 170,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.order.products.length,
                    itemBuilder: (context, index) {
                      var order = widget.order.products[index];
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12)),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 150,
                                child: Image.network(order.images[0]),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      order.name,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        "Quantity: ${widget.order.quantity[index]}")
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Tracking",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 3,
                color: Colors.black12,
              ),
              Stepper(
                currentStep: currentStep,
                controlsBuilder: (context, details) {
                  if (user.type == 'admin') {
                    return HelperButton(
                      name: 'Done',
                      onTap: () => changeOrderStatus(details.currentStep),
                    );
                  }
                  return const SizedBox();
                },
                steps: [
                  Step(
                    title: const Text('Pending'),
                    content: const Text(
                      'Your order is yet to be delivered',
                    ),
                    isActive: currentStep > 0,
                    state: currentStep > 0
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                  Step(
                    title: const Text('Completed'),
                    content: const Text(
                      'Your order has been delivered, you are yet to sign.',
                    ),
                    isActive: currentStep > 1,
                    state: currentStep > 1
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                  Step(
                    title: const Text('Received'),
                    content: const Text(
                      'Your order has been delivered and signed by you.',
                    ),
                    isActive: currentStep > 2,
                    state: currentStep > 2
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                  Step(
                    title: const Text('Delivered'),
                    content: const Text(
                      'Your order has been delivered and signed by you!',
                    ),
                    isActive: currentStep >= 3,
                    state: currentStep >= 3
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
