import 'package:espresso_partes_cafe/components/app_drawer.dart';
import 'package:espresso_partes_cafe/components/chart.dart';
import 'package:espresso_partes_cafe/components/floating_button.dart';
import 'package:espresso_partes_cafe/models/chart_data.dart';
import 'package:espresso_partes_cafe/screens/sell_screen.dart';
import 'package:espresso_partes_cafe/services/db_sales_service.dart';
import 'package:espresso_partes_cafe/utils/app_routes.dart';
import 'package:espresso_partes_cafe/utils/formater_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = "Visão Geral";
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: Consumer<DbSalesService>(builder: (ctx, salesService, child) {
        Map<int, ChartData> chartData = salesService.chartData;
        final List<ChartData> chartDataList = [];
        chartData.forEach((key, value) {
          chartDataList.add(value);
        });

        return Column(
          children: [
            SizedBox(
              height: 300,
              child: Chart(chartDataList),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 20, bottom: 100),
                itemCount: chartDataList.length,
                itemBuilder: (ctx, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                    child: ListTile(
                      // --- COLOQUE O NOVO TRECHO AQUI ---
                      leading: Text(
                        chartDataList[index].toDateString,
                        // Isso faz o texto do mês buscar o estilo no seu ThemeUtil
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      trailing: Text(
                        FormaterUtil.toReal(chartDataList[index].total),
                        // Aqui removemos o TextStyle fixo para usar o do Tema
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          // Mantemos apenas a lógica de destaque para o primeiro item (Maio 2026)
                          fontSize: index == 0 ? 21 : 18,
                          color: index == 0 ? Colors.black87 : Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
      drawer: const AppDrawer(
        currentRoute: AppRoutes.home,
        title: title,
      ),
      floatingActionButton: FloatingButton(onPress: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (ctx) => const SellScreen(null),
          ),
        );
      }),
    );
  }
}
