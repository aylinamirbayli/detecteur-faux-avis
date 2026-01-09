# Détecteur de faux avis en ligne (Fake Reviews Detection)

Outil de détection automatique des **avis faux vs authentiques** à partir du texte, basé sur des techniques de **traitement du langage naturel (NLP)** et de **régression logistique** en R.

---

## Contexte et motivation

Les avis en ligne influencent fortement les décisions d'achat des consommateurs. Cependant, de nombreux avis peuvent être falsifiés, ce qui réduit la confiance des utilisateurs.

Ce projet vise à montrer comment des **méthodes statistiques et de data science** peuvent être utilisées pour **détecter automatiquement les avis faux** à partir de leur contenu textuel.

---

## Problématique

**Peut-on prédire automatiquement si un avis en ligne est faux ou authentique uniquement à partir de son texte ?**

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
- `label` : `CG` (authentique) ou `OR` (faux)  
- `text_` : contenu textuel de l'avis

Le jeu de données est équilibré (50% CG / 50% OR).

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

| Métrique | Valeur |
|----------|--------|
| Accuracy | 81.6% |
| Precision | 80.6% |
| Recall | 83.0% |
| F1-score | 81.8% |

### Optimisation du seuil

Dans l'application finale, nous utilisons un **seuil de 0.7** (au lieu de 0.5) pour :
- Réduire les faux positifs (éviter de pénaliser des avis authentiques)
- Améliorer la précision
- Offrir une flexibilité via un curseur interactif

---

## Interprétation

**Avis faux** : vocabulaire vague et générique (*maybe, however, instead*)  
**Avis authentiques** : détails concrets sur le produit (*sturdy, instructions, plastic*)

Le modèle distingue le vocabulaire générique des détails spécifiques.

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

Ce projet démontre qu'il est possible de détecter les avis frauduleux avec une précision satisfaisante (>80%) en utilisant le contenu textuel et des techniques de machine learning classiques.L'approche par régression logistique offre des résultats encourageants tout en restant simple et interprétable.

Perspectives d'amélioration: 
Pondération TF-IDF au lieu de fréquences simples
Modèles plus avancés : Random Forest, XGBoost, réseaux de neurones
Support multilingue : adaptation pour le français
Features supplémentaires : analyse de sentiment, longueur des avis, métadonnées


---

## Auteurs

**AMIRBAYLI Jeyla**  
**SEVIMLI Burak**  
**AMIRBAYLI Aylin**  

Projet d'analyse de données
