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

const List<String> kCategoryList = [
  '치킨',
  '피자',
  '양식',
  '한식',
  '중식',
  '일식',
  '분식',
  '야식',
  '간식',
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
