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
  rejectedBlogs,
  deactivatedBlogs,
  addBlog,

  changePassword,
  updateProfile,

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
  pending,
  rejected,
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
