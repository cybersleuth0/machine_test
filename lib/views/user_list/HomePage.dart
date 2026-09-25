import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:machine_test/viewmodels/auth_viewmodel.dart';
import 'package:machine_test/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../core/constants/AppRoutes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    // Only trigger when user actively scrolls down (currentScroll > 20)
    // and reaches near the bottom of the list
    if (currentScroll > 20 && currentScroll >= maxScroll - 50) {
      context.read<UserViewmodel>().loadMoreUsers();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Users List', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () async {
              await context.read<AuthViewmodel>().logOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.ROUTE_LOGINPAGE, (route) => false);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<UserViewmodel>(
          builder: (context, userVM, child) {
            // 1. Initial full-page loading state
            if (userVM.isLoading && userVM.users.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            // 2. Initial error state with Retry button
            if (userVM.errorMessage != null && userVM.users.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 54, color: Colors.redAccent),
                      const SizedBox(height: 12),
                      Text(
                        userVM.errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => userVM.fetchInitialUsers(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            // 3. Empty data state
            if (userVM.users.isEmpty) {
              return const Center(
                child: Text('No users found', style: TextStyle(fontSize: 16, color: Colors.grey)),
              );
            }

            // 4. Paginated list with pull-to-refresh
            return RefreshIndicator(
              onRefresh: () => userVM.refreshUsers(),
              child: ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: userVM.users.length + (userVM.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  // If we've reached the extra slot at the bottom, show the pagination spinner
                  if (index == userVM.users.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        ),
                      ),
                    );
                  }

                  final user = userVM.users[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    elevation: 1.5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: CachedNetworkImage(
                              imageUrl: user.avatar,
                              width: 54,
                              height: 54,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 54,
                                height: 54,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.person, color: Colors.grey),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 54,
                                height: 54,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.broken_image, color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.fullName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user.email,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
