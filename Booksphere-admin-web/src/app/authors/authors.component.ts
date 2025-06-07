import { Component } from '@angular/core';
import { Author, AuthorsService } from '../services/authors.service';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { NavbarComponent } from '../navbar/navbar.component';

@Component({
  selector: 'app-authors',
  standalone: true,
  imports: [CommonModule, FormsModule,NavbarComponent],

  templateUrl: './authors.component.html',
  styleUrls: ['./authors.component.css']
})
export class AuthorsComponent {
  authors$: Observable<Author[]>;
  filteredAuthors$: Observable<Author[]>; 
  newAuthorName: string = '';
  searchTerm: string = '';  

  editingAuthor: Author | null = null;
  authorToDelete: Author | null = null;

  constructor(private authorsService: AuthorsService) {
    this.authors$ = this.authorsService.getAuthors();
    this.filteredAuthors$ = this.authors$;
  }

  onSearchChange() {
    const term = this.searchTerm.toLowerCase().trim();
    this.filteredAuthors$ = this.authors$.pipe(
      map(authors => authors.filter(author =>
        author.name?.toLowerCase().includes(term)
      ))
    );
  }

  addAuthor() {
    const name = this.newAuthorName.trim();
    if (!name) return;

    this.authorsService.addAuthor({ name }).then(() => {
      this.newAuthorName = '';
      this.onSearchChange();  
    }).catch((error: any) => {
      console.error('Error al agregar autor:', error);
    });
  }

  editAuthor(author: Author) {
    this.editingAuthor = { ...author };
  }

  updateAuthor() {
    if (!this.editingAuthor || !this.editingAuthor.uid) return;

    this.authorsService.updateAuthor(this.editingAuthor.uid, { name: this.editingAuthor.name || '' })
      .then(() => {
        this.editingAuthor = null;
        this.onSearchChange(); 
      }).catch((error: any) => {
        console.error('Error al actualizar autor:', error);
      });
  }

  cancelEdit() {
    this.editingAuthor = null;
  }

  confirmDeleteAuthor(author: Author) {
    this.authorToDelete = author;
  }

  deleteAuthor() {
    if (!this.authorToDelete || !this.authorToDelete.uid) return;

    this.authorsService.deleteAuthor(this.authorToDelete.uid)
      .then(() => {
        this.authorToDelete = null;
        this.onSearchChange(); 
      }).catch((error: any) => {
        console.error('Error al eliminar autor:', error);
      });
  }

  cancelDelete() {
    this.authorToDelete = null;
  }
}
