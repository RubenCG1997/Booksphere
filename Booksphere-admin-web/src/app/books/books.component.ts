import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { BooksService, Book } from '../services/books.service';
import { AuthorsService, Author } from '../services/authors.service';
import { PublishersService, Publisher } from '../services/publisher.service';
import { Observable, firstValueFrom } from 'rxjs';
import { map } from 'rxjs/operators';
import { NavbarComponent } from "../navbar/navbar.component";

@Component({
  selector: 'app-books',
  standalone: true,
  imports: [CommonModule, FormsModule, NavbarComponent],
  templateUrl: './books.component.html',
  styleUrls: ['./books.component.css']
})
export class BooksComponent {
  books$: Observable<Book[]>;
  filteredBooks$: Observable<Book[]>;

  authors$: Observable<Author[]>;
  publishers$: Observable<Publisher[]>;

  newBook: Partial<Book> = {};
  editingBook: Book | null = null;
  bookToDelete: Book | null = null;
  searchTerm: string = '';

  epubFile?: File;
  imgFile?: File;

  authorMap: { [id: string]: string } = {};
  publisherMap: { [id: string]: string } = {};


activeTab: 'create' | 'manage' = 'create';

  constructor(
  private booksService: BooksService,
  private authorsService: AuthorsService,
  private publishersService: PublishersService
) {
  this.books$ = this.booksService.getBooks();
  this.filteredBooks$ = this.books$;
  this.authors$ = this.authorsService.getAuthors();
  this.publishers$ = this.publishersService.getPublishers();

  this.authors$.subscribe(authors => {
    this.authorMap = {};
    authors.forEach(author => {
      if (author.uid && author.name) {
        this.authorMap[author.uid] = author.name;
      }
    });
  });

  this.publishers$.subscribe(publishers => {
    this.publisherMap = {};
    publishers.forEach(pub => {
      if (pub.uid && pub.name) {
        this.publisherMap[pub.uid] = pub.name;
      }
    });
  });


}

  onSearchChange() {
    const term = this.searchTerm.toLowerCase().trim();
    this.filteredBooks$ = this.books$.pipe(
      map(books => books.filter(book =>
        book.title.toLowerCase().includes(term)
      ))
    );
  }

  onEpubSelected(event: any) {
    this.epubFile = event.target.files[0];
  }

  onImgSelected(event: any) {
    this.imgFile = event.target.files[0];
  }

  async addBook() {
    if (
      !this.newBook.title ||
      !this.newBook.isbn ||
      !this.newBook.date ||
      !this.newBook.genre ||
      !this.newBook.description ||
      !this.newBook.idAuthor ||
      !this.newBook.idPublisher ||
      !this.epubFile ||
      !this.imgFile
    ) {
      return;
    }

    try {
      const epubUrl = await firstValueFrom(this.booksService.uploadEpubFile(this.epubFile));
      const imgUrl = await firstValueFrom(this.booksService.uploadImageFile(this.imgFile));

      const book: Book = {
        title: this.newBook.title!,
        isbn: this.newBook.isbn!,
        date: this.newBook.date!,
        genre: this.newBook.genre!,
        description: this.newBook.description!,
        idAuthor: this.newBook.idAuthor!,
        idPublisher: this.newBook.idPublisher!,
        urlEpub: epubUrl,
        urlImg: imgUrl
      };

      await this.booksService.addBook(book);
      this.newBook = {};
      this.epubFile = undefined;
      this.imgFile = undefined;
      this.onSearchChange();
    } catch (error) {
      console.error('Error al agregar libro:', error);
    }
  }

  editBook(book: Book) {
    this.editingBook = { ...book };
  }

  async updateBook() {
    if (!this.editingBook?.isbn) return;

    try {
      const updates: Partial<Book> = {
        title: this.editingBook.title,
        isbn: this.editingBook.isbn,
        date: this.editingBook.date,
        genre: this.editingBook.genre,
        description: this.editingBook.description,
        idAuthor: this.editingBook.idAuthor,
        idPublisher: this.editingBook.idPublisher
      };

      if (this.epubFile) {
        updates.urlEpub = await firstValueFrom(this.booksService.uploadEpubFile(this.epubFile));
      }
      if (this.imgFile) {
        updates.urlImg = await firstValueFrom(this.booksService.uploadImageFile(this.imgFile));
      }

      await this.booksService.updateBook(this.editingBook.isbn, updates);

      this.editingBook = null;
      this.epubFile = undefined;
      this.imgFile = undefined;
      this.onSearchChange();
    } catch (error) {
      console.error('Error al actualizar libro:', error);
    }
  }

  cancelEdit() {
    this.editingBook = null;
    this.epubFile = undefined;
    this.imgFile = undefined;
  }

  confirmDeleteBook(book: Book) {
    this.bookToDelete = book;
  }

  async deleteBook() {
    if (!this.bookToDelete?.isbn) return;

    try {
      await this.booksService.deleteBook(this.bookToDelete.isbn);
      this.bookToDelete = null;
      this.onSearchChange();
    } catch (error) {
      console.error('Error al eliminar libro:', error);
    }
  }

  cancelDelete() {
    this.bookToDelete = null;
  }
}
