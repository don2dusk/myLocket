class Number {
  String numberParse(String phonenumber) {
    List<String> keyValuePairs =
        phonenumber.substring(12, phonenumber.length - 1).split(',');
    String formattedNumber = '';

    for (String pair in keyValuePairs) {
      List<String> keyValue = pair.split(':');
      String key = keyValue[0].trim();
      String value = keyValue[1].trim();

      if (key == 'countryCode' || key == 'nsn') {
        formattedNumber += value;
      }
    }

    formattedNumber = '+$formattedNumber';
    return formattedNumber;
  }

  String returnrawNum(String phonenumber) {
    List<String> keyValuePairs =
        phonenumber.substring(12, phonenumber.length - 1).split(',');
    String formattedNumber = '';

    for (String pair in keyValuePairs) {
      List<String> keyValue = pair.split(':');
      String key = keyValue[0].trim();
      String value = keyValue[1].trim();

      if (key == 'nsn') {
        formattedNumber += value;
      }
    }

    formattedNumber = formattedNumber;
    return formattedNumber;
  }

  bool isEmpty(phoneNumber) {
    if (returnrawNum(phoneNumber) == '') {
      return true;
    }
    return false;
  }
}
