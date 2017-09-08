
library(plotly)
library(reshape2)
library(RPostgreSQL)

tsbeg <- "2017/09/01 00:00:00"
tsend <- "2017/09/08 00:00:00"
DATA <- retrieveDB.SMN(stations="GVE", parameters=c("tre200b0", "rre150b0"), tbeg=tsbeg, tend=tsend)
attributes(DATA$time)$tzone <- "UTC"

df <- reshape(DATA, timevar="parameter_mch", direction="wide", idvar=c("time", "nat_abbr_tx"), drop="id")

p <- plot_ly(df, width=1000, height=300) %>%
  add_trace(x = ~time, y = ~value.rre150b0, type = 'bar', name = 'Precipitation',
            marker = list(color = "blue"),
            hoverinfo = "text",
            text = ~paste(time, value.rre150b0, ' mm')) %>%
  add_trace(x = ~time, y = ~value.tre200b0, type = 'scatter', mode = 'lines', name = 'Temperature', yaxis = 'y2',
            line = list(color = "red"),
            hoverinfo = "text",
            text = ~paste(time, value.tre200b0, '°C')) %>%
  layout(title = 'Geneva Precipitation and Temperature Measurements',
         xaxis = list(title = ""),
         yaxis = list(side = 'left', title = 'Precipitation in mm', showgrid = FALSE, zeroline = FALSE),
         yaxis2 = list(side = 'right', overlaying = "y", title = 'Temperature in C', showgrid = TRUE, zeroline = FALSE))
p

