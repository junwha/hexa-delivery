enum Category {
  chicken,
  pizza,
  western,
  korean,
  chinese,
  japanese,
  school,
  night,
  snack
}

const List<Map> kCategoryList = [
  {'Name': "치킨", 'Icon': "🍗"},
  {'Name': "피자", 'Icon': "🍕"},
  {'Name': "양식", 'Icon': "🍔"},
  {'Name': "한식", 'Icon': "🍚"},
  {'Name': "중식", 'Icon': "🥟"},
  {'Name': "일식", 'Icon': "🍣"},
  {'Name': "분식", 'Icon': "🍜"},
  {'Name': "야식", 'Icon': "🥘"},
  {'Name': "간식", 'Icon': "🍰"},
];

const Map<Category, String> kCategory2String = {
  Category.chicken: '치킨',
  Category.pizza: "피자",
  Category.western: '양식',
  Category.korean: '한식',
  Category.chinese: '중식',
  Category.japanese: '일식',
  Category.school: '분식',
  Category.night: '야식',
  Category.snack: '간식',
};
Map<String, Category> kString2Category =
    Map.fromIterables(kCategory2String.values, kCategory2String.keys);
