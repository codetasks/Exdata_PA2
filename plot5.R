# Reading the data into dataframes called 'NEI' and 'SCC' respectively, for easier access of data from the R data files provided.
NEI <- readRDS("summarySCC_PM25.rds")

## Subsetting to find the emissions from Motor Vehicles , from the 'NEI'.
emissions_data <- NEI[(NEI$fips=="24510") & (NEI$type=="ON-ROAD"),]

# Using agrregate() to group the emissions data by year
data_by_type_year <- aggregate(Emissions ~ year, data=emissions_data, FUN=sum)

#Rounding the emission values to make it easy to read and display in the plot.
rounded_emissions <- round (data_by_type_year$Emissions,0)

library(ggplot2)

# declaring the size of the graph that results from the plotting
png(filename = "plot5.png", width = 360, height = 720)

# Setting a penalty to prevent scientific notation from being used when displaying numerical values
options(scipen=2) 

#plotting using 'ggplot2'
p<- ggplot(data_by_type_year, aes(x=factor(year), y=Emissions, fill =year, colour= year )) +
    geom_bar(stat="identity") +      xlab("Year") +
    ylab("PM2.5 emissions") +
    ggtitle("Emissions in Baltimore from motor vehicles by year")

p1 <- p + geom_text(aes(label= rounded_emissions), vjust = -0.25)

plot<- p1 + theme(legend.position = "none")

print(plot)

dev.off()


