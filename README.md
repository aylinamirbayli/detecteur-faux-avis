# Détecteur de faux avis en ligne (Fake Reviews Detection)

Outil de détection automatique des **avis faux vs authentiques** à partir du texte, basé sur des techniques de **traitement du langage naturel (NLP)** et de **régression logistique** en R.

---

## Contexte et motivation

Les avis en ligne influencent fortement les décisions d’achat des consommateurs. Cependant, de nombreux avis publiés sur les plateformes peuvent être falsifiés (avis sponsorisés, bots, manipulation des notes), ce qui réduit la confiance des utilisateurs.

Ce projet vise à montrer comment des **méthodes statistiques et de data science** peuvent être utilisées pour **détecter automatiquement les avis faux** à partir de leur contenu textuel.

---

## Problématique

**Peut-on prédire automatiquement si un avis en ligne est faux ou authentique uniquement à partir de son texte ?**

---

## Objectifs du projet

- Construire un outil de **classification binaire** (faux / authentique)
- Appliquer des techniques de **traitement du texte (NLP)** :
  - nettoyage du texte
  - création d’une matrice documents-termes
- Implémenter un **modèle de régression logistique**
- Évaluer les performances du modèle
- Interpréter les mots les plus discriminants
- Rendre le projet **reproductible et documenté sur GitHub**
- (Optionnel) Développer une **interface Shiny** pour tester des avis en direct

---

## Données

### Source des données

Les données proviennent de **Kaggle** (Fake Reviews Dataset).

Chaque observation correspond à un avis en ligne.

### Variables principales

- `category` : catégorie du produit  
- `rating` : note associée à l’avis  
- `label` :
  - `CG` = avis authentique  
  - `OR` = avis faux  
- `text_` : texte de l’avis  

---

## Méthodologie

Le projet suit les étapes suivantes :

1. Chargement et exploration des données
2. Nettoyage du texte :
   - passage en minuscules
   - suppression de la ponctuation et des chiffres
   - suppression des stopwords
3. Vectorisation du texte :
   - création d’une matrice documents-termes (DTM)
   - suppression des termes trop rares
4. Construction de la variable cible
5. Séparation des données :
   - 80 % apprentissage
   - 20 % test
6. Modélisation par régression logistique
7. Évaluation du modèle
8. Interprétation des coefficients
9. Prédiction sur de nouveaux avis
10. (Optionnel) Interface Shiny

---

## Modèle

Le modèle utilisé est une **régression logistique**, adaptée aux problèmes de classification binaire.

- Variable cible :
  - `1` = avis faux (OR)
  - `0` = avis authentique (CG)
- Variables explicatives :
  - fréquences des mots présents dans les avis

---

## Résultats

### Performances sur l’échantillon de test

- Accuracy ≈ **81 %**
- Precision ≈ **0.81**
- Recall ≈ **0.83**
- F1-score ≈ **0.82**

Le modèle présente de bonnes performances pour distinguer les avis faux des avis authentiques.

---

## Interprétation des résultats

- Les **coefficients positifs** sont associés à des mots plutôt vagues ou génériques (ex. *maybe, however, instead*), caractéristiques des avis faux.
- Les **coefficients négatifs** correspondent à des mots plus concrets et descriptifs liés au produit (ex. *sturdy, instructions, plastic*), souvent présents dans les avis authentiques.

Le modèle distingue principalement le **vocabulaire générique** des **détails spécifiques**.

---

## Utilisation

### Exemple de prédiction

```r
texte_test <- "This product is amazing, I recommend it to everyone!!!"
predire_avis(texte_test, modele_logit, dtm2)
```

## Conclusion

Ce projet avait pour objectif de développer un outil capable de distinguer automatiquement les avis authentiques des avis faux à partir de leur contenu textuel. En combinant des techniques de traitement du langage naturel et un modèle de régression logistique, nous avons montré qu’il est possible d’obtenir des performances satisfaisantes, avec une précision et un rappel supérieurs à 80 %.

L’analyse des coefficients du modèle met en évidence des différences lexicales claires entre les avis faux, souvent plus vagues et génériques, et les avis authentiques, qui contiennent davantage de détails concrets liés au produit.  


