import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart'; // Để format ngày tháng và số tiền
import 'dart:math'; // Để tạo dữ liệu mẫu
import 'branches_screen.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime startDate =
      DateTime.now().subtract(Duration(days: 7)); // Mặc định 7 ngày trước
  DateTime endDate = DateTime.now(); // Mặc định hôm nay
  String selectedPeriod = 'Ngày'; // 'Ngày', 'Tuần', 'Tháng'
  DateTime calendarMonth = DateTime.now();
  bool isSelectingStartDate =
      true; // true = đang chọn ngày bắt đầu, false = đang chọn ngày kết thúc

  // Dữ liệu doanh thu mẫu
  List<Map<String, dynamic>> revenueData = [];
  double totalRevenue = 0;

  // Danh sách chi nhánh
  List<Map<String, dynamic>> branches = [];

  @override
  void initState() {
    super.initState();
    // Tạo dữ liệu mẫu
    _generateSampleData();
    // Tạo danh sách chi nhánh mẫu
    _generateSampleBranches();
    // Tính tổng doanh thu trong khoảng thời gian đã chọn
    _calculateTotalRevenue();
  }

  // Tạo danh sách chi nhánh mẫu
  void _generateSampleBranches() {
    final branchNames = [
      'Chi nhánh Hà Nội',
      'Chi nhánh Hồ Chí Minh',
      'Chi nhánh Đà Nẵng',
      'Chi nhánh Cần Thơ',
      'Chi nhánh Hải Phòng',
      'Chi nhánh Nha Trang',
    ];

    branches = branchNames.map((name) {
      return {
        'name': name,
        'revenue': 0.0,
        'percentage': 0.0,
        'color': Color.fromRGBO(Random().nextInt(200) + 55,
            Random().nextInt(200) + 55, Random().nextInt(200) + 55, 1.0),
        'employees': [], // Thêm danh sách nhân viên
      };
    }).toList();
  }

  // Cập nhật danh sách chi nhánh
  void _updateBranches(List<Map<String, dynamic>> updatedBranches) {
    setState(() {
      branches = updatedBranches;
    });
  }

  // Tạo dữ liệu mẫu cho 30 ngày gần đây
  void _generateSampleData() {
    final random = Random();
    final now = DateTime.now();

    revenueData = List.generate(30, (index) {
      final date = now.subtract(Duration(days: 29 - index));
      return {
        'date': date,
        'revenue': 200000.0 +
            random.nextInt(
                800000), // Doanh thu ngẫu nhiên từ 200,000 đến 1,000,000
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

    // Sau khi tính tổng, cập nhật dữ liệu chi nhánh
    _updateBranchData();
  }

  // Cập nhật dữ liệu chi nhánh dựa trên khoảng thời gian đã chọn
  void _updateBranchData() {
    if (branches.isEmpty) return;

    final random = Random();
    // Tạo một phân phối ngẫu nhiên cho các chi nhánh dựa trên tổng doanh thu
    double remainingPercentage = 100.0;

    // Tạo bản sao của danh sách chi nhánh để cập nhật
    List<Map<String, dynamic>> updatedBranches = [];
    for (var branch in branches) {
      // Create a deep copy of the branch
      Map<String, dynamic> updatedBranch = Map<String, dynamic>.from(branch);
      // Ensure employees field exists
      if (updatedBranch['employees'] == null) {
        updatedBranch['employees'] = [];
      }
      updatedBranches.add(updatedBranch);
    }

    for (int i = 0; i < updatedBranches.length - 1; i++) {
      // Lấy một phần ngẫu nhiên từ phần còn lại, nhưng đảm bảo chi nhánh quan trọng hơn có phần lớn hơn
      double maxPercent = remainingPercentage * (0.5 / (i + 1));
      double percentage = random.nextDouble() * maxPercent + 5.0;
      if (i == 0) percentage += 15.0; // Chi nhánh đầu tiên lớn hơn
      if (percentage > remainingPercentage) percentage = remainingPercentage;

      updatedBranches[i]['percentage'] = percentage;
      updatedBranches[i]['revenue'] = totalRevenue * percentage / 100;
      remainingPercentage -= percentage;
    }

    if (updatedBranches.isNotEmpty) {
      // Chi nhánh cuối cùng nhận phần còn lại
      updatedBranches.last['percentage'] = remainingPercentage;
      updatedBranches.last['revenue'] =
          totalRevenue * remainingPercentage / 100;

      // Sắp xếp lại theo doanh thu giảm dần
      updatedBranches.sort(
          (a, b) => (b['revenue'] as double).compareTo(a['revenue'] as double));

      // Cập nhật state
      setState(() {
        branches = updatedBranches;
      });
    }
  }

  // Hiển thị bottom sheet danh sách chi nhánh
  void _showBranchesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(16),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Doanh thu theo chi nhánh',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Tổng doanh thu: ${_formatCurrency(totalRevenue)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Từ ${DateFormat('dd/MM/yyyy').format(startDate)} đến ${DateFormat('dd/MM/yyyy').format(endDate)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: branches.length,
                      itemBuilder: (context, index) {
                        final branch = branches[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: branch['color'] as Color,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        branch['name'] as String,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${(branch['percentage'] as double).toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Stack(
                                children: [
                                  Container(
                                    height: 10,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  Container(
                                    height: 10,
                                    width: MediaQuery.of(context).size.width *
                                        (branch['percentage'] as double) /
                                        100 *
                                        0.85,
                                    decoration: BoxDecoration(
                                      color: branch['color'] as Color,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                _formatCurrency(branch['revenue'] as double),
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Chuyển đến màn hình quản lý chi nhánh
                      Navigator.pop(context); // Đóng bottom sheet
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BranchesScreen(
                            branches: branches,
                            onBranchesChanged: _updateBranches,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Quản lý Chi Nhánh',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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

  // Đặt lại quá trình chọn
  void _resetDateSelection() {
    setState(() {
      isSelectingStartDate = true;
    });
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
              color: Colors.blue,
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
          border:
              Border.all(color: isSelected ? Colors.blue : Colors.grey[300]!),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.blue : Colors.black,
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
                          ? Colors.blue
                          : Colors.green)
                      : isInRange
                          ? Colors.blue[50]
                          : isCurrentMonth
                              ? Colors.grey[200]
                              : Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isSelected
                        ? (day.isAtSameMomentAs(startDate)
                            ? Colors.blue
                            : Colors.green)
                        : isInRange
                            ? Colors.blue
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
                            ? Colors.blue[800]
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
                                color: Colors.blue,
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
                            backgroundColor: Colors.blue,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Biểu đồ doanh thu',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
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
              SizedBox(
                height: 300,
                child: _buildRevenueChart(),
              ),
              const SizedBox(height: 20),
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
                      TextButton(
                        onPressed: () {
                          _showBranchesBottomSheet(context);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Xem từng chi nhánh'),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_drop_down, size: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Chi nhánh',
          ),
        ],
        currentIndex: 2, // Dashboard tab
        onTap: (index) {
          if (index == 3) {
            // Chi nhánh tab
            // Mở màn hình quản lý chi nhánh
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BranchesScreen(
                  branches: branches,
                  onBranchesChanged: _updateBranches,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
