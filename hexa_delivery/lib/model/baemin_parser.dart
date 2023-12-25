String testinput =
    "슈뢰딩거님이 맛나니 김치보쌈 평촌점의 함께주문에 초대했어요. 원하는 메뉴를 담아주세요.\nhttps://s.baemin.com/37g.dzg61";

RegExp restaurantRegex =
    RegExp(r'(?<=님이\s).+?(?=의 함께주문에 초대했어요\. 원하는 메뉴를 담아주세요\.\n)');
RegExp urlRegex = RegExp(r'(?<=\n).+');

Map<String, dynamic> parseBaeminSharing(String input) {
  String? restaurant = restaurantRegex.firstMatch(input)?.group(0);
  String? url = urlRegex.firstMatch(input)?.group(0);

  return {
    'is_successful': restaurant != null && url != null,
    'restaurant': restaurant,
    'url': url,
  };
}
