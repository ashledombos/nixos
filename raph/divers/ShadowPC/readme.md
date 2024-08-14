1. Télécharger tous les fichiers dans un répertoire dédié à Shadow.
2. Télécharger l’AppImage du client ShadowPC dans le même répertoire
3. Modifier le .desktop pour qu’il trouve le fichier shell.nix, le fichier AppImage, et une des icônes (chemins absolus)
4. copier le .desktop dans ~/.local/share/applications/
5. Recharger la base applicative avec update-desktop-database ~/.local/share/applications/
