import 'package:flutter/material.dart';
import 'package:gtec/screens/admin/course_management/admin_add_course.dart';
import 'package:gtec/screens/admin/course_management/admin_see_allstudent.dart';
import 'package:gtec/screens/admin/dashboard.dart';
import 'package:gtec/screens/admin/live_management/live_management.dart';
import 'package:gtec/screens/admin/usermanagement/user_management.dart';
import 'package:gtec/screens/admin/widgets/bottom.dart';
import 'package:gtec/screens/admin/widgets/searchfiled.dart';
import 'package:gtec/screens/admin/widgets/sidebarbutton.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String currentRoute = 'Dashboard';
  TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void navigateTo(String route) {
    setState(() {
      currentRoute = route;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 700;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[200],
      appBar: isLargeScreen
          ? null
          : AppBar(
              title: Text(currentRoute),
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
            ),
      drawer: isLargeScreen
          ? null
          : Drawer(
              child: Sidebar(
                isLargeScreen: isLargeScreen,
                onNavigate: navigateTo,
                searchController: searchController,
                currentRoute: currentRoute,
              ),
            ),
      body: Row(
        children: [
          if (isLargeScreen)
            Sidebar(
              isLargeScreen: isLargeScreen,
              onNavigate: navigateTo,
              searchController: searchController,
              currentRoute: currentRoute,
            ),
          Expanded(
            child: ContentArea(
              isLargeScreen: isLargeScreen,
              currentRoute: currentRoute,
              searchController: searchController,
            ),
          ),
        ],
      ),
    );
  }
}

class Sidebar extends StatelessWidget {
  final Function(String) onNavigate;
  final TextEditingController searchController;
  final bool isLargeScreen;
  final String currentRoute;

  const Sidebar({super.key, 
    required this.onNavigate,
    required this.searchController,
    required this.isLargeScreen,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final sidebarWidth =
        isLargeScreen ? 300.0 : MediaQuery.of(context).size.width * 0.8;

    return Card(
      elevation: 4,
      child: Container(
        color: Colors.white,
        width: sidebarWidth,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdminSearchField(searchController: searchController),
                    const SizedBox(height: 20),
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.5,
                      ),
                      child: AdminMainMenu(
                        isLargeScreen: isLargeScreen,
                        onNavigate: onNavigate,
                        currentRoute: currentRoute,
                      ),
                    ),
                    const SizedBox(height: 90),
                    Divider(),
                    AdminBottom(
                      onMenuItemSelected: onNavigate,
                      isLargeScreen: isLargeScreen,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ContentArea extends StatelessWidget {
  final String currentRoute;
  final TextEditingController searchController;
  final bool isLargeScreen;

  const ContentArea({super.key, 
    required this.currentRoute,
    required this.searchController,
    required this.isLargeScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentRoute,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          SizedBox(height: 20),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (currentRoute) {
      case 'Course':
        return AdminAddCourse();
      case 'User':
        return AllUsersapprovePage();
      case 'Students':
        return Adminusermanagement();
      case 'Live':
        return Adminlivemanagement();
      case 'Dashboard':
        return DashboardScreennew();
      default:
        return DashboardScreennew();
    }
  }
}

class AdminMainMenu extends StatelessWidget {
  final Function(String) onNavigate;
  final bool isLargeScreen;
  final String currentRoute;

  const AdminMainMenu({super.key, 
    required this.onNavigate,
    required this.isLargeScreen,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 146, 218, 228).withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(2, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminSidebarButton(
              icon: Icons.dashboard,
              text: 'Dashboard',
              onTap: () => onNavigate('Dashboard'),
              selected: currentRoute == 'Dashboard',
            ),
            AdminSidebarButton(
              icon: Icons.book,
              text: 'Course Management',
              onTap: () => onNavigate('Course'),
              selected: currentRoute == 'Course',
            ),
            AdminSidebarButton(
              icon: Icons.live_tv,
              text: 'Live Management',
              onTap: () => onNavigate('Live'),
              selected: currentRoute == 'Live',
            ),
            AdminSidebarButton(
              icon: Icons.people_sharp,
              text: 'Students Management',
              onTap: () => onNavigate('Students'),
              selected: currentRoute == 'Students',
            ),
            AdminSidebarButton(
              icon: Icons.settings,
              text: 'User Management',
              onTap: () => onNavigate('User'),
              selected: currentRoute == 'User',
            ),
          ],
        ),
      ),
    );
  }
}
