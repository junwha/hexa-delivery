Future<List<String>> getStoreNames() async {
  return getStoreNamesTest();
}

Future<List<String>> getStoreNamesTest() {
  List<String> storeNames = [
    'BBQ치킨',
    'BHC',
    '교촌치킨',
    '처갓집 양념치킨',
    '페리카나',
    '네네치킨',
    '굽네치킨',
    '멕시카나',
    '호식이 두마리치킨',
    '푸라닭치킨',
    '또래오래',
    '지코바치킨',
    '가마치통닭',
    '60계',
    '노랑통닭',
    '자담치킨',
    '또봉이통닭',
    '치킨플러스',
    '티바두마리치킨',
    '맥시칸치킨',
    '펀비어킹',
    '부어치킨',
    '땅땅치킨',
    '치킨마루',
    '훌랄라 숯불치킨',
    '코리엔탈 깻잎두마리치킨',
    '신통치킨',
    '후라이드참잘하는집',
    '돈치킨',
    '누구나홀딱반한닭',
    '치킨신드롬',
    '깐부치킨',
    '치킨더홈',
    '치킨매니아',
    '투존치킨',
    '호치킨',
    '보드람치킨',
    '알통떡강정',
    '치요남치킨',
    '본스치킨',
    '불로만치킨바베큐',
    '오븐마루',
    '맛닭꼬',
    '오븐에 꾸운 닭',
    '충만치킨',
    '디디치킨',
    '가마로강정',
    '코리안바베큐',
    '장모님치킨',
    '오태식해바라기치킨',
    '이춘봉인생치킨',
    '둘둘치킨',
    '다사랑치킨',
  ];

  return Future<List<String>>.delayed(
      const Duration(
        milliseconds: 3000,
      ), () {
    return storeNames;
  });
}

Future<List<String>> getPlaceNames() async {
  return getPlaceNamesTest();
}

Future<List<String>> getPlaceNamesTest() {
  List<String> placeNames = [
    '1차 기숙사 광장',
    '3차 기숙사 광장',
    '공학관 앞',
    '학술 정보관 앞',
    '버스 정류장 앞'
  ];

  return Future<List<String>>.delayed(
      const Duration(
        milliseconds: 3000,
      ), () {
    return placeNames;
  });
}
