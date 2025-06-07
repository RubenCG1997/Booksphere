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

export interface Publisher {
  uid?: string;
  name?: string;
}

@Injectable({
  providedIn: 'root',
})
export class PublishersService {
  private publishersCollection: CollectionReference;

  constructor(private firestore: Firestore) {
    this.publishersCollection = collection(this.firestore, 'publisher');
  }

  getPublishers(): Observable<Publisher[]> {
    return collectionData(this.publishersCollection, { idField: 'uid' }) as Observable<Publisher[]>;
  }

  addPublisher(publisher: Publisher) {
    return addDoc(this.publishersCollection, publisher);
  }

  deletePublisher(id: string) {
    const publisherDoc = doc(this.firestore, `publisher/${id}`);
    return deleteDoc(publisherDoc);
  }

  updatePublisher(id: string, publisher: Partial<Publisher>) {
    const publisherDoc = doc(this.firestore, `publisher/${id}`);
    return updateDoc(publisherDoc, publisher);
  }
}
