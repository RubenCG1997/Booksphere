// app.routes.ts
import { Routes } from '@angular/router';
import { LoginComponent } from './login/login.component';
import { HomeComponent } from './home/home.component';
import { AuthorsComponent } from './authors/authors.component';

import { authGuard } from './guards/auth.guards';
import { loginRedirectGuard } from './guards/login-redirect.guards';
import { PublishersComponent } from './publisher/publisher.component';
import { BooksComponent } from './books/books.component';


export const routes: Routes = [
  { path: '', redirectTo: 'login', pathMatch: 'full' },
  { path: 'login', component: LoginComponent, canActivate: [loginRedirectGuard] },
  { path: 'home', component: HomeComponent, canActivate: [authGuard] },
  { path: 'authors', component: AuthorsComponent, canActivate: [authGuard] },
  { path: 'publisher', component: PublishersComponent, canActivate: [authGuard] },
  { path: 'books', component: BooksComponent, canActivate: [authGuard] },
  
];
