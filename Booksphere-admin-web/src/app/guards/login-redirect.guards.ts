import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { Auth } from '@angular/fire/auth';

export const loginRedirectGuard: CanActivateFn = async () => {
  const auth = inject(Auth);
  const router = inject(Router);

  return new Promise(resolve => {
    const unsub = auth.onAuthStateChanged(user => {
      unsub();
      if (user) {
        router.navigateByUrl('/home', { replaceUrl: true });
        resolve(false);
      } else {
        resolve(true);
      }
    });
  });
};
