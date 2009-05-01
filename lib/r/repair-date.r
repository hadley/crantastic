source("repair.r")

df <- dbReadTable(db, "version")
df$date <- as.character(strptime(df$date, "%Y-%m-%d"))

a_ply(df, 1, update_row, table = "version")
