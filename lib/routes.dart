class AppRoute{
  final String name;
  final String path;//relative
  AppRoute({required this.name,required this.path});
}

class AppRoutes{
  static AppRoute splashRoute=AppRoute(name: 'splash', path: '/splash');
  static AppRoute errorRoute=AppRoute(name: 'error', path: '/error');
  static AppRoute problems=AppRoute(name: 'problems', path: '/problems');
  static AppRoute problemsHome=AppRoute(name: 'problems home', path: 'problems/category');
  static AppRoute problemsByCategory=AppRoute(name: 'problems by language', path: 'language/:language');
  static AppRoute problemDetail=AppRoute(name: 'problem detail', path: 'language/:language/problemId/:problemId/detail');
  static AppRoute tagProblems=AppRoute(name: 'tag problems', path: 'tag/:tagId/problems');
}