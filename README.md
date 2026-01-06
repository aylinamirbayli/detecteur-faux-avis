Détecteur de faux avis en ligne (Fake Reviews Detection)
Outil de détection automatique des avis faux vs authentiques à partir du texte, basé sur des techniques de traitement du langage naturel (NLP) et de régression logistique en R.
Contexte et motivation
Les avis en ligne jouent un rôle central dans les décisions d’achat des consommateurs. Cependant, une part importante de ces avis peut être falsifiée (avis sponsorisés, bots, manipulation de notes), ce qui nuit à la confiance des utilisateurs et à la transparence des plateformes.
L’objectif de ce projet est de montrer comment des méthodes statistiques et de data science peuvent être utilisées pour détecter automatiquement les avis suspects à partir de leur contenu textuel.
Problématique
Peut-on prédire automatiquement si un avis en ligne est faux ou authentique uniquement à partir de son texte ?
Objectifs du projet
Construire un outil de classification permettant de prédire si un avis est :
FAUX (OR)
VRAI (CG)
Utiliser des techniques de traitement du texte (NLP) :
nettoyage du texte
matrice documents-termes
Implémenter un modèle de régression logistique
Évaluer les performances du modèle (accuracy, précision, rappel, F1-score)
Interpréter les mots les plus discriminants
Rendre le projet documenté et reproductible sur GitHub
(Optionnel) Proposer une interface Shiny pour tester des avis en direct
Données
Source des données
Les données proviennent de Kaggle :
Fake Reviews Dataset
Chaque observation correspond à un avis en ligne.
Variables principales
category : catégorie du produit
rating : note associée à l’avis
label :
CG = avis authentique
OR = avis faux
text_ : texte de l’avis
Méthodologie
Le projet suit les étapes suivantes :
Chargement et exploration des données
Nettoyage du texte :
passage en minuscules
suppression de la ponctuation et des chiffres
suppression des stopwords
Vectorisation du texte :
création d’une matrice documents-termes (DTM)
suppression des termes trop rares
Construction de la variable cible
Séparation des données :
échantillon d’apprentissage (80 %)
échantillon de test (20 %)
Modélisation :
régression logistique (classification binaire)
Évaluation du modèle
Interprétation des coefficients
Création d’une fonction de prédiction
(Optionnel) Interface Shiny
Modèle
Le modèle principal utilisé est une régression logistique, adaptée aux problèmes de classification binaire.
Variable cible :
1 = avis faux (OR)
0 = avis authentique (CG)
Variables explicatives :
fréquences des mots présents dans les avis
Résultats
Performances du modèle (jeu de test)
Accuracy ≈ 81 %
Precision ≈ 0.81
Recall ≈ 0.83
F1-score ≈ 0.82
Le modèle montre une bonne capacité à distinguer les avis faux des avis authentiques.
Interprétation des résultats
Les coefficients positifs du modèle sont associés à des mots plutôt vagues ou génériques (ex. maybe, however, instead), souvent présents dans les avis faux.
Les coefficients négatifs correspondent à des mots plus concrets et descriptifs liés au produit (ex. sturdy, instructions, plastic), caractéristiques des avis authentiques.
👉 Le modèle distingue donc principalement :
vocabulaire générique vs détails spécifiques.
Utilisation
Exemple de prédiction
texte_test <- "This product is amazing, I recommend it to everyone!!!"
predire_avis(texte_test, modele_logit, dtm2)
Sortie :
probabilité que l’avis soit faux
classification finale (FAUX / VRAI)
Structure du projet
detecteur-faux-avis/
│
├── Donnees/
│   └── fake reviews dataset.csv
│
├── detecteur_faux_avis.Rmd
├── app.R (optionnel – interface Shiny)
├── README.md
Limites et perspectives
Limites
Modèle simple (régression logistique)
Sensible au vocabulaire exact
Pas de prise en compte du contexte sémantique avancé
Améliorations possibles
TF-IDF
modèles plus complexes (Random Forest, SVM)
embeddings de mots
amélioration de l’interface Shiny
Conclusion
Ce projet montre qu’il est possible de construire un outil automatisé de détection de faux avis à partir du texte seul, en combinant NLP et méthodes statistiques classiques.
Il constitue une première approche solide, pédagogique et extensible, adaptée à un niveau Master 1, tout en ouvrant la voie à des modèles plus avancés.
Auteurs
Projet réalisé dans le cadre du cours de Traitement des données / Data Science
Master 1
