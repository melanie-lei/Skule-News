enum DataType {
  blog,
  source,

  dashboard,
  categories,
  addCategories,
  users
}

enum MenuType {
  dashboard,

  categories,
  deactivatedCategories,
  addCategory,

  activeBlogs,
  featuredBlogs,
  pendingApprovalBlogs,
  deactivatedBlogs,
  addBlog,

  users,
  authors,

  deactivatedUsers,
  deactivatedAuthors,

  addUsers,

  packages,
  addPackage,

  settings,
  supportRequests,
  reportAbusedBlogs,
  reportAbusedAuthors,

  changePassword,
}

enum AccountStatusType {
  all,
  active,
  deactivated,
}

enum BlogStatusType {
  all,
  active,
  deactivated,
  featured,
}

enum CategoryStatusType {
  all,
  active,
  deactivated,
}

enum RecordType {
  profile,
  post,
  hashtag,
  location,
}

enum DataOwner {
  admin,
  user,
}

enum AvailabilityStatus {
  active,
  deactivated,
}
