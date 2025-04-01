Map<String, String> colorName = {
  'FF000000': 'Black',
  'FF9E9E9E': 'Grey', 
  'FFFFFFFF': 'White', 
  'FFF44336': 'Red', 
  'FFFF9800': 'Orange', 
  'FFFFEB3B': 'Yellow',
  'FF4CAF50': 'Green', 
  'FF2196F3': 'Blue', 
  'FF607D8B': 'Blue Grey', 
  'FF3F51B5': 'Indigo', 
  'FF9C27B0': 'Purple', 
  'FF795548': 'Brown',
};

String convertArgbToHex(String argbColor) {
  if (argbColor.length != 8) {
    throw ArgumentError('Invalid ARGB color format');
  }
  
  // Extract the RRGGBB part
  String hexColor = argbColor.substring(2);
  
  return '#$hexColor';
}