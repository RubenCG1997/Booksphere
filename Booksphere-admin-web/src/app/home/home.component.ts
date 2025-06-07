import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { NavbarComponent } from "../navbar/navbar.component";

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css'],
  imports: [NavbarComponent]
})
export class HomeComponent {
  constructor(private router: Router) {}

  goTo(section: string) {
    this.router.navigate([`/${section}`]);
  }
}
