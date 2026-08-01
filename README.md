# Portfolio professionnel — Azaan Shafi

Refonte complète du portfolio BTS SIO SISR en portfolio professionnel évolutif.

## Pages principales

- `index.html` : accueil
- `profil.html` : profil, formation et expériences
- `competences.html` : compétences par niveau de pratique
- `projets-pro.html` : projets professionnels
- `projets-scolaires.html` : projets académiques
- `cv.html` : CV en ligne et imprimable
- `contact.html` : contact
- `projets/` : pages détaillées

## Ajouter les coordonnées

Ouvrir `assets/js/site-config.js` et renseigner :

```js
window.PORTFOLIO_CONFIG = {
  email: "votre-adresse@exemple.fr",
  phone: "+33 ...",
  linkedin: "https://www.linkedin.com/in/...",
  github: "https://github.com/azaanshafi75"
};
```

La version actuelle n’invente aucune coordonnée absente des fichiers fournis.

## Ajouter le CV PDF

1. Déposer le fichier dans `assets/documents/cv-azaan-shafi.pdf`.
2. Dans `cv.html`, remplacer le bouton désactivé par :

```html
<a class="button button-secondary" href="assets/documents/cv-azaan-shafi.pdf" download>Télécharger le PDF</a>
```

La page `cv.html` peut déjà être imprimée ou enregistrée en PDF.

## Ajouter un PDF de projet

1. Déposer le document dans `assets/documents/`.
2. Ouvrir la page correspondante dans `projets/`.
3. Remplacer le bouton « PDF à ajouter » par un lien vers `../assets/documents/nom-du-fichier.pdf`.

## Publication GitHub Pages

Remplacer le contenu du dépôt actuel par les fichiers de ce dossier, puis exécuter :

```bash
git add .
git commit -m "Refonte du portfolio professionnel"
git push origin main
```

Dans GitHub : **Settings → Pages → Deploy from a branch → main / root**.

## Anciennes URL

Les anciennes pages `parcours.html`, `projets-e5.html`, `e6.html` et `veille.html` redirigent vers les nouvelles rubriques pour éviter les liens cassés.


## Thème visuel

Cette version utilise un thème clair premium : blanc cassé, gris bleuté et bleu profond.
