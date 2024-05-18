import 'package:dtdl/screens/simulation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.pink,
        title: const Text(
          "SHOP INFY",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Hello, Priyanka"),
              accountEmail: Text("angelme@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://media.licdn.com/dms/image/D5635AQE2mVueX0wykA/profile-framedphoto-shrink_800_800/0/1713593490025?e=1716390000&v=beta&t=Rm9vFRZK4FGi9X56MOqlAlKK5e12isIRd-zvPeQ9zPk"),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => const SimulationScreen(),
                  ),
                );
              },
              leading: const Icon(Icons.accessibility),
              title: const Text(
                "Simulation",
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 66,
        child: OutlinedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    "Something went wrong, server responded with an error code-508"),
              ),
            );
            throw Exception(
                "Something went wrong, server responded with an error code-508");
          },
          child: const Text(
            "BUY NOW",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                "https://media-ik.croma.com/prod/https://media.croma.com/image/upload/v1708671939/Croma%20Assets/Communication/Mobiles/Images/300679_0_ywgnrd.png",
              ),
              const SizedBox(height: 32),
              const Text(
                "Apple iPhone 15 (128GB, Pink)",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  FilterChip(label: const Text("128 GB"), onSelected: (_) {}),
                  const SizedBox(
                    width: 12,
                  ),
                  FilterChip(label: const Text("256 GB"), onSelected: (_) {}),
                  const SizedBox(
                    width: 12,
                  ),
                  FilterChip(label: const Text("1 TB"), onSelected: (_) {})
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "The iPhone 15 marks a significant leap in Apple's flagship smartphone lineup, offering cutting-edge technology and sleek design. It features a stunning 6.1-inch Super Retina XDR display with ProMotion technology for smoother visuals and a more responsive touch experience. Powered by the new A17 Bionic chip, it delivers unprecedented speed and efficiency, supporting advanced AI capabilities and enhanced graphics performance. The camera system has been revamped with a 48MP main sensor, allowing for ultra-high-resolution photos and 8K video recording. Additionally, the iPhone 15 introduces a longer-lasting battery, 5G connectivity, and iOS 17, which brings a host of new features and improvements. With its durable Ceramic Shield front cover and IP68 water resistance, the iPhone 15 is built to withstand the rigors of daily use while providing an exceptional user experience.",
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
