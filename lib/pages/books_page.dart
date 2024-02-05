import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/books_cubit.dart';
import '../models/book.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const DialogContent(),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: BlocBuilder<BooksCubit, BooksState>(
        builder: (_, state) {
          return ListView(
            padding: const EdgeInsets.all(10),
            children: state.books.map((book) => BookRowCard(book)).toList(),
          );
        },
      ),
    );
  }
}

class BookRowCard extends StatelessWidget {
  const BookRowCard(this.book, {super.key});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        alignment: Alignment.center,
        height: 60,
        child: ListTile(
          leading: const Icon(Icons.person),
          title: Text('${book.id} - ${book.title}'),
          subtitle: Text('User: ${book.userName} - ${book.pages} pages'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return DialogContent(book: book);
                      },
                    );
                  },
                  icon: const Icon(Icons.edit)),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Delete'),
                        content:
                            Text('Do you want to delete "${book.title}" ?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<BooksCubit>().delBook(book.id!);
                              Navigator.pop(context);
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DialogContent extends StatelessWidget {
  const DialogContent({this.book, super.key});

  final Book? book;

  @override
  Widget build(BuildContext context) {
    var textTitle = TextEditingController();
    var textPages = TextEditingController();
    var textUserId = TextEditingController();
    if (book != null) {
      textTitle.text = book!.title;
      textPages.text = book!.pages.toString();
      textUserId.text = book!.userId.toString();
    }
    return AlertDialog(
      title: const Text('Book info'),
      content: SizedBox(
        height: 165,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textField('Book title', textTitle),
            const SizedBox(height: 10),
            textField('Pages', textPages, TextInputType.number),
            const SizedBox(height: 10),
            textField('User Id', textUserId, TextInputType.number),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (textTitle.text.trim().isNotEmpty &&
                textPages.text.trim().isNotEmpty &&
                textUserId.text.trim().isNotEmpty) {
              book == null
                  ? context.read<BooksCubit>().addBook(
                        Book(
                          title: textTitle.text,
                          pages: int.tryParse(textPages.text.trim()) ?? 0,
                          userId: int.tryParse(textUserId.text.trim()) ?? 0,
                        ),
                      )
                  : context.read<BooksCubit>().editBook(Book(
                        id: book!.id,
                        title: textTitle.text,
                        pages: int.tryParse(textPages.text.trim()) ?? 0,
                        userId: int.tryParse(textUserId.text.trim()) ?? 0,
                      ));
              Navigator.pop(context);
            }
          },
          child: Text(book == null ? 'Add' : 'Save changes'),
        ),
      ],
    );
  }

  TextFormField textField(
    String label,
    TextEditingController textName, [
    TextInputType? inputType,
  ]) {
    return TextFormField(
      controller: textName,
      keyboardType: inputType,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        label: Text(label),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
