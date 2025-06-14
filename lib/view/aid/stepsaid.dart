// first_aid_data.dart
class FirstAidStepsData {
  static final Map<String, List<String>> steps = {
    'burns': [
      '1. Cool the burn with cool (not cold) running water for 10-20 minutes.',
      '2. Do not apply ice or greasy substances like butter.',
      '3. Remove any tight items, like rings or belts, from the burned area.',
      '4. Cover the burn with a clean, non-stick bandage or cloth.',
      '5. Avoid breaking blisters.',
      '6. Seek medical help if it’s a deep, large, or facial burn.',
    ],
    'cuts_and_bleeding': [
      '1. Wash your hands and wear gloves if available.',
      '2. Apply gentle pressure with a clean cloth to stop bleeding.',
      '3. Clean the wound with clean water.',
      '4. Apply an antibiotic cream (if available).',
      '5. Cover with a sterile bandage.',
      '6. Seek medical help if bleeding doesn’t stop or the cut is deep.',
    ],
    'choking': [
      '1. Ask the person if they can speak or cough.',
      '2. If not, stand behind them and perform abdominal thrusts.',
      '3. Repeat until the object is expelled.',
      '4. If they become unconscious, call emergency services and start CPR.',
    ],
    'heart_attack': [
      '1. Call emergency services immediately.',
      '2. Help the person sit down, keep them calm.',
      '3. Offer aspirin if they’re not allergic.',
      '4. Monitor their breathing and be ready to perform CPR if needed.',
    ],
    'fractures': [
      '1. Keep the injured area still.',
      '2. Apply a splint if trained.',
      '3. Use a cold pack to reduce swelling.',
      '4. Elevate the limb if possible.',
      '5. Get medical help right away.',
    ],
  };

  static List<String> getSteps(String title) {
    print('FirstAidStepsData.getSteps called with title: "$title"');
    print('Available steps keys: ${steps.keys.toList()}');
    // Debug: Log title bytes to detect hidden characters
    print('Title bytes: ${title.codeUnits}');
    // Try exact match
    if (steps.containsKey(title)) {
      return steps[title]!;
    }

    // Try case-insensitive match
    final lowerTitle = title.toLowerCase();
    for (final key in steps.keys) {
      if (key.toLowerCase() == lowerTitle) {
        print('Found case-insensitive match: "$key" for "$title"');
        return steps[key]!;
      }
    }
    return steps[title] ?? ['No steps available for this topic.'];
  }
}
