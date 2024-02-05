import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_db/data/book_repository.dart';

import '../models/book.dart';

part 'books_state.dart';

class BooksCubit extends Cubit<BooksState> {
  BooksCubit() : super(BooksState([]));

  final BookRepository _bookRepository = BookRepository();

  Future<void> refresh() async {
    state.books = await _bookRepository.getAllBooks();
    emit(BooksState(state.books));
  }

  Future<void> addBook(Book book) async {
    _bookRepository.addBook(book);
    refresh();
  }

  Future<void> delBook(int id) async {
    _bookRepository.deleteBook(id);
    refresh();
  }

  Future<void> editBook(Book book) async {
    _bookRepository.updateBook(book);
    refresh();
  }
}
