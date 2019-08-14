# My Reading Speed

#### NOTES:

- `I` coded the stopwatch feature with help from https://tinyurl.com/y6bkyf6u

- shared_preferences used to persist settings. See
  `Future<void> _populateFields() async {}`

- ```dart
  home: Scaffold(  resizeToAvoidBottomInset:false, //keyboard slides over UI without resizing UI
  ```

- UI is a `ListView` so everything fits inside a scrollable screen. 
- Used `TextEditingConroller` widgets to set and get values in `TextFields`.