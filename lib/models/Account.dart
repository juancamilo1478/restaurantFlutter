class ProductAccount {
  int id;
  String type;
  String name;
  int price;
  String photo;
  int store;
  int quantity;

  ProductAccount({
    required this.id,
    required this.type,
    required this.name,
    required this.price,
    required this.photo,
    required this.store,
    required this.quantity,
  });
}

class AccountModel {
  int id;
  String total;
  String date;
  String state;
  String propine;
  int waitersId;
  int tableId;
  List<ProductAccount> products;

  AccountModel({
    required this.id,
    required this.total,
    required this.date,
    required this.state,
    required this.propine,
    required this.waitersId,
    required this.tableId,
    required this.products,
  });
}

class AccountBasic {
  int id;
  String box;
  String card;
  String date;
  String state;
  String propine;
  int waitersId;
  int tableId;
  AccountBasic(
      {required this.id,
      required this.card,
      required this.box,
      required this.date,
      required this.state,
      required this.propine,
      required this.waitersId,
      required this.tableId});
}

class AccountsPage {
  List<AccountModel> accounts;
  int totalPages;
  int currentPage;
  AccountsPage({
    required this.accounts,
    required this.totalPages,
    required this.currentPage,
  });
}
