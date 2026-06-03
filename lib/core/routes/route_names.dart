abstract final class RouteNames {
  static const root = '/';
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const home = '/home';
  static const caseDetail = '/home/case/:caseId';
  static const create = '/create';
  static const createRelationship = '/create/relationship';
  static const createCategory = '/create/category';
  static const createDescription = '/create/description';
  static const createQuestion = '/create/question';
  static const createSuccess = '/create/success';
  static const inbox = '/inbox';
  static const profile = '/profile';
  static const profileEdit = '/profile/edit';
  static const profileSaved = '/profile/saved';
  static const settings = '/settings';
  static const premium = '/premium';

  static const protectedRoutes = <String>{
    home,
    create,
    createRelationship,
    createCategory,
    createDescription,
    createQuestion,
    createSuccess,
    inbox,
    profile,
    profileEdit,
    profileSaved,
    settings,
    premium,
  };
}
