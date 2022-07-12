extension NumberParsing on String {
  List<String> allPossibleSubstrings() {
    List<String> strings = [];
    for (int i = 0; i < length; i++) {
      //This loop adds the next character every iteration for the subset to form and add it to the array
      for (int j = i; j < length; j++) {
        strings.add(substring(i, j + 1).toLowerCase());
      }
    }
    return strings.toSet().toList();
  }

  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

}
