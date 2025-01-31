import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  final VoidCallback onClose;

  const SidebarMenu({Key? key, required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Utilisateur'),
            accountEmail: Text('utilisateur@email.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://www.pngall.com/wp-content/uploads/5/Profile-PNG-File.png',
              ),
              backgroundColor: Colors.transparent,
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Tableau de bord'),
            onTap: () {
              Navigator.pop(context); // Ferme le menu
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Paramètres'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Déconnexion'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
