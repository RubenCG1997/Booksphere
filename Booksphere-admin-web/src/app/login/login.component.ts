import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Auth, signInWithEmailAndPassword, User } from '@angular/fire/auth';
import { Router } from '@angular/router';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [FormsModule,RouterModule],
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent {
  email = '';
  password = '';

  constructor(
    private auth: Auth,
    private router: Router  
  ) {}

  async loginWithEmail() {
    try {
      const credential = await signInWithEmailAndPassword(this.auth, this.email, this.password);

      if (credential.user) {
        await this.router.navigate(['home']);
      }

      alert('Login con email exitoso!');
    } catch (error: any) {
      alert('Error en login con email: ' + error.message);
    }
  }


}
