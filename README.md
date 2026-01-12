# Détecteur de faux avis en ligne (Fake Reviews Detection)

Outil de détection automatique des **avis faux vs authentiques** à partir du texte,
basé sur des techniques de **traitement du langage naturel (NLP)** et de
**régression logistique** en R.

---

## Contexte et motivation

Les avis en ligne influencent fortement les décisions d'achat des consommateurs.
Cependant, de nombreux avis peuvent être falsifiés, ce qui réduit la confiance
des utilisateurs.

Ce projet vise à montrer comment des **méthodes statistiques et de data science**
peuvent être utilisées pour **détecter automatiquement les avis faux** à partir
de leur contenu textuel.

---

## Problématique

**Peut-on prédire automatiquement si un avis en ligne est faux ou authentique
uniquement à partir de son texte ?**

---

## Objectifs du projet

- Construire un outil de classification binaire (faux / authentique)
- Appliquer des techniques de traitement du texte (NLP)
- Implémenter un modèle de régression logistique
- Évaluer les performances du modèle
- Développer une application Shiny interactive
- Rendre le projet reproductible et documenté

---

## Données

**Source** : Kaggle (Fake Reviews Dataset)

**Variables principales** :
- `category` : catégorie du produit  
- `rating` : note de l'avis  
- `label` :  
  - `OR` = **avis authentique (Original Review)**  
  - `CG` = **avis faux / généré (Computer Generated)**  
- `text_` : contenu textuel de l'avis  

Le jeu de données est **équilibré** (50 % OR / 50 % CG).

---

## Méthodologie

1. **Prétraitement du texte** : nettoyage, suppression des stopwords, tokenisation
2. **Vectorisation** : création d'une matrice documents-termes (DTM)
3. **Modélisation** : régression logistique
4. **Évaluation** : accuracy, precision, recall, F1-score
5. **Interprétation** : analyse des coefficients discriminants
6. **Déploiement** : application Shiny interactive

---

## Résultats

### Performances (seuil = 0.5)

| Métrique  | Valeur |
|----------|--------|
| Accuracy | 81.6 % |
| Precision | 82.7 % |
| Recall | 80.3 % |
| F1-score | 81.5 % |

Ces résultats montrent que le modèle parvient à distinguer efficacement
les avis authentiques des avis frauduleux uniquement à partir du texte.

---

### Optimisation du seuil

Dans l'application finale, nous utilisons un **seuil de 0.65** (au lieu de 0.5) afin de :

- Réduire les **faux positifs** (avis authentiques classés à tort comme faux)
- Trouver un **meilleur compromis précision / rappel**
- Permettre à l'utilisateur d'ajuster le seuil via un **curseur interactif**

Un seuil plus élevé diminue les erreurs coûteuses pour l'utilisateur, tout en
maintenant des performances globales satisfaisantes.

---

## Interprétation du modèle

Les coefficients de la régression logistique indiquent quels mots influencent la
prédiction :

- **Coefficients positifs → avis faux (CG)**  
  Certains mots concrets liés au produit (*plastic, instructions, sturdy*) peuvent
  être utilisés dans des avis générés afin de paraître crédibles.

- **Coefficients négatifs → avis authentiques (OR)**  
  Des termes plus nuancés ou discursifs (*although, instead, maybe*) apparaissent
  davantage dans des avis réellement rédigés par des utilisateurs.

Cette observation montre que la distinction entre avis vrais et faux ne repose
pas uniquement sur le caractère vague ou concret du vocabulaire, mais sur des
**combinaisons de mots** captées par le modèle.

---

## Structure du projet
```
detecteur-faux-avis/
├── data/
│   └── fake reviews dataset.csv
├── detecteur_faux_avis.Rmd     # Analyse et entraînement du modèle
├── app.R                        # Application Shiny
└── README.md
```

**Note** : Les modèles entraînés (`modele_logit.rds` et `dtm_ref.rds`) sont générés localement en exécutant le fichier `.Rmd` et ne sont pas inclus dans le repository.

---

## Installation et utilisation

### Prérequis

- R version 4.0+
- Packages : `tm`, `shiny`
```r
install.packages(c("tm", "shiny"))
```

### Étapes

1. **Cloner le repository**
```bash
git clone https://github.com/aylinamirbayili/detecteur-faux-avis.git
cd detecteur-faux-avis
```

2. **Placer les données**  
Télécharger le dataset et le placer dans `data/fake reviews dataset.csv`

3. **Entraîner le modèle**  
Ouvrir `detecteur_faux_avis.Rmd` dans RStudio et exécuter tous les chunks

4. **Lancer l'application**
```r
shiny::runApp("app.R")
```

---

## Utilisation de l'application Shiny

L'application permet de :
- Saisir un avis à analyser
- Ajuster le seuil de décision (0 à 1)
- Obtenir une prédiction avec probabilités détaillées

**Exemples d'avis à tester** :

Avis potentiellement faux :
> "This product is absolutely amazing! Best purchase ever! Everyone should buy this! Five stars!"

Avis potentiellement authentique :
> "The instructions were clear and assembly took about 30 minutes. The plastic feels sturdy but the screws could be better quality."

---

## Conclusion

Ce projet démontre qu'il est possible de détecter les avis frauduleux avec une précision satisfaisante (>80%) en utilisant le contenu textuel et des techniques de machine learning classiques. L'approche par régression logistique offre des résultats encourageants tout en restant simple et interprétable.

---

## Limites et perspectives

### Limites actuelles
- Modèle basique (régression logistique uniquement)
- Dataset en anglais uniquement
- Features limitées (fréquences de mots simples)

### Perspectives d'amélioration
- Pondération **TF-IDF** pour une meilleure représentation textuelle
- Modèles plus avancés (Random Forest, réseaux de neurones)
- Support multilingue (adaptation pour le français)
- Ajout de features (sentiment, longueur, métadonnées)

---

## Auteurs

**AMIRBAYLI Jeyla**  
**SEVIMLI Burak**  
**AMIRBAYLI Aylin**  

Projet d'analyse de données
