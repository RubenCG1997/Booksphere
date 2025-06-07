import { Injectable } from '@angular/core';
import { Firestore, collection, collectionData, doc, setDoc, updateDoc, deleteDoc } from '@angular/fire/firestore';
import { Storage, ref, uploadBytes, getDownloadURL } from '@angular/fire/storage';
import { Observable } from 'rxjs';

export interface Book {
  title: string;
  description?: string;
  genre?: string;
  date?: string;
  idAuthor?: string;
  idPublisher?: string;
  isbn: string; 
  urlEpub?: string;
  urlImg?: string;
}

@Injectable({
  providedIn: 'root'
})
export class BooksService {
  private booksCollection;

  constructor(private firestore: Firestore, private storage: Storage) {
    this.booksCollection = collection(this.firestore, 'books');
  }

  getBooks(): Observable<Book[]> {
    return collectionData(this.booksCollection, { idField: 'isbn' }) as Observable<Book[]>;
  }

  addBook(book: Book): Promise<void> {
    if (!book.isbn) {
      return Promise.reject(new Error('El libro debe tener un ISBN para usarlo como ID'));
    }
    const bookDocRef = doc(this.firestore, `books/${book.isbn}`);
    return setDoc(bookDocRef, book);
  }

  updateBook(isbn: string, book: Partial<Book>): Promise<void> {
    const bookDocRef = doc(this.firestore, `books/${isbn}`);
    return updateDoc(bookDocRef, book);
  }

  deleteBook(isbn: string): Promise<void> {
    const bookDocRef = doc(this.firestore, `books/${isbn}`);
    return deleteDoc(bookDocRef);
  }

  uploadEpubFile(file: File): Observable<string> {
    const fileRef = ref(this.storage, `epubs/${file.name}`);
    return new Observable<string>(observer => {
      uploadBytes(fileRef, file).then(() => {
        getDownloadURL(fileRef).then(url => {
          observer.next(url);
          observer.complete();
        });
      }).catch(error => observer.error(error));
    });
  }

  uploadImageFile(file: File): Observable<string> {
    const fileRef = ref(this.storage, `images/${file.name}`);
    return new Observable<string>(observer => {
      uploadBytes(fileRef, file).then(() => {
        getDownloadURL(fileRef).then(url => {
          observer.next(url);
          observer.complete();
        });
      }).catch(error => observer.error(error));
    });
  }
}
