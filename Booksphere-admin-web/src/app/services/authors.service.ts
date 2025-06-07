import { Injectable } from '@angular/core';
import {
  Firestore,
  collection,
  collectionData,
  addDoc,
  doc,
  deleteDoc,
  updateDoc,
  CollectionReference
} from '@angular/fire/firestore';
import { Observable } from 'rxjs';

export interface Author {
  uid?: string;
  name?: string;
}

@Injectable({
  providedIn: 'root',
})
export class AuthorsService {
  private authorsCollection: CollectionReference;

  constructor(private firestore: Firestore) {
    this.authorsCollection = collection(this.firestore, 'authors');
  }

  getAuthors(): Observable<Author[]> {
    return collectionData(this.authorsCollection, { idField: 'uid' }) as Observable<Author[]>;
  }

  addAuthor(author: Author) {
    return addDoc(this.authorsCollection, author).then(docRef => {
      return updateDoc(docRef, { uid: docRef.id });
    });
  }

  deleteAuthor(id: string) {
    const authorDoc = doc(this.firestore, `authors/${id}`);
    return deleteDoc(authorDoc);
  }

  updateAuthor(id: string, author: Partial<Author>) {
    const authorDoc = doc(this.firestore, `authors/${id}`);
    return updateDoc(authorDoc, author);
  }
}
