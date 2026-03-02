# ---------------------------------------------------------

# Melbourne Bioinformatics Training Program

# This exercise to assess your familiarity with R and git. Please follow
# the instructions on the README page and link to your repo in your application.
# If you do not link to your repo, your application will be automatically denied.

# Leave all code you used in this R script with comments as appropriate.
# Let us know if you have any questions!


# You can use the resources available on our training website for help:
# Intro to R: https://mbite.org/intro-to-r
# Version Control with Git: https://mbite.org/intro-to-git/

# ----------------------------------------------------------
# setwd
setwd("C:/Users/chang7/OneDrive/Research/PhD/Work_bioinformatics/training-program-application-2026-natalie-chang")

# Load libraries -------------------
# You may use base R or tidyverse for this exercise
install.packages("tidyverse")
library(tidyverse)

# Load data here ----------------------
# Load each file with a meaningful variable name.
metadata <- read_csv("data/GSE60450_filtered_metadata.csv")
expressiondata <- read_csv("data/GSE60450_GeneLevel_Normalized(CPM.and.TMM)_data.csv")


# Inspect the data -------------------------

# What are the dimensions of each data set? (How many rows/columns in each?)
# Keep the code here for each file.

## Expression data
dim(expressiondata) #23735 rows 14 col

## Metadata-
dim(metadata) # 12 rows 4 col

# Prepare/combine the data for plotting ------------------------
# How can you combine this data into one data.frame? shown below, need to first clean data then merge

## 1. first need to understand the data
View (expressiondata)
names(expressiondata)
View (metadata)
names(metadata)
## 2. pivot longer expression data
expressiondata_long= expressiondata %>% pivot_longer(cols= -c(`...1`, gene_symbol),
                                names_to="sample_id",
                                values_to= "expression")

### check
head(expressiondata_long)



## 3. rename metadata colname to sample_id or else we cannot merge
metadata= metadata %>%
  rename(sample_id=`...1`)
### check if it looks correct -> yes
names(metadata)
head(metadata)


## 4. merge two dataset
combine= full_join(expressiondata_long, metadata, by="sample_id")

### check this combine dataset
combine

# Plot the data --------------------------
## Plot the expression by cell type
## Can use boxplot() or geom_boxplot() in ggplot2

p= ggplot(data = combine, mapping = aes(x = immunophenotype, y = log2(expression+1))) + #log2 transformed to make it clear, add 1 because of non-infinitie outside the range
  geom_boxplot()+theme_minimal()

p 


## Save the plot
### Show code for saving the plot with ggsave() or a similar function
ggsave(
  filename = "results/results_plot_02032026.png", 
  plot = p, 
  width = 6, 
  height = 8, 
  units = "in", 
  dpi = 600
)

