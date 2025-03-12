const domain = 'https://swd392-server-vakx.onrender.com';

class BaseLink {
  static String login = '$domain/api/login';
  static String getRestaurants = '$domain/restaurant/get';
  static String getResById = '$domain/restaurant';
  static String getEmployeeOfRestaurant = '$domain/user/restaurant';
  static String createRestaurant = '$domain/restaurant/create';
  static String endPointUser = '$domain/user';
}
