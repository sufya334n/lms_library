import 'package:mysql1/mysql1.dart';

class Mysql {
  // Note: if you are using terminal base connection than localHost is 127.0.0.1
  // Note if you are using fluter Emulator than localHost connection address is 10.0.2.2
  static String host = '127.0.0.1',
      user = 'root',
      // Note:- I am not using any password in my database
      // password = "123456789",

      // Database name that i created inside mySQL (Which should already exited)
      db = 'librarysystem';
  // Note:- MySQL sever port
  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = ConnectionSettings(
      host: host,
      port: port,
      user: user,
    //   password: password,
      db: db,
    );
    return await MySqlConnection.connect(settings);
  }
}
