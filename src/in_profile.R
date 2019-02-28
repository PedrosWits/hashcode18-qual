suppressWarnings(suppressMessages(library(tidyverse)))

args <- commandArgs(TRUE)

filename = "in/b_should_be_easy.in"

in_file = args[1]
out_folder = args[2]
out_file = paste(c(out_folder, strsplit(in_file, split = "\\.")[[1]][1]))

# ================================================
# CHANGE THIS
# ================================================
param_names = c('R', 'C', 'F', 'N', 'B', 'T')
# ================================================
# ================================================

params = read_table2(in_file, # use filename in RStudio
                     n_max = 1,
                     col_names = param_names,
                     col_types = cols())

# ================================================
# CHANGE THIS
# ================================================
columns = c('row_s', 'col_s', 'row_f', 'col_f', 't_s', 't_f')
# ================================================
# ================================================

df = read_table2(in_file, # use filename in RStudio
                 skip = 1,
                 col_names = columns,
                 col_types = cols())


# ================================================
# CHANGE THIS
# ================================================
preprocess = function(df) {
  newdf = df %>%
    mutate(distance = abs(row_s - row_f) + abs(col_s - col_f)) %>%
    mutate(tdiff = t_f - t_s) %>%
    mutate(tmargin = abs(tdiff - distance)) %>%
    mutate(latest = t_s + tmargin)
  
  return(newdf)
}
# ================================================
# ================================================

# ================================================
# CHANGE THIS
# ================================================
count_max_score = function(df, bonus) {
  mscore = df %>%
    mutate(score = distance + bonus) %>%
    summarise(mscore = sum(distance + bonus)) %>%
    pull(mscore)

  return(mscore)
}
# ================================================
# ================================================

df = preprocess(df)

cat(paste("Max score: ", prettyNum(count_max_score(df, params$B), big.mark = ","), "\n"))

## Images

# ================================================
# CHANGE THIS
# ================================================

df %>%
  select(row_s, col_s) %>%
  ggplot() +
  geom_point(aes(x = row_s, y = col_s), color = "red") +
  xlim(0,params$R) +
  ylim(0,params$C)

image_file = paste(out_file, "_starting", sep = "")
ggsave(image_file, device = "png")


df %>%
  select(row_f, col_f) %>%
  ggplot() +
  geom_point(aes(x = row_f, y = col_f), color = "blue") +
  xlim(0,params$R) +
  ylim(0,params$C)

image_file = paste(out_file, "_final", sep = "")
ggsave(image_file, device = "png")