class BottomNavigationState {
  BottomNavigationState({this.pageIndex = 0, this.pageTitle = 'Dashboard'});

  final String pageTitle;
  final int pageIndex;

  BottomNavigationState copyWith({int? pageIndex, String? pageTitle}) {
    return BottomNavigationState(pageIndex: pageIndex ?? this.pageIndex, pageTitle: pageTitle ?? this.pageTitle);
  }
}
