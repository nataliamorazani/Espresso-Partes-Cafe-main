import 'package:espresso_partes_cafe/utils/app_routes.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;
  final String title;
  const AppDrawer({
    Key? key,
    required this.currentRoute,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blueGrey[50],
      child: ListView(
        padding: const EdgeInsets.only(bottom: 50),
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: Text(title),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
            // centerTitle: true,
          ),
          const SizedBox(height: 15),
          MenuItem(
            title: "Visão Geral",
            icon: Icons.bar_chart_rounded,
            route: AppRoutes.home,
            selected: AppRoutes.home == currentRoute,
          ),
          MenuItem(
            title: "Vendas",
            icon: Icons.library_books,
            route: AppRoutes.sales,
            selected: AppRoutes.sales == currentRoute,
          ),
          MenuItem(
            title: "Clientes",
            icon: Icons.people_alt_sharp,
            route: AppRoutes.customers,
            selected: AppRoutes.customers == currentRoute,
          ),
          MenuItem(
            title: "Itens",
            icon: Icons.shopping_basket,
            route: AppRoutes.products,
            selected: AppRoutes.products == currentRoute,
          ),
          const Divider(),
          MenuItem(
            title: "Configurações",
            icon: Icons.settings,
            route: AppRoutes.settings,
            selected: AppRoutes.settings == currentRoute,
          ),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String route;
  final bool selected;
  const MenuItem({
    super.key,
    required this.title,
    required this.icon,
    required this.route,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        size: 30,
        color: selected
            ? Theme.of(context).colorScheme.secondary
            : Colors.black.withOpacity(0.7),
      ),
      title: Text(title,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w400,
            fontFamily: "NotoSerif",
            color: selected
                ? Theme.of(context).colorScheme.secondary
                : Colors.black.withOpacity(0.6),
          )),
      onTap: () {
        Navigator.of(context).pushReplacementNamed(
          route,
        );
      },
    );
  }
}
