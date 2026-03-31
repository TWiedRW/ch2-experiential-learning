library(shiny)
library(dplyr)
library(tidyr)
library(stringr)
library(glue)
library(DT)

# Data
responses <- read.csv("../data/student-responses.csv", stringsAsFactors = FALSE)
questions <- sort(names(responses)[5:ncol(responses)])
id <- sort(unique(responses$id))

# Coding
file_path <- "response-codings.csv"
code_sep <- " || "

normalize_codes <- function(x) {
  if (length(x) == 0 || all(is.na(x))) {
    return(character(0))
  }

  split_codes <- strsplit(as.character(x), code_sep, fixed = TRUE)
  flat_codes <- unlist(split_codes, use.names = FALSE)
  flat_codes <- str_trim(flat_codes)
  unique(flat_codes[nzchar(flat_codes) & !is.na(flat_codes)])
}

if (file.exists(file_path)) {
  codings <- read.csv(file_path, stringsAsFactors = FALSE)

  if (!"coding" %in% names(codings)) {
    codings$coding <- ""
  }

  codings <- codings |>
    select(id, question, coding)

  codings <- expand_grid(
    id = sort(unique(responses$id)),
    question = questions
  ) |>
    left_join(codings, by = c("id", "question")) |>
    mutate(coding = if_else(is.na(coding), "", coding))
} else {
  codings <- expand_grid(
    id = sort(unique(responses$id)),
    question = questions
  ) |>
    mutate(coding = "")

  write.csv(codings, file_path, row.names = FALSE)
}


# UI
ui <- fluidPage(

    # Application title
    titlePanel("Student Coding Application"),
    sidebarLayout(
      sidebarPanel(
        selectInput('student', 'Student', choices = id),
        textInput('newOption', 'Enter code'),
        checkboxGroupInput('oldOptions', 'Select from existing list', choices = NULL),
        fluidRow(
          column(
            width = 12,
            actionButton("submit", "Submit coding", width = "100%")
          )
        ),
        fluidRow(
          column(
            width = 6,
            actionButton("prevStudent", "Previous\nStudent", width = "100%")
          ),
          column(
            width = 6,
            actionButton("nextStudent", "Next\nStudent", width = "100%")
          )
        ),

        fluidRow(
          column(
            width = 6,
            actionButton("prevQuestion", "Previous\nQuestion", width = "100%")
          ),
          column(
            width = 6,
            actionButton("nextQuestion", "Next\nquestion", width = "100%")
          )
        ),
        uiOutput('placement')
      ),
      mainPanel(
        uiOutput('question'),
        textOutput('filtered_table'),
        div(style = "margin-top: 16px;"),
        DTOutput('codingOutput')
      )
    )

)

# Server
server <- function(input, output, session) {

  pos_student  <- reactiveVal(1)
  pos_question <- reactiveVal(1)
  codings_rv <- reactiveVal(codings)

  get_current_student <- reactive({
    id[pos_student()]
  })

  get_current_question <- reactive({
    questions[pos_question()]
  })

  get_current_codes <- reactive({
    codings_rv() |>
      filter(
        id == get_current_student(),
        question == get_current_question()
      ) |>
      pull(coding) |>
      normalize_codes()
  })

  get_old_options_for_question <- reactive({
    codings_rv() |>
      filter(question == get_current_question()) |>
      pull(coding) |>
      normalize_codes() |>
      sort()
  })

  observe({
    options <- get_old_options_for_question()
    selected <- get_current_codes()

    updateCheckboxGroupInput(
      session,
      inputId = "oldOptions",
      choices = options,
      selected = selected
    )
    updateTextInput(session, "newOption", value = "")
  })

  save_current_coding <- function() {
    new_code <- str_trim(input$newOption)
    selected_old <- if (is.null(input$oldOptions)) character(0) else input$oldOptions

    combined_codes <- unique(c(selected_old, if (new_code == "") character(0) else new_code))
    combined_string <- paste(combined_codes, collapse = code_sep)

    updated <- codings_rv() |>
      mutate(
        coding = if_else(
          id == get_current_student() & question == get_current_question(),
          combined_string,
          coding
        )
      )

    codings_rv(updated)
    write.csv(updated, file_path, row.names = FALSE)
  }

  observeEvent(input$prevQuestion, {
    if (pos_question() > 1) {
      pos_question(pos_question() - 1)
    }
  })

  observeEvent(input$nextQuestion, {
    if (pos_question() < length(questions)) {
      pos_question(pos_question() + 1)
    }
  })

  observeEvent(input$prevStudent, {
    save_current_coding()

    if (pos_student() > 1) {
      pos_student(pos_student() - 1)
      updateSelectInput(inputId = 'student', selected = id[pos_student()])
    }
  })

  observeEvent(input$nextStudent, {
    save_current_coding()

    if (pos_student() < length(id)) {
      pos_student(pos_student() + 1)
      updateSelectInput(inputId = 'student', selected = id[pos_student()])
    }
  })

  observeEvent(input$student, {
    new_index <- which(id == input$student)
    if (length(new_index) == 1) {
      pos_student(new_index)
    }
  })

  output$placement <- renderUI({
    glue(
      "Student {pos_student()} / {length(id)} | Question {pos_question()} / {length(questions)}"
    )
  })

  output$filtered_table <- renderText({
    current_student <- get_current_student()
    current_question <- get_current_question()

    response_value <- responses |>
      filter(id == current_student) |>
      slice(1) |>
      pull(current_question)

    as.character(response_value)
  })

  output$question <- renderUI({
    h4(str_replace_all(get_current_question(), '\\.' , ' '))
  })

  observeEvent(input$submit, {
    save_current_coding()
  })

  output$codingOutput <- renderDT({
    current_question <- get_current_question()
    current_pos <- pos_student()
    window_pos <- sort(unique(c(current_pos - 1, current_pos, current_pos + 1)))
    window_pos <- window_pos[window_pos >= 1 & window_pos <= length(id)]
    window_ids <- id[window_pos]

    response_tbl <- responses |>
      select(id, response = all_of(current_question)) |>
      filter(id %in% window_ids)

    coding_tbl <- codings_rv() |>
      filter(question == current_question) |>
      transmute(id, codings = coding) |>
      filter(id %in% window_ids)

    result_tbl <- response_tbl |>
      left_join(coding_tbl, by = "id") |>
      mutate(codings = if_else(is.na(codings), "", codings)) |>
      mutate(row_order = match(id, window_ids)) |>
      arrange(row_order) |>
      select(-row_order)

    datatable(
      result_tbl,
      rownames = FALSE,
      filter = "top",
      options = list(
        pageLength = 3,
        autoWidth = TRUE,
        stateSave = TRUE
      )
    )
  })

}

# Run the application
shinyApp(ui = ui, server = server)
