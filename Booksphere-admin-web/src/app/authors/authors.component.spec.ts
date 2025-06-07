import { Component, OnInit } from '@angular/core';
import { Observable } from 'rxjs';
import { Author, AuthorsService } from '../services/authors.service';

@Component({
  selector: 'app-authors',
  templateUrl: './authors.component.html',
  styleUrls: ['./authors.component.css']
})
export class AuthorsComponent implements OnInit {
  authors$!: Observable<Author[]>;

  constructor(private authorsService: AuthorsService) {}

  ngOnInit(): void {
    this.authors$ = this.authorsService.getAuthors();
  }
}
