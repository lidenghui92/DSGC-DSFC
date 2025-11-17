library(rcompanion)
#clustering with enriched and prevalent DSEGCs
data = matrix(c(291,215,9,13,141,210,133,131,0,86,0,0,0,30,1,
                1,4,85,3,29,0,0,0,0,0,0,0,45,0,0,
                0,42,74,184,19,1,0,1,0,0,64,0,0,0,21,
                0,8,80,25,34,1,0,0,96,0,0,61,0,0,0), nrow=15)
#clustering with prevalent DSEGCs
#data = matrix(c(18,0,9,2,0,0,0,2,0,2,13,43,78,0,
#                47,0,21,114,44,86,88,91,146,219,404,0,0,0,
#                32,0,26,6,0,0,0,0,0,4,8,0,168,61,
#                58,63,199,22,0,0,0,0,1,4,10,0,49,0),nrow=14)

cramerV(data)

chi_square = sum((data - rowSums(data) * colSums(data) / sum(data))^2 / (rowSums(data) * colSums(data) / sum(data)))
df = (nrow(data) - 1) * (ncol(data) - 1)
p_value = pchisq(chi_square, df, lower.tail = FALSE)
print(p_value)