class ToDoItem {
  final String title;
  bool isChecked;
  bool isExpanded;

  ToDoItem({
    required this.title,
    this.isChecked = false,
    this.isExpanded = false,
  });
}
