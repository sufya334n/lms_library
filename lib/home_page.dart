import 'package:admin_dashboard_app/dashboard.dart';
import 'package:admin_dashboard_app/manage_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'addbook.dart';
import 'issue_book.dart';
import 'record_book.dart';
import 'return_book.dart';

enum SideBarItem {
  dashboard(
      value: 'Dashboard', iconData: Icons.dashboard, body: DashboardPage()),
  // ignore: constant_identifier_names
  IssueBook(value: 'IssuePAge', iconData: Icons.book, body: IssuePage()),
  // ignore: constant_identifier_names
  Return_Book(
      value: 'ReturnBook', iconData: Icons.restore, body: ReturnBookPage()),
  // ignore: constant_identifier_names
  Record_Book(value: 'RecordBook', iconData: Icons.info, body: RecordPage()),
  // ignore: constant_identifier_names
  //DetailBook(value: 'DetailBook', iconData: Icons.group, body: Bookdetail()),
  // ignore: constant_identifier_names
  Addbook(
      value: 'Search Book', iconData: Icons.search, body: ManageBookPage()),
  settings(value: 'Add Book', iconData: Icons.add, body: AddBook());

  const SideBarItem(
      {required this.value, required this.iconData, required this.body});
  final String value;
  final IconData iconData;
  final Widget body;
}

final sideBarItemProvider =
    StateProvider<SideBarItem>((ref) => SideBarItem.dashboard);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sideBarItem = ref.watch(sideBarItemProvider);
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: SideBarItem.values.indexOf(sideBarItem),
            onDestinationSelected: (int index) {
              ref
                  .read(sideBarItemProvider.notifier)
                  .update((state) => SideBarItem.values[index]);
            },
            labelType: NavigationRailLabelType.all,
            destinations: SideBarItem.values
                .map((e) => NavigationRailDestination(
                      icon: Icon(e.iconData),
                      label: Text(e.value),
                    ))
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: ProviderScope(
              overrides: [
                paramProvider.overrideWithValue(('String parameter', 1000000))
              ],
              child: sideBarItem.body,
            ),
          ),
        ],
      ),
    );
  }
}

final paramProvider = Provider<(String, int)>((ref) {
  throw UnimplementedError();
});
