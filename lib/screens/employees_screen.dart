import 'package:flutter/material.dart';

class EmployeesScreen extends StatefulWidget {
  final Map<String, dynamic> branch;
  final Function(Map<String, dynamic>) onBranchChanged;
  
  const EmployeesScreen({
    Key? key, 
    required this.branch,
    required this.onBranchChanged,
  }) : super(key: key);

  @override
  _EmployeesScreenState createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  late List<Map<String, dynamic>> _employees;
  final _formKey = GlobalKey<FormState>();
  final _employeeNameController = TextEditingController();
  final _employeePositionController = TextEditingController();
  final _employeePhoneController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Create a deep copy of the employees list to work with
    _employees = List.from(widget.branch['employees'] ?? []);
  }
  
  @override
  void dispose() {
    _employeeNameController.dispose();
    _employeePositionController.dispose();
    _employeePhoneController.dispose();
    super.dispose();
  }
  
  // Add a new employee
  void _addEmployee() {
    _employeeNameController.clear();
    _employeePositionController.clear();
    _employeePhoneController.clear();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thêm nhân viên mới'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _employeeNameController,
                decoration: InputDecoration(
                  labelText: 'Tên nhân viên',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên nhân viên';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _employeePositionController,
                decoration: InputDecoration(
                  labelText: 'Chức vụ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập chức vụ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _employeePhoneController,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
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
                  _employees.add({
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    'name': _employeeNameController.text,
                    'position': _employeePositionController.text,
                    'phone': _employeePhoneController.text,
                  });
                  
                  // Update parent state
                  Map<String, dynamic> updatedBranch = Map<String, dynamic>.from(widget.branch);
                  updatedBranch['employees'] = _employees;
                  widget.onBranchChanged(updatedBranch);
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
  
  // Edit an existing employee
  void _editEmployee(int index) {
    _employeeNameController.text = _employees[index]['name'];
    _employeePositionController.text = _employees[index]['position'];
    _employeePhoneController.text = _employees[index]['phone'] ?? '';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sửa thông tin nhân viên'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _employeeNameController,
                decoration: InputDecoration(
                  labelText: 'Tên nhân viên',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên nhân viên';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _employeePositionController,
                decoration: InputDecoration(
                  labelText: 'Chức vụ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập chức vụ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _employeePhoneController,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
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
                  _employees[index]['name'] = _employeeNameController.text;
                  _employees[index]['position'] = _employeePositionController.text;
                  _employees[index]['phone'] = _employeePhoneController.text;
                  
                  // Update parent state
                  Map<String, dynamic> updatedBranch = Map<String, dynamic>.from(widget.branch);
                  updatedBranch['employees'] = _employees;
                  widget.onBranchChanged(updatedBranch);
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
  
  // Delete an employee
  void _deleteEmployee(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xóa nhân viên'),
        content: Text('Bạn có chắc chắn muốn xóa nhân viên "${_employees[index]['name']}"?'),
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
                _employees.removeAt(index);
                
                // Update parent state
                Map<String, dynamic> updatedBranch = Map<String, dynamic>.from(widget.branch);
                updatedBranch['employees'] = _employees;
                widget.onBranchChanged(updatedBranch);
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
  
  @override
  Widget build(BuildContext context) {
    final branchColor = widget.branch['color'] as Color;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhân viên ${widget.branch['name']}'),
        backgroundColor: branchColor,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addEmployee,
            tooltip: 'Thêm nhân viên mới',
          ),
        ],
      ),
      body: _employees.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Chưa có nhân viên nào',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _addEmployee,
                    icon: Icon(Icons.add),
                    label: Text('Thêm nhân viên mới'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: branchColor,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _employees.length,
              itemBuilder: (context, index) {
                final employee = _employees[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: branchColor,
                      child: Text(
                        employee['name'][0].toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      employee['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(employee['position']),
                        if (employee['phone'] != null && employee['phone'].isNotEmpty)
                          Text('SĐT: ${employee['phone']}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editEmployee(index),
                          tooltip: 'Sửa thông tin',
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteEmployee(index),
                          tooltip: 'Xóa nhân viên',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEmployee,
        backgroundColor: branchColor,
        child: Icon(Icons.add),
        tooltip: 'Thêm nhân viên mới',
      ),
    );
  }
}