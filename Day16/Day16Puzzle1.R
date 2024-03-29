library(readr)
library(BMS)

input <- read_file("Day16Input.txt") 
binary <- do.call(c, lapply(strsplit(input, split = "")[[1]], function(x) {
  hex2bin(x)
}))

version_sum <<- 0
decode <- function(binary) {
  packet_version <- binary[1:3]
  packet_version_dec <- strtoi(paste(packet_version, collapse = ""), base = 2)
  version_sum <<- version_sum + packet_version_dec

  packet_type_id <- binary[4:6]
  packet_type_id_dec <- strtoi(paste(packet_type_id, collapse = ""), base = 2)

  # if packet represents a literal value
  if (packet_type_id_dec == 4) { 
    i <- 0
    more <- TRUE
    literal <- c()
    while (more) {
      group <- binary[(7 + i):(7 + i + 4)]
      if (group[1] == 0) {
        more <- FALSE
      }
      literal <- append(literal, group[2:5])
      i <- i + 5
    }
    literal_dec <- strtoi(paste(literal, collapse = ""), base = 2)

    if ((6 + i) < length(binary)) {
      return(6 + i)
    }
    else {
      return(length(binary))
    }
  }
  
  # if packet represents an operator
  if (packet_type_id_dec != 4) {
    length_type_id <- binary[7]
    if (length_type_id == 0) {
      total_length <- binary[8:22] # total length = next 15 bits
      total_length_dec <- strtoi(paste(total_length, collapse = ""), base = 2)

      start <- 0
      length <- 0
      while (start < total_length_dec) {
        length <- decode(binary[(23 + start):(23 + total_length_dec - 1)])
        start <- start + length
      }
      return(22 + total_length_dec)
    }
    if (length_type_id == 1) {
      num_sub_packets <- binary[8:18] # number of sub-packets = next 11 bits
      num_sub_packets_dec <- strtoi(paste(num_sub_packets, collapse = ""), base = 2)

      start <- 0
      length <- 0
      for (i in 1:num_sub_packets_dec) {
        length <- decode(binary[(19 + start):length(binary)])
        start <- start + length
      }
      return(18 + start)
    }
  }
}

return_val <- decode(binary)
version_sum