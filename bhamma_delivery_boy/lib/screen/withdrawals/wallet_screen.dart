import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api_service.dart';
import '../../models/WithdrawalModel.dart';
import '../../utils/default_colors.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double withdrawableBalance = 0.0;
  String totalEarned = "0";
  String withdrawn = "0";
  String pending = "0";
  String? token;

  bool showPending = false;


  @override
  void initState() {
    super.initState();
    loadWalletData();
  }

  Future<void> loadWalletData() async {
    print("🔁 loadWalletData() started");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('login_token');
    print("🟢 Token: $token");

    if (token != null) {
      print("📡 Hitting getWalletSummary...");
      var data = await ApiService.getWalletSummary(token!);
      print("📦 Response: $data");

      if (data != null) {
        setState(() {
          withdrawableBalance =
              double.tryParse(data['withdrawable_balance'].toString()) ?? 0.0;
          totalEarned = data['total_earned'].toString();
          withdrawn = data['withdrawn'].toString();
          pending = data['pending'].toString();
        });
      }
    } else {
      print("❌ Token is null. Not calling API.");
    }
  }


  void requestWithdraw() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Enter Withdraw Amount'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: "Enter amount (e.g. 100)",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              double amount = double.tryParse(controller.text) ?? 0.0;
              if (amount > 0 && token != null) {
                Navigator.pop(context);
                var result = await ApiService.sendWithdrawRequest(
                    token!, amount, context);
                if (result != null) {
                  loadWalletData();
                }
              }
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(String value, String label, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: DefaultColor.mainColor, size: 26),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final widthsize = MediaQuery.of(context).size.width;
    final heaightsize = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
      appBar: AppBar(
        title: const Text("My Wallet"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: DefaultColor.mainColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.account_balance_wallet,
                      color: Colors.white, size: 32),
                  const SizedBox(height: 10),
                  const Text("Withdrawable Balance",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 6),
                  Text("₹ ${withdrawableBalance.toStringAsFixed(2)}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: requestWithdraw,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: DefaultColor.mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text("Send Withdraw Request"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _summaryCard(totalEarned, "Total Earned", Icons.trending_up),
                    _summaryCard(withdrawn, "Withdrawn", Icons.money_off),
                    _summaryCard(
                      pending,
                      "Pending",
                      Icons.access_time,
                      onTap: () {
                        setState(() {
                          showPending = !showPending;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(color: DefaultColor.mainColor),

                if (showPending && token != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: buildPendingWithdrawals(token!),
                  ),
              ],
            ),


            // Container(
            //   height: heaightsize,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       _summaryCard(totalEarned, "Total Earned", Icons.trending_up),
            //       _summaryCard(withdrawn, "Withdrawn", Icons.money_off),
            //       _summaryCard(
            //         pending,
            //         "Pending",
            //         Icons.access_time,
            //         onTap: () {
            //           setState(() {
            //             showPending = !showPending;
            //           });
            //         },
            //       ),
            //       Divider(color: DefaultColor.mainColor),
            //
            //       if (showPending && token != null)
            //         PendingWithdrawalsScreen(token: token!), // 👈 Inline widget shown here
            //
            //       // _summaryCard(
            //       //     pending, "Pending",
            //       //     Icons.access_time,
            //       //   onTap: (){
            //       //       Navigator.push(context, MaterialPageRoute(builder: (context)=> PendingWithdrawalsScreen(token: token!)));
            //       //   }
            //       // ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
  Widget buildPendingWithdrawals(String token) {
    return FutureBuilder<List<WithdrawalModel>>(
      future: ApiService.fetchWithdrawals(token),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text("No pending withdrawals."),
          );
        }
        final data = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true, // ⬅️ important to fit inside column
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
              child: ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: Text("₹${item.amount}"),
                subtitle: Text(
                  "Status: ${item.status}\nDate: ${item.createdAt.toLocal()}",
                ),
              ),
            );
          },
        );
      },
    );
  }
}
