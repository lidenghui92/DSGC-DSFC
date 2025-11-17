library(ggplot2)
library(ggtern)
library(readxl)
# read table
data <- read_excel("Fig1e.Pfam_homologs.xlsx",sheet="Sheet1")

data$TS_Nf <- as.numeric(data$TS_Nf)
data$OM_Nf <- as.numeric(data$OM_Nf)
data$DS_Nf <- as.numeric(data$DS_Nf)

# normalization
data$TS_Nf_norm <- data$TS_Nf / (data$TS_Nf + data$OM_Nf + data$DS_Nf)
data$OM_Nf_norm <- data$OM_Nf / (data$TS_Nf + data$OM_Nf + data$DS_Nf)
data$DS_Nf_norm <- data$DS_Nf / (data$TS_Nf + data$OM_Nf + data$DS_Nf)

data$point_color <- ifelse(
  data$DS_Nf_norm > data$OM_Nf_norm & data$DS_Nf_norm > data$TS_Nf_norm, 
  "blue", "gray"
)

# plot
ggtern(data, aes(x = OM_Nf_norm, y = DS_Nf_norm, z = TS_Nf_norm)) +
  geom_point(aes(color=point_color),size = 0.3) + 
  scale_color_identity()+
  labs(title = "Ternary Plot with Heatmap",
       x = "OM_Nf",
       y = "DS_Nf",
       z = "TS_Nf") +
  theme_minimal() +
  theme(legend.position = "right")

