import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'employees_screen.dart';

class BranchesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> branches;
  final Function(List<Map<String, dynamic>>) onBranchesChanged;

  const BranchesScreen({
    Key? key,
    required this.branches,
    required this.onBranchesChanged,
  }) : super(key: key);

  @override
  _BranchesScreenState createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  late List<Map<String, dynamic>> _branches;
  late List<Map<String, dynamic>> _filteredBranches;
  final _formKey = GlobalKey<FormState>();
  final _branchNameController = TextEditingController();
  final _branchAddressController = TextEditingController();
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Create a deep copy of the branches list to work with and ensure employees field exists
    _branches = widget.branches.map((branch) {
      Map<String, dynamic> newBranch = Map<String, dynamic>.from(branch);
      // Initialize employees as empty list if it doesn't exist
      if (newBranch['employees'] == null) {
        newBranch['employees'] = [];
      }
      // Initialize address if it doesn't exist
      if (newBranch['address'] == null) {
        newBranch['address'] = '';
      }
      return newBranch;
    }).toList();

    _filteredBranches = List.from(_branches);

    _searchController.addListener(_filterBranches);
  }

  @override
  void dispose() {
    _branchNameController.dispose();
    _branchAddressController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Filter branches based on search text
  void _filterBranches() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredBranches = List.from(_branches);
      } else {
        _filteredBranches = _branches.where((branch) {
          final name = branch['name'].toString().toLowerCase();
          final address = (branch['address'] ?? '').toString().toLowerCase();
          return name.contains(query) || address.contains(query);
        }).toList();
      }
    });
  }

  // Toggle search mode
  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  // Generate a random color for new branches
  Color _generateRandomColor() {
    final random = Random();
    return Color.fromRGBO(random.nextInt(200) + 55, random.nextInt(200) + 55,
        random.nextInt(200) + 55, 1.0);
  }

  // Thêm một chi nhánh mới
  void _addBranch() {
    _branchNameController.clear();
    _branchAddressController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thêm chi nhánh mới'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _branchNameController,
                decoration: InputDecoration(
                  labelText: 'Tên chi nhánh',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên chi nhánh';
                  }
                  if (_branches.any((branch) => branch['name'] == value)) {
                    return 'Chi nhánh này đã tồn tại';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _branchAddressController,
                decoration: InputDecoration(
                  labelText: 'Địa chỉ chi nhánh',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _branches.add({
                    'name': _branchNameController.text,
                    'address': _branchAddressController.text,
                    'revenue': 0.0,
                    'percentage': 0.0,
                    'color': _generateRandomColor(),
                    'employees': [], // Khởi tạo danh sách nhân viên rỗng
                  });

                  // Update filtered list
                  _filterBranches();

                  // Update parent state
                  widget.onBranchesChanged(_branches);
                });

                Navigator.of(context).pop();
              }
            },
            child: Text('Thêm'),
          ),
        ],
      ),
    );
  }

  // Quản lý nhân viên của chi nhánh
  void _manageBranchEmployees(int index) {
    final originalIndex = _branches.indexOf(_filteredBranches[index]);
    if (originalIndex < 0) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeesScreen(
          branch: _branches[originalIndex],
          onBranchChanged: (updatedBranch) {
            setState(() {
              _branches[originalIndex] = updatedBranch;
              _filterBranches();

              // Update parent state
              widget.onBranchesChanged(_branches);
            });
          },
        ),
      ),
    );
  }

  // Đổi màu chi nhánh
  void _changeBranchColor(int index) {
    final originalIndex = _branches.indexOf(_filteredBranches[index]);
    if (originalIndex < 0) return;

    setState(() {
      _branches[originalIndex]['color'] = _generateRandomColor();
      _filteredBranches[index]['color'] = _branches[originalIndex]['color'];

      // Update parent state
      widget.onBranchesChanged(_branches);
    });
  }

  // Sửa chi nhánh đã tồn tại
  void _editBranch(int index) {
    final originalIndex = _branches.indexOf(_filteredBranches[index]);
    if (originalIndex < 0) return;

    _branchNameController.text = _branches[originalIndex]['name'];
    _branchAddressController.text = _branches[originalIndex]['address'] ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sửa chi nhánh'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _branchNameController,
                decoration: InputDecoration(
                  labelText: 'Tên chi nhánh',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên chi nhánh';
                  }
                  if (value != _branches[originalIndex]['name'] &&
                      _branches.any((branch) => branch['name'] == value)) {
                    return 'Chi nhánh này đã tồn tại';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _branchAddressController,
                decoration: InputDecoration(
                  labelText: 'Địa chỉ chi nhánh',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _branches[originalIndex]['name'] = _branchNameController.text;
                  _branches[originalIndex]['address'] =
                      _branchAddressController.text;

                  // Update filtered items
                  _filterBranches();

                  // Update parent state
                  widget.onBranchesChanged(_branches);
                });

                Navigator.of(context).pop();
              }
            },
            child: Text('Lưu'),
          ),
        ],
      ),
    );
  }

  // Xóa chi nhánh
  void _deleteBranch(int index) {
    final originalIndex = _branches.indexOf(_filteredBranches[index]);
    if (originalIndex < 0) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xóa chi nhánh'),
        content: Text(
            'Bạn có chắc chắn muốn xóa chi nhánh "${_branches[originalIndex]['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              setState(() {
                _branches.removeAt(originalIndex);
                _filterBranches();

                // Update parent state
                widget.onBranchesChanged(_branches);
              });
              Navigator.of(context).pop();
            },
            child: Text(
              'Xóa',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Format currency (copied from dashboard_screen.dart)
  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return formatter.format(amount) + ' VND';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _isSearching
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _toggleSearch,
              )
            : null,
        title: _isSearching
            ? Container(
                height: 40,
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.search, color: Colors.grey[600], size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Tìm chi nhánh...',
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                        style: TextStyle(color: Colors.black),
                        cursorColor: Colors.blue,
                        autofocus: true,
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _searchController.clear();
                            _filterBranches();
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.clear,
                              color: Colors.grey[600], size: 20),
                        ),
                      ),
                  ],
                ),
              )
            : Text('Quản lý chi nhánh'),
        actions: [
          if (!_isSearching)
            IconButton(
              icon: Icon(Icons.search),
              onPressed: _toggleSearch,
              tooltip: 'Tìm kiếm',
            ),
          if (!_isSearching)
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _addBranch,
              tooltip: 'Thêm chi nhánh mới',
            ),
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: _filteredBranches.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.store_mall_directory_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    _isSearching && _searchController.text.isNotEmpty
                        ? 'Không tìm thấy chi nhánh phù hợp'
                        : 'Chưa có chi nhánh nào',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 24),
                  if (!_isSearching || _searchController.text.isEmpty)
                    ElevatedButton.icon(
                      onPressed: _addBranch,
                      icon: Icon(Icons.add),
                      label: Text('Thêm chi nhánh mới'),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _filteredBranches.length,
              itemBuilder: (context, index) {
                final branch = _filteredBranches[index];
                // Handle null employees with null safety
                final List<dynamic> employees = branch['employees'] ?? [];
                final employeeCount = employees.length;

                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: GestureDetector(
                      onTap: () => _changeBranchColor(index),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: branch['color'] as Color,
                          shape: BoxShape.circle,
                        ),
                        child: Tooltip(
                          message: 'Đổi màu',
                          child: Icon(
                            Icons.color_lens,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      branch['name'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (branch['address'] != null &&
                            branch['address'].toString().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Row(
                              children: [
                                Icon(Icons.location_on,
                                    size: 14, color: Colors.grey[600]),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    branch['address'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        branch['revenue'] > 0
                            ? Text(
                                'Doanh thu: ${_formatCurrency(branch['revenue'] as double)}\n'
                                'Phần trăm: ${(branch['percentage'] as double).toStringAsFixed(1)}%',
                              )
                            : Text('Chưa có dữ liệu doanh thu'),
                        SizedBox(height: 4),
                        Text(
                          'Nhân viên: $employeeCount người',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.people, color: Colors.green),
                          onPressed: () => _manageBranchEmployees(index),
                          tooltip: 'Quản lý nhân viên',
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editBranch(index),
                          tooltip: 'Sửa chi nhánh',
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteBranch(index),
                          tooltip: 'Xóa chi nhánh',
                        ),
                      ],
                    ),
                    onTap: () => _manageBranchEmployees(index),
                  ),
                );
              },
            ),
      floatingActionButton: _isSearching
          ? null
          : FloatingActionButton(
              onPressed: _addBranch,
              backgroundColor: Colors.blue,
              child: Icon(Icons.add),
              tooltip: 'Thêm chi nhánh mới',
            ),
    );
  }
}
