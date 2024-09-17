import 'package:shared_preferences/shared_preferences.dart';
import '../model/donor_user_model.dart';
import '../model/user_model.dart';

class SharedPrefClient {
  static const donoruserId = 'donoruserId';
  static const donoremail = 'donoremail';

  Future<bool> isUserLoggedIn() async {
    final sharedPref = await SharedPreferences.getInstance();
    final userToken = sharedPref.getString(donoruserId);
    return userToken != null;
  }

  Future<bool> isAccepterLoggedIn() async {
    final sharedPref = await SharedPreferences.getInstance();
    final userToken = sharedPref.getString(accepteruserId);
    return userToken != null;
  }

  Future<DonorUserModel> getUser() async {
    final sharedPref = await SharedPreferences.getInstance();
    final id = sharedPref.getString(donoruserId);
    final mail = sharedPref.getString(donoremail);
    return DonorUserModel(id!, mail!);
  }

  Future<void> setUser(DonorUserModel user) async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setString(donoruserId, user.donoruserId);
    await sharedPref.setString(donoremail, user.donoremail);
  }

  Future<void> clearUser() async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.remove(donoruserId);
  }

  Future<void> clearAcceptar() async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.remove(accepteruserId);
  }

  //accepter shared prefrances
  static const accepteruserId = 'accepteruserId';
  static const accepteremail = 'accepteremail';

  Future<bool> isUserLoggedInaccepter() async {
    final sharedPref = await SharedPreferences.getInstance();
    final accuserToken = sharedPref.getString(accepteruserId);
    return accuserToken != null;
  }

  Future<AccepterUserModel> getUseraccepter() async {
    final sharedPref = await SharedPreferences.getInstance();
    final id = sharedPref.getString(accepteruserId);
    final mail = sharedPref.getString(accepteremail);
    return AccepterUserModel(id!, mail!);
  }

  Future<void> setUseraccepter(AccepterUserModel user) async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setString(accepteruserId, user.accepteruserId);
    await sharedPref.setString(accepteremail, user.accepteremail);
  }

  Future<void> clearUseraccepter() async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.remove(accepteruserId);
  }
}
