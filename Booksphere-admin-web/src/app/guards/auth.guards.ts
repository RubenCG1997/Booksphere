import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { Auth } from '@angular/fire/auth';

export const authGuard: CanActivateFn = async () => {
  const auth = inject(Auth);
  const router = inject(Router);

  return new Promise(resolve => {
    const unsub = auth.onAuthStateChanged(user => {
      unsub();
      if (user) {
        resolve(true);
      } else {
        router.navigateByUrl('/login', { replaceUrl: true });
        resolve(false);
      }
    });
  });
};
