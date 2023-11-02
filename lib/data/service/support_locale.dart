class SupportLocale {
  static const String en = "en";
  static const String vi = "vi";
  static const String cn = "zh-cn";

  static final List<ItemLanguage> listLanguage = [
    ItemLanguage(codeLanguage: SupportLocale.vi, nameLanguage: "Vietnamese"),
    ItemLanguage(codeLanguage: SupportLocale.en, nameLanguage: "English"),
    ItemLanguage(codeLanguage: SupportLocale.cn, nameLanguage: "Chinese"),
  ];

  static ItemLanguage getItemLanguage(String codeLanguage) {
    return listLanguage.firstWhere((item) =>
        item.codeLanguage!.toLowerCase() == codeLanguage.toLowerCase());
  }
}

class ItemLanguage {
  String? codeLanguage;
  String? nameLanguage;
  bool isSelected;

  ItemLanguage({this.codeLanguage, this.nameLanguage, this.isSelected = false});
}
