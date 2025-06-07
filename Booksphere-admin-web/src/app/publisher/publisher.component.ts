import { Component } from '@angular/core';
import { Publisher, PublishersService } from '../services/publisher.service';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { NavbarComponent } from '../navbar/navbar.component';

@Component({
  selector: 'app-publishers',
  standalone: true,
  imports: [CommonModule, FormsModule, NavbarComponent],
  templateUrl: './publisher.component.html',
  styleUrls: ['./publisher.component.css'] 
})
export class PublishersComponent {
  publishers$: Observable<Publisher[]>;
  filteredPublishers$: Observable<Publisher[]>;
  newPublisherName: string = '';
  searchTerm: string = '';

  editingPublisher: Publisher | null = null;
  publisherToDelete: Publisher | null = null;

  constructor(private publishersService: PublishersService) {
    this.publishers$ = this.publishersService.getPublishers();
    this.filteredPublishers$ = this.publishers$;
  }

  onSearchChange() {
    const term = this.searchTerm.toLowerCase().trim();
    this.filteredPublishers$ = this.publishers$.pipe(
      map(publishers => publishers.filter(publisher =>
        publisher.name?.toLowerCase().includes(term)
      ))
    );
  }

  addPublisher() {
    const name = this.newPublisherName.trim();
    if (!name) return;

    this.publishersService.addPublisher({ name }).then(() => {
      this.newPublisherName = '';
      this.onSearchChange();
    }).catch((error: any) => {
      console.error('Error al agregar publisher:', error);
    });
  }

  editPublisher(publisher: Publisher) {
    this.editingPublisher = { ...publisher };
  }

  updatePublisher() {
    if (!this.editingPublisher || !this.editingPublisher.uid) return;

    this.publishersService.updatePublisher(this.editingPublisher.uid, { name: this.editingPublisher.name || '' })
      .then(() => {
        this.editingPublisher = null;
        this.onSearchChange();
      }).catch((error: any) => {
        console.error('Error al actualizar publisher:', error);
      });
  }

  cancelEdit() {
    this.editingPublisher = null;
  }

  confirmDeletePublisher(publisher: Publisher) {
    this.publisherToDelete = publisher;
  }

  deletePublisher() {
    if (!this.publisherToDelete || !this.publisherToDelete.uid) return;

    this.publishersService.deletePublisher(this.publisherToDelete.uid)
      .then(() => {
        this.publisherToDelete = null;
        this.onSearchChange();
      }).catch((error: any) => {
        console.error('Error al eliminar publisher:', error);
      });
  }

  cancelDelete() {
    this.publisherToDelete = null;
  }
}
