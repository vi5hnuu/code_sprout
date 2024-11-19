class  Pageable<T> {
    List<T> data;
    int pageNo;
    int totalPages;

    Pageable({required this.data, required this.pageNo, required this.totalPages});
}