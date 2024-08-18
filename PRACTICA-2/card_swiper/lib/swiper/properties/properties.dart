class AllowedSwipeDirection {
  const AllowedSwipeDirection.all()
      : right = true,
        left = true;

  const AllowedSwipeDirection.none()
      : right = false,
        left = false;

  const AllowedSwipeDirection.only({
    this.left = false,
    this.right = false,
  });

  final bool left;
  final bool right;
}