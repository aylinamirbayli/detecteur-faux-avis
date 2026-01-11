# Application Shiny - Détecteur de faux avis
# Auteur: AMIRBAYLI Jeyla, SEVIMLI Burak, AMIRBAYLI Aylin


library(shiny)
library(tm)

# =========================
# Vérification des fichiers
# =========================
path_model <- "results/modele_logit.rds"
path_dtm   <- "results/dtm_ref.rds"

if (!file.exists(path_model) || !file.exists(path_dtm)) {
  stop(
    paste0(
      "Fichiers manquants.\n",
      "Vérifie que ces fichiers existent dans ton repo :\n",
      "- ", path_model, "\n",
      "- ", path_dtm, "\n\n",
      "Structure attendue :\n",
      "results/\n  modele_logit.rds\n  dtm_ref.rds\n"
    )
  )
}

# Charger les modèles sauvegardés
modele_logit <- readRDS(path_model)
dtm_ref <- readRDS(path_dtm)

# =========================
# Fonction de prédiction (robuste)
# =========================
predire_avis <- function(texte, modele, dtm_ref, seuil = 0.85) {

  # 1) Nettoyage texte
  corp_new <- VCorpus(VectorSource(texte))
  corp_new <- tm_map(corp_new, content_transformer(tolower))
  corp_new <- tm_map(corp_new, removePunctuation)
  corp_new <- tm_map(corp_new, removeNumbers)
  corp_new <- tm_map(corp_new, removeWords, stopwords("english"))
  corp_new <- tm_map(corp_new, stripWhitespace)

  # 2) DTM du nouveau texte avec dictionnaire de référence
  dict_terms <- Terms(dtm_ref)
  dtm_new <- DocumentTermMatrix(corp_new, control = list(dictionary = dict_terms))

  # Cas texte trop court / aucun terme reconnu
  if (ncol(dtm_new) == 0) {
    return(list(
      proba_fake = NA_real_,
      prediction = "Texte trop court ou pas assez de mots utiles"
    ))
  }

  # 3) Passage en data.frame
  x_new <- as.data.frame(as.matrix(dtm_new), check.names = FALSE)

  # 4) Aligner exactement les colonnes attendues par le modèle
  missing_cols <- setdiff(dict_terms, colnames(x_new))
  if (length(missing_cols) > 0) {
    x_new[missing_cols] <- 0
  }
  x_new <- x_new[, dict_terms, drop = FALSE]

  # 5) Proba + classe
  proba_fake <- predict(modele, newdata = x_new, type = "response")
  proba_fake <- as.numeric(proba_fake)

  classe <- ifelse(proba_fake >= seuil, 1, 0)

  list(
    proba_fake = proba_fake,
    prediction = ifelse(classe == 1, "FAUX (OR)", "VRAI (CG)")
  )
}

# ============================================
# UI - Interface utilisateur
# =========================================
ui <- fluidPage(

  titlePanel("Détecteur de faux avis en ligne"),

  tags$head(
    tags$style(HTML("
      .main-panel {
        background-color: #f8f9fa;
        padding: 20px;
        border-radius: 10px;
      }
      .result-box {
        padding: 20px;
        border-radius: 10px;
        margin-top: 20px;
        font-size: 18px;
        font-weight: bold;
      }
      .fake {
        background-color: #f8d7da;
        color: #721c24;
        border: 2px solid #f5c6cb;
      }
      .real {
        background-color: #d4edda;
        color: #155724;
        border: 2px solid #c3e6cb;
      }
    "))
  ),

  sidebarLayout(

    sidebarPanel(
      h3("Entrer un avis à analyser"),

      textAreaInput(
        inputId = "texte_avis",
        label = "Texte de l'avis :",
        value = "",
        placeholder = "Exemple: This product is amazing! I highly recommend it to everyone...",
        rows = 8,
        width = "100%"
      ),

      sliderInput(
        inputId = "seuil",
        label = "Seuil de décision :",
        min = 0,
        max = 1,
        value = 0.85,
        step = 0.05
      ),

      actionButton(
        inputId = "analyser",
        label = "Analyser l'avis",
        class = "btn-primary btn-lg",
        width = "100%"
      ),

      hr(),

      h4("À propos"),
      p("Cette application utilise un modèle de régression logistique entraîné sur des avis pour détecter les avis frauduleux.")
    ),

    mainPanel(
      class = "main-panel",

      h3("Résultat de l'analyse"),
      uiOutput("resultat_prediction"),

      br(),

      h4("Détails de la prédiction"),
      verbatimTextOutput("details"),

      hr(),

      h4("Exemples d'avis à tester"),
      wellPanel(
        p(strong("Exemple d'avis potentiellement faux :")),
        p(em("\"This product is absolutely amazing! Best purchase ever! Everyone should buy this! Five stars!\"")),
        br(),
        p(strong("Exemple d'avis potentiellement authentique :")),
        p(em("\"The instructions were clear and assembly took about 30 minutes. The plastic feels sturdy but the screws could be better quality.\""))
      )
    )
  )
)

# ============================================
# SERVER - Logique de l'application
# ============================================
server <- function(input, output, session) {

  resultat <- eventReactive(input$analyser, {

    texte <- trimws(input$texte_avis)
    if (nchar(texte) == 0) {
      return(list(erreur = TRUE, message = "Veuillez entrer un avis à analyser."))
    }

    tryCatch({
      pred <- predire_avis(texte, modele_logit, dtm_ref, seuil = input$seuil)

      if (is.na(pred$proba_fake)) {
        return(list(erreur = TRUE, message = "Texte trop court ou pas assez de mots utiles pour prédire."))
      }

      list(
        erreur = FALSE,
        prediction = pred$prediction,
        proba = pred$proba_fake
      )
    }, error = function(e) {
      list(erreur = TRUE, message = paste("Erreur lors de l'analyse :", e$message))
    })
  })

  output$resultat_prediction <- renderUI({

    res <- resultat()

    if (isTRUE(res$erreur)) {
      div(
        class = "result-box",
        style = "background-color: #fff3cd; color: #856404; border: 2px solid #ffeaa7;",
        res$message
      )
    } else {

      classe <- ifelse(res$prediction == "FAUX (OR)", "fake", "real")

      div(
        class = paste("result-box", classe),
        h3(paste("Prédiction :", res$prediction))
      )
    }
  })

  output$details <- renderText({

    res <- resultat()

    if (isTRUE(res$erreur)) {
      ""
    } else {
      proba_pct <- round(res$proba * 100, 1)

      paste0(
        "Probabilité d'être un avis FAUX : ", proba_pct, "%\n",
        "Probabilité d'être un avis VRAI : ", round(100 - proba_pct, 1), "%\n\n",
        "Seuil utilisé : ", input$seuil, "\n"
      )
    }
  })
}

# ============================================
# Lancer l'application
# ============================================
shinyApp(ui = ui, server = server)
