import 'package:flutter/material.dart';

import '../models/customer.dart';
import '../models/paged_customer_response.dart';
import '../services/api_service.dart';
import '../widgets/customer_card.dart';
import 'add_customer_screen.dart';
import 'edit_customer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<PagedCustomerResponse> _customerFuture;

  final TextEditingController _searchController =
  TextEditingController();

  bool _isSearching = false;

  List<Customer> _searchResults = [];

  int _currentPage = 1;
  final int _limit = 20;

  int _totalPages = 1;
  int _totalRecords = 0;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  void _loadCustomers() {
    _customerFuture = ApiService.getCustomers(
      page: _currentPage,
      limit: _limit,
    );
  }

  Future<void> _refresh() async {
    setState(() {
      _loadCustomers();

      if (_searchController.text.trim().isEmpty) {
        _isSearching = false;
      }
    });

    await _customerFuture;
  }

  Future<void> _searchCustomer(String keyword) async {
    keyword = keyword.trim();

    if (keyword.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults.clear();
      });
      return;
    }

    final result =
    await ApiService.searchCustomers(keyword);

    if (!mounted) return;

    setState(() {
      _isSearching = true;
      _searchResults = result;
    });
  }

  void _nextPage() {
    if (_currentPage >= _totalPages) return;

    setState(() {
      _currentPage++;
      _loadCustomers();
    });
  }

  void _previousPage() {
    if (_currentPage <= 1) return;

    setState(() {
      _currentPage--;
      _loadCustomers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Management"),
        centerTitle: true,
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: _searchCustomer,
              decoration: InputDecoration(
                hintText: "Search Customer",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(10),
                ),
                suffixIcon:
                _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(
                      Icons.clear),
                  onPressed: () {
                    _searchController.clear();

                    setState(() {
                      _isSearching = false;
                      _searchResults.clear();
                    });
                  },
                )
                    : null,
              ),
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child:
              FutureBuilder<PagedCustomerResponse>(
                future: _customerFuture,
                builder: (context, snapshot) {

                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child:
                      CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        snapshot.error.toString(),
                      ),
                    );
                  }

                  final response = snapshot.data!;

                  _totalPages = response.totalPages;
                  _totalRecords =
                      response.totalRecords;

                  final customers = _isSearching
                      ? _searchResults
                      : response.customers;
                  if (customers.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Customers Found",
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  return Column(
                    children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [

                            Text(
                              "Total : $_totalRecords",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              "Page $_currentPage / $_totalPages",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                          ],
                        ),
                      ),

                      Expanded(
                        child: ListView.builder(
                          physics:
                          const AlwaysScrollableScrollPhysics(),
                          itemCount: customers.length,
                          itemBuilder: (context, index) {

                            final customer =
                            customers[index];

                            return CustomerCard(
                              customer: customer,

                              onTap: () async {

                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EditCustomerScreen(
                                          customer: customer,
                                        ),
                                  ),
                                );

                                await _refresh();

                              },
                            );

                          },
                        ),
                      ),
                      if (!_isSearching)
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [

                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _currentPage > 1
                                      ? _previousPage
                                      : null,
                                  icon: const Icon(Icons.arrow_back),
                                  label: const Text("Previous"),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _currentPage < _totalPages
                                      ? _nextPage
                                      : null,
                                  icon: const Icon(Icons.arrow_forward),
                                  label: const Text("Next"),
                                ),
                              ),

                            ],
                          ),
                        ),

                    ],
                  );

                },
              ),
            ),
          ),

        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddCustomerScreen(),
            ),
          );

          await _refresh();

        },
        child: const Icon(Icons.add),
      ),
    );
  }
}