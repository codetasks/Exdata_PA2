# Reading the data into dataframes called 'NEI' and 'SCC' respectively, for easier access of data from the R data files provided.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


# Subsetting the Baltimore emissions from motor vehicle sources by year
baltimore_data <- NEI[(NEI$fips=="24510") & (NEI$type=="ON-ROAD"),]
baltimore_data_year <- aggregate(Emissions ~ year, data=baltimore_data, FUN=sum)

# Subsetting the Los Angeles emissions from motor vehicle sources by year
la_data <- NEI[(NEI$fips=="06037") & (NEI$type=="ON-ROAD"),]
la_data_year <- aggregate(Emissions ~ year, data=la_data, FUN=sum)

#processing the LA data
# storing the yearly emissions of LA in a vector
vector1 <- la_data_year$Emissions
la_relative_change <-(vector1-vector1[1])/vector1[1] # relative change of emissions from 1999 in Los Angeles(la)
la_data_year["change"] <- la_relative_change  # adding a new column of the values denoting relative change in emissions in LA from 1999 

#processing the Baltimore data
# storing the yearly emissions of Baltimore in a vector
vector2 <- baltimore_data_year$Emissions
bm_relative_change <-(vector2-vector2[1])/vector2[1]  # relative change of emissions from 1999 in baltimore(bm)
baltimore_data_year["change"] <- bm_relative_change # adding a new column of the values denoting relative change in emissions in Baltimore from 1999 

##subsetting data by county
baltimore_data_year$County <- "Baltimore City, MD" 
la_data_year$County <- "Los Angeles County, CA" 

# combining the data of both LA and Baltimore with the relative changes included
changes_emissions_both <- rbind(baltimore_data_year, la_data_year)

# plotting using ggplot2 
library(ggplot2)
# declaring the size of the graph that results from the plotting
png(filename = "plot6.png", width = 360, height = 720)

p<-ggplot(changes_emissions_both, aes(x=factor(year), y=change*100, fill=County)) +coord_cartesian(ylim = c(-100, 100)) + 
    geom_bar(stat="identity") +
    facet_grid(.~ County, scales="free") +
    ylab("Percentage change within County relative to 1999") +
    xlab("Year") +
    ggtitle("Relative % increase or decrease of Emissions within Baltimore and Los Angeles")

p1 <- p + geom_text(aes(label= round(change*100, digits= 1)), vjust =-0.25)
plot<- p1 + theme(legend.position = "none")

print (plot)
dev.off()
print (plot)

