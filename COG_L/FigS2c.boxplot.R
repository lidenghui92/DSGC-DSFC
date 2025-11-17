library(ggplot2)
library(ggpubr)
dat <- read.table("FigS2c.MAG_COG-L_stat.txt", header = TRUE, sep = "\t")

count_mag <- with(dat, table(Phylumn, Dataset))
ord <- order(count_mag[, 2], decreasing = TRUE)
count_mag <- count_mag[ord, ]
write.table(count_mag, file = "FigS2c.HQ-MAGs_by_phylum.txt", sep = "\t", quote = FALSE)

min_per_phylum <- apply(count_mag, 1, min)
keep_phy <- names(min_per_phylum)[min_per_phylum > 20]
keep_phy <- keep_phy[order(min_per_phylum[keep_phy], decreasing = TRUE)]

plot_df <- data.frame(Dataset = dat$Dataset, value = dat$Percentage, group = "All")
for (phy in keep_phy) {
  sub <- dat[dat$Phylumn == phy, ]
  plot_df <- rbind(plot_df, data.frame(Dataset = sub$Dataset, value = sub$Percentage, group = phy))
}
plot_df$group <- factor(plot_df$group, levels = c("All", keep_phy))

my_comp <- list(c("DSGC","TOBG"))

p <- ggplot(plot_df, aes(x = group, y = value, fill = Dataset)) +
  geom_boxplot(outlier.shape = NA, width = 0.6) +
  scale_y_continuous(limits=c(0.025,0.4),breaks=c(0.025,0.05,0.075,0.1,0.2,0.3,0.4)) + #the maximum value was 0.31, and was an outlier.
  stat_compare_means(aes(group = Dataset),label = "p.signif",label.y = 0.1)+
  labs(x = NULL, y = "Percentage") +
  theme_classic(base_size = 14) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
pdf("FigS2c.pdf",w=12,h=12)
p
dev.off()
