String? titleValidator(String? inp) {
  if (inp == null) {
    return 'Title is required';
  } else if (inp.length < 3 || inp.length > 64) {
    return 'Title must be 3 to 64 characters';
  }
  return null;
}

String? descriptionValidator(String? inp) {
  if (inp == null) {
    return 'Description is required';
  } else if (inp.length < 3 || inp.length > 256) {
    return 'Description must be 3 to 256 characters';
  }
  return null;
}

String? stockValidator(String? inp) {
  if (inp == null) {
    return 'Stock is required';
  } else {
    int? inpInt = int.tryParse(inp);
    if (inpInt == null || inpInt <= 0) {
      return 'Stock must be integer greater than 0';
    }
  }
  return null;
}

String? priceValidator(String? inp) {
  if (inp == null) {
    return 'Price is required';
  } else {
    double? inpInt = double.tryParse(inp);
    if (inpInt == null || inpInt <= 0) {
      return 'Price must be number greater than 0';
    }
  }
  return null;
}
