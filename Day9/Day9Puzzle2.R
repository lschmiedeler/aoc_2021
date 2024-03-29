library(raster)

input <- read.csv("Day9Input.txt", header = FALSE, colClasses = c("character"))
input <- as.data.frame(do.call(rbind, strsplit(input[,1], split = "")),
                       stringsAsFactors = FALSE)
input <- apply(input, 2, function(x) as.integer(x))
input_vector <- as.vector(t(input))
input_vector[input_vector != 9] <- 1
input_vector[input_vector == 9] <- 0
input <- matrix(input_vector, nrow = nrow(input), ncol = ncol(input))

input_raster <- raster(input)
freq_clumps <- freq(clump(input_raster, directions = 4))
freq_clumps <- sort(freq_clumps[,2][!is.na(freq_clumps[,1])])
n_clumps <- length(freq_clumps)
freq_clumps[n_clumps - 2] * freq_clumps[n_clumps - 1] * freq_clumps[n_clumps]