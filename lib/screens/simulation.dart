import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SimulationScreen extends StatefulWidget {
  const SimulationScreen({super.key});

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.pink,
        title: const Text(
          "Simulate Error",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 24,
              ),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: [
                  simulationOption(
                      context: context,
                      title: "PAYMENT FAILURE",
                      onTap: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              "Something went wrong, Error reported, Team shall reach out to you soon with resolution!"),
                          backgroundColor: Colors.red,
                        ));
                      }),
                  simulationOption(
                      context: context, title: "NETWORK ERROR", onTap: () {}),
                  simulationOption(
                      context: context, title: "DATA LOSS", onTap: () {}),
                  simulationOption(
                      context: context, title: "SERVER DOWN", onTap: () {}),
                  simulationOption(
                      context: context,
                      title: "APPLICATION CRASH",
                      onTap: () {}),
                  simulationOption(
                      context: context, title: "ORDER FAILED", onTap: () {}),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget simulationOption(
    {required BuildContext context,
    required String title,
    required VoidCallback onTap}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width / 2 - 20,
    height: 130,
    child: DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.pinkAccent,
          ],
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Expanded(child: Text(title)),
        ),
      ),
    ),
  );
}
