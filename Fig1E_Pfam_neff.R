library(ggplot2)
library(ggtern)
# read table
data <- read.table("Neff.txt",sep="\t",header = T,row.names = 1)
data$Soil_Neff <- as.numeric(data$Soil_Neff)
data$OM_Neff <- as.numeric(data$OM_Neff)
data$DSM_Neff <- as.numeric(data$DSM_Neff)

# normalization
data$Soil_Neff_norm <- data$Soil_Neff / (data$Soil_Neff + data$OM_Neff + data$DSM_Neff)
data$OM_Neff_norm <- data$OM_Neff / (data$Soil_Neff + data$OM_Neff + data$DSM_Neff)
data$DSM_Neff_norm <- data$DSM_Neff / (data$Soil_Neff + data$OM_Neff + data$DSM_Neff)

# plot
ggtern(data, aes(x = Soil_Neff_norm, y = OM_Neff_norm, z = DSM_Neff_norm)) +
  geom_point(aes(color = DSM_Neff), size = 0.3) +  
  labs(title = "Ternary Plot with Heatmap",
       x = "Soil_Neff",
       y = "OM_Neff",
       z = "DSM_Neff") +
  theme_minimal() +
  theme(legend.position = "right")