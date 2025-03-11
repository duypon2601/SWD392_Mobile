import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'employees_screen.dart';

class BranchDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> branch;
  final Function(Map<String, dynamic>) onBranchChanged;

  const BranchDetailsScreen({
    Key? key,
    required this.branch,
    required this.onBranchChanged,
  }) : super(key: key);

  @override
  _BranchDetailsScreenState createState() => _BranchDetailsScreenState();
}

class _BranchDetailsScreenState extends State<BranchDetailsScreen> {
  DateTime startDate = DateTime.now().subtract(Duration(days: 7));
  DateTime endDate = DateTime.now();
  String selectedPeriod = 'Ngày'; // 'Ngày', 'Tuần', 'Tháng'
  DateTime calendarMonth = DateTime.now();
  bool isSelectingStartDate = true;

  // Dữ liệu doanh thu mẫu của chi nhánh
  List<Map<String, dynamic>> revenueData = [];
  double totalRevenue = 0;

  @override
  void initState() {
    super.initState();
    // Tạo dữ liệu mẫu
    _generateSampleData();
    // Tính tổng doanh thu trong khoảng thời gian đã chọn
    _calculateTotalRevenue();
  }

  // Tạo dữ liệu mẫu cho 30 ngày gần đây cho chi nhánh này
  void _generateSampleData() {
    final random = Random();
    final now = DateTime.now();
    final baseRevenue = 50000.0 +
        random.nextInt(200000); // Doanh thu cơ sở khác nhau cho mỗi chi nhánh

    revenueData = List.generate(30, (index) {
      final date = now.subtract(Duration(days: 29 - index));
      // Tạo doanh thu ngẫu nhiên với biến động nhỏ hơn
      final dailyVariation = random.nextDouble() * 0.4 + 0.8; // 0.8 - 1.2

      return {
        'date': date,
        'revenue': baseRevenue *
            dailyVariation, // Doanh thu ngẫu nhiên từ 80% đến 120% của base
      };
    });
  }

  // Tính tổng doanh thu trong khoảng thời gian đã chọn
  void _calculateTotalRevenue() {
    totalRevenue = 0;

    // Lọc dữ liệu trong khoảng thời gian
    final filteredData = revenueData.where((data) {
      final date = data['date'] as DateTime;
      return (date.isAtSameMomentAs(startDate) || date.isAfter(startDate)) &&
          (date.isAtSameMomentAs(endDate) || date.isBefore(endDate));
    }).toList();

    // Tính tổng
    for (var data in filteredData) {
      totalRevenue += data['revenue'] as double;
    }
  }

  // Lấy dữ liệu cho biểu đồ dựa vào khoảng thời gian và loại thời gian đã chọn
  List<Map<String, dynamic>> _getChartData() {
    if (revenueData.isEmpty) return [];

    List<Map<String, dynamic>> result = [];

    if (selectedPeriod == 'Ngày') {
      // Lọc dữ liệu trong khoảng thời gian
      result = revenueData.where((data) {
        final date = data['date'] as DateTime;
        return (date.isAtSameMomentAs(startDate) || date.isAfter(startDate)) &&
            (date.isAtSameMomentAs(endDate) || date.isBefore(endDate));
      }).map((data) {
        final date = data['date'] as DateTime;
        return {
          'label': '${date.day}/${date.month}',
          'revenue': data['revenue'],
        };
      }).toList();

      // Sắp xếp theo ngày
      result.sort((a, b) => a['label'].compareTo(b['label']));
    } else if (selectedPeriod == 'Tuần') {
      // Nhóm theo tuần
      final Map<String, double> weeklyData = {};

      for (var data in revenueData) {
        final date = data['date'] as DateTime;
        if ((date.isAtSameMomentAs(startDate) || date.isAfter(startDate)) &&
            (date.isAtSameMomentAs(endDate) || date.isBefore(endDate))) {
          // Tính số tuần từ đầu năm
          final weekNumber =
              (date.difference(DateTime(date.year, 1, 1)).inDays / 7).ceil();
          final weekKey = 'T${weekNumber}';

          if (!weeklyData.containsKey(weekKey)) {
            weeklyData[weekKey] = 0;
          }

          weeklyData[weekKey] =
              weeklyData[weekKey]! + (data['revenue'] as double);
        }
      }

      weeklyData.forEach((week, revenue) {
        result.add({
          'label': week,
          'revenue': revenue,
        });
      });

      // Sắp xếp theo tuần
      result.sort((a, b) => a['label'].compareTo(b['label']));
    } else if (selectedPeriod == 'Tháng') {
      // Nhóm theo tháng
      final Map<String, double> monthlyData = {};

      for (var data in revenueData) {
        final date = data['date'] as DateTime;
        if ((date.isAtSameMomentAs(startDate) || date.isAfter(startDate)) &&
            (date.isAtSameMomentAs(endDate) || date.isBefore(endDate))) {
          final monthKey = '${date.month}/${date.year}';

          if (!monthlyData.containsKey(monthKey)) {
            monthlyData[monthKey] = 0;
          }

          monthlyData[monthKey] =
              monthlyData[monthKey]! + (data['revenue'] as double);
        }
      }

      monthlyData.forEach((month, revenue) {
        result.add({
          'label': 'T${month.split('/')[0]}',
          'revenue': revenue,
        });
      });

      // Sắp xếp theo tháng
      result.sort((a, b) => a['label'].compareTo(b['label']));
    }

    return result;
  }

