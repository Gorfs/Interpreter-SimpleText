
# SimpleText - Un interpréteur pour l'édition de texte en HTML

## Informations du Projet
- **Cours:** Grammaires et Analyse Syntaxique (GA6)
- **Université:** Université Paris Cité - UFR d'Informatique 
- **Formation:** Licence Informatique Générale
- **Année:** 2024-2025
- **Date limite:** 17 mai 2025 à 23h59 (etendu au 20 mai)

## Auteurs
- **Archie Beales** (22201677)
- **Cheze Remi** (22207793)

## Description du Projet

Ce projet implémente un interpréteur pour un langage de mise en forme de texte appelé SimpleText (inspiré de Markdown et LaTeX). L'analyseur lexical et syntaxique est capable de lire des documents au format SimpleText et de produire un document HTML équivalent.

## Fonctionnalités Implémentées

### Étape 1 : Version Basique
- Titres (préfixés par `#`)
- Sous-titres (préfixés par `##`)
- Paragraphes de texte
- Listes à puces (avec `\item`)
- Mise en forme du texte:
  - Texte en italique (`*texte*`)
  - Texte en gras (`**texte**`)
  - Liens hypertexte (`[texte](url)`)

### Étape 2 : Extensions
- Meilleure détection des paragraphes (saut de ligne flexible)
- Texte en couleur (`\color{code_couleur}{texte}`)
- Items imbriqués (avec accolades)
- Combinaison de mise en forme (gras, italique, liens, couleurs)

### Étape 3 : Macros
- Définition de macros (`\define{\nom}{contenu}`)
- Structure de document avec `\begindocument` et `\enddocument`
- Gestion d'erreurs pour les macros

### Étape 4 : Macros
- corps conditions avec (`\boolean{\macro}{true}`)

## Comment Compiler et Exécuter

```bash
# Compiler le projet
dune build

# Exécuter sur un fichier SimpleText
dune exec -- ./main.exe < exemples/exemple1.stex > output.html

# Ouvrir le résultat dans un navigateur
open output.html
```

## Structure du Dépôt

- `ast.ml`: Définition de l'arbre de syntaxe abstraite
- `lexer.mll`: Analyseur lexical (ocamllex)
- `parser.mly`: Analyseur syntaxique (menhir)
- `main.ml`: Conversion de l'AST en HTML
- `macros.ml`: Gestion des macros
- `exemples/`: Fichiers d'exemples SimpleText

## Notes d'Implémentation

Pour les listes imbriquées, nous avons choisi de permettre un espace optionnel entre `\item` et `{`, cette flexibilité n'étant pas précisée dans le sujet initial.


## Contact
Veuillez nous contactez aux mail suivant:
- archie.beales@gmail.com
- remi.cheze@etu.u-paris.fr