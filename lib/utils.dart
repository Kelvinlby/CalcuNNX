int? calculate(String text) {
  try {
    final shapePattern = RegExp(r'Array\(shape=\(([\d, ]+)\),');
    final matches = shapePattern.allMatches(text);

    int totalSum = 0;

    for (final match in matches) {
      final shapeString = match.group(1);
      if (shapeString == null) continue;

      final dims = shapeString
          .split(',')
          .map((dim) => dim.trim())
          .where((dim) => dim.isNotEmpty)
          .map((dim) {
            try {
              return int.parse(dim);
            } catch (e) {
              return null;
            }
          })
          .where((dim) => dim != null)
          .cast<int>()
          .toList();

      if (dims.isNotEmpty) {
        int totalProduct = dims.reduce((a, b) => a * b);
        totalSum += totalProduct;
      }
    }

    return totalSum;
  } catch (e) {
    return null;
  }
}

String formatParameterCount(int parameterCount) {
  if (parameterCount == 0) return "0";

  // Define the units and their thresholds
  const units = [
    {'threshold': 1000000000000, 'suffix': 'T'}, // Trillion
    {'threshold': 1000000000, 'suffix': 'B'},    // Billion
    {'threshold': 1000000, 'suffix': 'M'},       // Million
    {'threshold': 1000, 'suffix': 'K'},          // Thousand
  ];

  for (final unit in units) {
    final threshold = unit['threshold'] as int;
    final suffix = unit['suffix'] as String;

    if (parameterCount >= threshold) {
      final value = parameterCount / threshold;

      // Format with appropriate decimal places
      if (value >= 100) {    // Show no decimal places (e.g., "125M")
        return '${value.round()}$suffix';
      } else if (value >= 10) {   // Show 1 decimal place (e.g., "12.5M")
        return '${value.toStringAsFixed(1)}$suffix';
      } else {                    // For values < 10, show 2 decimal places (e.g., "1.25M")
        return '${value.toStringAsFixed(2)}$suffix';
      }
    }
  }

  // If less than 1000, return the number as-is
  return parameterCount.toString();
}
