extension TypeX on Type {
  bool sameTypeAs<S, V>() {
    void func<X extends S>() {}
    return func is void Function<X extends V>();
  }
}
