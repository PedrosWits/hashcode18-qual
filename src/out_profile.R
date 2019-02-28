require(plyr)
suppressWarnings(suppressMessages(library(tidyverse)))

args <- commandArgs(TRUE)

filename = "in/b_should_be_easy.in"

in_file = args[1]

# ================================================
# CHANGE THIS
# ================================================
in_file_vehi = paste0(strsplit(args[1],split="\\.")[[1]][[1]],"_vehicles.out")
# ================================================
# ================================================

out_folder = args[2]
out_file = paste(c(out_folder, strsplit(in_file, split = "\\.")[[1]][1]))
out_file_vehi = paste(c(out_folder, strsplit(in_file_vehi, split = "\\.")[[1]][1]))


# ================================================
# CHANGE THIS
# ================================================
vehicle_columns = c("id",'row','column','state','number_rides','d2ride_total','bonus_rides',
            'point_contribution','d2ride','t_min_start','t_s','t_init')

rides_columns = c("row_s", "col_s", "row_f", "col_f", "t_s", "t_f", "vehicle",
                  "dt", "d", "t_margin", "latest_s", 'bonus')
# ================================================
# ================================================


vehicles = read.table(file=in_file_vehi,
                       col.names = vehicle_columns)

rides = read.table(file=in_file,
                      col.names = rides_columns)


# ================================================
# CHANGE THIS
# ================================================
rides %>%
  filter(vehicle == -1) %>%
  group_by(row_f,col_f,dt) %>%
  ggplot() + 
  geom_point(aes(x=col_f,y=row_f,color=dt)) +
  xlim(0,10000) + ylim(0,10000)
  
image_file = paste(out_file, "_failed_rides", sep = "")
ggsave(image_file, device = "png")


sr = ddply(rides,.(vehicle),summarize,tot_ridden = sum(d))
sr = sr[sr$vehicle >= 0,]
sr2 = merge(x=sr,y=vehicles,by.x="vehicle",by.y = "id")
sr2$ratio = sr2$tot_ridden/sr2$d2ride_total

ggplot(sr2,aes(x=vehicle,y=ratio,color=point_contribution))+geom_point()
image_file = paste(out_file, "_ratio_vehicle", sep = "")
ggsave(image_file, device = "png")

ggplot(sr2,aes(x=point_contribution,y=ratio))+geom_point()
image_file = paste(out_file, "_ratio_point", sep = "")
ggsave(image_file, device = "png")

ggplot(vehicles,aes(x=number_rides,y=point_contribution,color=bonus_rides)) + geom_point()
image_file = paste( out_file, "_rides_point",sep = "")
ggsave(image_file, device = "png")

ggplot(vehicles,aes(x=d2ride_total,y=point_contribution)) + geom_point()
image_file = paste( out_file, "_d2ride_point",sep = "")
ggsave(image_file, device = "png")
# ================================================
# ================================================

