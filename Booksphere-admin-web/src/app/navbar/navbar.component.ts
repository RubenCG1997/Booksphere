import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Auth, signOut } from '@angular/fire/auth';
import { Router } from '@angular/router';

@Component({
  selector: 'app-navbar',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.css']
})
export class NavbarComponent {
  constructor(private auth: Auth, private router: Router) {}

  async logout() {
    const confirmLogOut = confirm('¿Estás seguro de querer cerrar sesión?');
    if(confirmLogOut){
      await signOut(this.auth);
       this.router.navigateByUrl('/login', { replaceUrl: true });
    }
  }
}
