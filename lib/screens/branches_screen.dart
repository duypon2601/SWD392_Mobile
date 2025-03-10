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
  final _formKey = GlobalKey<FormState>();
  final _branchNameController = TextEditingController();
  
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
      return newBranch;
    }).toList();
  }
  
  @override
  void dispose() {
    _branchNameController.dispose();
    super.dispose();
  }
  
  // Generate a random color for new branches
  Color _generateRandomColor() {
    final random = Random();
    return Color.fromRGBO(
      random.nextInt(200) + 55, 
      random.nextInt(200) + 55, 
      random.nextInt(200) + 55, 
      1.0
    );
  }
  
  // Thêm một chi nhánh mới
  void _addBranch() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thêm chi nhánh mới'),
        content: Form(
          key: _formKey,
          child: TextFormField(
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
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _branchNameController.clear();
            },
            child: Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _branches.add({
                    'name': _branchNameController.text,
                    'revenue': 0.0,
                    'percentage': 0.0,
                    'color': _generateRandomColor(),
                    'employees': [], // Khởi tạo danh sách nhân viên rỗng
                  });
                  
                  // Update parent state
                  widget.onBranchesChanged(_branches);
                });
                
                Navigator.of(context).pop();
                _branchNameController.clear();
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeesScreen(
          branch: _branches[index],
          onBranchChanged: (updatedBranch) {
            setState(() {
              _branches[index] = updatedBranch;
              
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
    setState(() {
      _branches[index]['color'] = _generateRandomColor();
      
      // Update parent state
      widget.onBranchesChanged(_branches);
    });
  }
  
  // Sửa chi nhánh đã tồn tại
  void _editBranch(int index) {
    _branchNameController.text = _branches[index]['name'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sửa chi nhánh'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _branchNameController,
            decoration: InputDecoration(
              labelText: 'Tên chi nhánh',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập tên chi nhánh';
              }
              if (value != _branches[index]['name'] && 
                  _branches.any((branch) => branch['name'] == value)) {
                return 'Chi nhánh này đã tồn tại';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _branchNameController.clear();
            },
            child: Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _branches[index]['name'] = _branchNameController.text;
                  
                  // Update parent state
                  widget.onBranchesChanged(_branches);
                });
                
                Navigator.of(context).pop();
                _branchNameController.clear();
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xóa chi nhánh'),
        content: Text('Bạn có chắc chắn muốn xóa chi nhánh "${_branches[index]['name']}"?'),
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
                _branches.removeAt(index);
                
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
        title: Text('Quản lý chi nhánh'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addBranch,
            tooltip: 'Thêm chi nhánh mới',
          ),
        ],
      ),
      body: _branches.isEmpty
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
                    'Chưa có chi nhánh nào',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _addBranch,
                    icon: Icon(Icons.add),
                    label: Text('Thêm chi nhánh mới'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _branches.length,
              itemBuilder: (context, index) {
                final branch = _branches[index];
                // Handle null employees with null safety
                final List<dynamic> employees = branch['employees'] ?? [];
                final employeeCount = employees.length;
                
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _addBranch,
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        tooltip: 'Thêm chi nhánh mới',
      ),
    );
  }
}