  // Kiểm tra xem một ngày có nằm trong khoảng được chọn hay không
  bool _isInSelectedRange(DateTime date) {
    return (date.isAtSameMomentAs(startDate) || date.isAfter(startDate)) &&
        (date.isAtSameMomentAs(endDate) || date.isBefore(endDate));
  }

  // Kiểm tra xem một ngày có phải là ngày được chọn không
  bool _isSelectedDate(DateTime date) {
    return date.year == startDate.year &&
            date.month == startDate.month &&
            date.day == startDate.day ||
        date.year == endDate.year &&
            date.month == endDate.month &&
            date.day == endDate.day;
  }

  // Kiểm tra xem một ngày có thuộc tháng hiện tại không
  bool _isCurrentMonth(DateTime date) {
    return date.month == calendarMonth.month;
  }

  // Định dạng số tiền VND
  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return formatter.format(amount) + ' VND';
  }

  // Tính các ngày trong tháng hiện tại
  List<DateTime> _getDaysInMonth(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final daysBefore =
        first.weekday - 1; // Thứ 2 là ngày đầu tuần (weekday = 1)
    final firstToDisplay = first.subtract(Duration(days: daysBefore));
    final last = DateTime(month.year, month.month + 1, 0);
    final daysAfter = 7 - last.weekday;
    final lastToDisplay =
        last.add(Duration(days: daysAfter == 7 ? 0 : daysAfter));
    return List.generate(
      lastToDisplay.difference(firstToDisplay).inDays + 1,
      (index) => firstToDisplay.add(Duration(days: index)),
    );
  }

  // Di chuyển đến tháng trước
  void _previousMonth() {
    setState(() {
      calendarMonth = DateTime(calendarMonth.year, calendarMonth.month - 1);
    });
  }

  // Di chuyển đến tháng sau
  void _nextMonth() {
    setState(() {
      calendarMonth = DateTime(calendarMonth.year, calendarMonth.month + 1);
    });
  }

  // Hiển thị trạng thái đang chọn ngày
  Widget _buildSelectionStatus() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      alignment: Alignment.center,
      child: Text(
        isSelectingStartDate ? 'Chọn ngày bắt đầu' : 'Chọn ngày kết thúc',
        style: TextStyle(
          color: isSelectingStartDate ? Colors.blue : Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Xây dựng biểu đồ doanh thu
  Widget _buildRevenueChart() {
    final chartData = _getChartData();

    if (chartData.isEmpty) {
      return Center(
        child: Text('Không có dữ liệu trong khoảng thời gian đã chọn'),
      );
    }

    // Tìm giá trị lớn nhất cho maxY
    double maxValue = 0;
    for (var data in chartData) {
      if ((data['revenue'] as double) > maxValue) {
        maxValue = data['revenue'] as double;
      }
    }

    // Làm tròn maxY lên để có chia độ đẹp
    final maxY = ((maxValue / 100000).ceil() * 100000 * 1.1);

    // Tạo danh sách BarChartGroupData
    final List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < chartData.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: chartData[i]['revenue'] as double,
              color:
                  widget.branch['color'] as Color, // Sử dụng màu của chi nhánh
              width: 25,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
          ],
        ),
      );
    }

    return BarChart(
      BarChartData(
        maxY: maxY,
        barGroups: barGroups,
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: true, horizontalInterval: maxY / 5),
        titlesData: FlTitlesData(
          show: true,
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                // Rút gọn giá trị trục Y (ví dụ: "500K" thay vì "500,000")
                if (value == 0) return const Text('0');
                if (value >= 1000000) {
                  return Text('${(value / 1000000).toStringAsFixed(1)}M');
                }
                return Text('${(value / 1000).toStringAsFixed(0)}K');
              },
              reservedSize: 60,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value >= 0 && value < chartData.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      chartData[value.toInt()]['label'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                _formatCurrency(chartData[group.x.toInt()]['revenue']),
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Nút chọn chế độ hiển thị (Ngày/Tuần/Tháng)
  Widget _periodButton(
      BuildContext context, String title, StateSetter setDialogState) {
    bool isSelected = selectedPeriod == title;
    return InkWell(
      onTap: () {
        setDialogState(() {
          selectedPeriod = title;
          // Reset lại quá trình chọn ngày khi chuyển chế độ
          isSelectingStartDate = true;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[200] : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: isSelected
                  ? widget.branch['color'] as Color
                  : Colors.grey[300]!),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? widget.branch['color'] as Color : Colors.black,
          ),
        ),
      ),
    );
  }

  // Xây dựng lưới lịch
  Widget _buildCalendarGrid(BuildContext context, [StateSetter? setState]) {
    List<String> daysOfWeek = ['M', 'T', 'W', 'Th', 'F', 'Sa', 'S'];
    List<DateTime> days = _getDaysInMonth(calendarMonth);

    void updateState(Function() update) {
      if (setState != null) {
        setState(update);
      } else {
        this.setState(update);
      }
    }

    return Column(
      children: [
        // Header - Days of week
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: daysOfWeek.map((day) {
            return Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              child: Text(
                day,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 8),
        // Calendar grid
        Wrap(
          spacing: 4,
          runSpacing: 4,
          alignment: WrapAlignment.center,
          children: days.map((day) {
            bool isSelected = _isSelectedDate(day);
            bool isInRange = _isInSelectedRange(day);
            bool isCurrentMonth = _isCurrentMonth(day);

            return InkWell(
              onTap: () {
                updateState(() {
                  if (selectedPeriod == 'Ngày') {
                    // Khi chọn theo ngày
                    if (isSelectingStartDate) {
                      startDate = DateTime(day.year, day.month, day.day);
                      endDate = startDate; // Mặc định đặt bằng nhau trước
                      isSelectingStartDate =
                          false; // Chuyển sang chọn ngày kết thúc
                    } else {
                      // Đang chọn ngày kết thúc
                      if (day.isBefore(startDate)) {
                        // Nếu chọn ngày trước ngày bắt đầu, đổi vị trí
                        endDate = startDate;
                        startDate = DateTime(day.year, day.month, day.day);
                      } else {
                        endDate = DateTime(day.year, day.month, day.day);
                      }
                      isSelectingStartDate = true; // Quay lại chọn ngày bắt đầu
                    }
                  } else if (selectedPeriod == 'Tuần') {
                    // Tính toán ngày đầu tuần (thứ 2) và cuối tuần (chủ nhật)
                    int weekday = day.weekday;
                    startDate = day.subtract(Duration(days: weekday - 1));
                    endDate = startDate.add(Duration(days: 6));
                  } else if (selectedPeriod == 'Tháng') {
                    // Chọn cả tháng
                    startDate = DateTime(day.year, day.month, 1);
                    endDate = DateTime(
                        day.year, day.month + 1, 0); // Ngày cuối của tháng
                  }
                });
              },
              child: Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? (day.isAtSameMomentAs(startDate)
                          ? widget.branch['color'] as Color
                          : Colors.green)
                      : isInRange
                          ? (widget.branch['color'] as Color).withOpacity(0.2)
                          : isCurrentMonth
                              ? Colors.grey[200]
                              : Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isSelected
                        ? (day.isAtSameMomentAs(startDate)
                            ? widget.branch['color'] as Color
                            : Colors.green)
                        : isInRange
                            ? widget.branch['color'] as Color
                            : isCurrentMonth
                                ? Colors.grey[300]!
                                : Colors.grey[100]!,
                    width: isSelected || isInRange ? 2 : 1,
                  ),
                ),
                child: Text(
                  day.day.toString(),
                  style: TextStyle(
                    fontWeight: isSelected || isInRange
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? Colors.white
                        : isInRange
                            ? Colors.black
                            : isCurrentMonth
                                ? Colors.black
                                : Colors.grey[400],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Hiển thị dialog chọn ngày
  void _showCustomDatePicker(BuildContext context) {
    // Lưu trữ giá trị ban đầu để phục hồi nếu người dùng hủy
    final initialStartDate = startDate;
    final initialEndDate = endDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Cách hiển thị biểu đồ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _periodButton(context, 'Ngày', setDialogState),
                        _periodButton(context, 'Tuần', setDialogState),
                        _periodButton(context, 'Tháng', setDialogState),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ngày bắt đầu'),
                            Text(
                              DateFormat('dd/MM/yyyy').format(startDate),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: widget.branch['color'] as Color,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ngày kết thúc'),
                            Text(
                              DateFormat('dd/MM/yyyy').format(endDate),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    StatefulBuilder(
                      builder: (context, setCalendarState) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.chevron_left),
                                  onPressed: () {
                                    setCalendarState(() {
                                      _previousMonth();
                                    });
                                  },
                                ),
                                Text(
                                  DateFormat('MMMM, yyyy')
                                      .format(calendarMonth),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.chevron_right),
                                  onPressed: () {
                                    setCalendarState(() {
                                      _nextMonth();
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            _buildSelectionStatus(),
                            SizedBox(height: 8),
                            _buildCalendarGrid(context, setCalendarState),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            // Phục hồi giá trị ban đầu khi hủy
                            setState(() {
                              startDate = initialStartDate;
                              endDate = initialEndDate;
                              isSelectingStartDate = true;
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text('Hủy'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.branch['color'] as Color,
                            minimumSize: Size(150, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              // Giữ nguyên giá trị đã chọn
                              isSelectingStartDate =
                                  true; // Reset về trạng thái ban đầu
                              // Tính toán lại tổng doanh thu dựa trên khoảng thời gian mới
                              _calculateTotalRevenue();
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Xác nhận',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Chuyển đến màn hình quản lý nhân viên
  void _navigateToEmployeesScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeesScreen(
          branch: widget.branch,
          onBranchChanged: widget.onBranchChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final branchColor = widget.branch['color'] as Color;
    final employeeCount = (widget.branch['employees'] as List? ?? []).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.branch['name']),
        backgroundColor: branchColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.people),
            onPressed: _navigateToEmployeesScreen,
            tooltip: 'Quản lý nhân viên',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin cơ bản
            Card(
              elevation: 2,
              margin: EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: branchColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          widget.branch['name'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    if (widget.branch['address'] != null &&
                        widget.branch['address'].toString().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 18, color: Colors.grey[600]),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.branch['address'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tổng số nhân viên:',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '$employeeCount người',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Tiêu đề biểu đồ
            const Text(
              'Biểu đồ doanh thu',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Chọn khoảng thời gian
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Từ: ${DateFormat('dd/MM/yyyy').format(startDate)}',
                      style: TextStyle(fontSize: 14),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today, size: 20),
                      onPressed: () => _showCustomDatePicker(context),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Đến: ${DateFormat('dd/MM/yyyy').format(endDate)}',
                      style: TextStyle(fontSize: 14),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today, size: 20),
                      onPressed: () => _showCustomDatePicker(context),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Biểu đồ doanh thu
            SizedBox(
              height: 300,
              child: _buildRevenueChart(),
            ),
            const SizedBox(height: 20),

            // Thông tin tổng thu
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tổng thu'),
                    Text(
                      _formatCurrency(totalRevenue),
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            // Nút quản lý nhân viên
            ElevatedButton.icon(
              onPressed: _navigateToEmployeesScreen,
              icon: Icon(Icons.people),
              label: Text('Quản lý nhân viên chi nhánh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: branchColor,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
