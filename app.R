library(shiny)

ui <- fluidPage(
  tableOutput("standings")
)

server <- function(input, output, session) {
  # Create a reactive expression
  standings <- reactive({
    
    standings_loc <- file.path(tempdir(), "cubs-dashboard", "standings.json")
    dir.create(dirname(standings_loc), recursive = T)
    download.file("https://statsapi.mlb.com/api/v1/standings/?leagueId=104", standings_loc)
    
    fromJSON(standings_loc, flatten = T)$records %>%
      filter(division.id == "205") %>%
      select(teamRecords) %>%
      unnest(teamRecords) %>%
      arrange(divisionRank) %>%
      select(Team = team.name, GB = gamesBack, W = wins, L = losses)
  })
  
  
  output$standings <- renderTable({
    standings()
  })
}

shinyApp(ui, server)