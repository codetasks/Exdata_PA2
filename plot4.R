# Reading the data into dataframes called 'NEI' and 'SCC' respectively, for easier access of data from the R data files provided.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


# Subsetting the coal combustion-related sources from the dataframe 'SCC'
coal_related_sources <- grepl("Fuel Comb.*Coal", SCC$EI.Sector)
coal_sources <- SCC[coal_related_sources,]

# Subsetting to find the eemissions from coal related sources from the dataframe'NEI' based on 'coal_sources' from the 'SCC' data frame
emissions_data <- NEI[(NEI$SCC %in% coal_sources$SCC), ]

# Using agrregate() to group the emissions data by year
data_by_type_year <- aggregate(Emissions ~ year, data=emissions_data, FUN=sum)

#rounding the emission values to make it easy to read and display in the plot.
rounded_emissions <- round (data_by_type_year$Emissions,0)


library(ggplot2)

# declaring the size of the graph that results from the plotting
png(filename = "plot4.png", width = 360, height = 720)

# Setting a penalty to prevent scientific notation from being used when displaying numerical values
options(scipen=2) 

#plotting using 'ggplot2'
p<-ggplot(data_by_type_year, aes(x=factor(year), y=Emissions ,fill= year,color= year)) + 
         geom_bar(stat="identity") + xlab("Year") +
          ylab(expression("PM2.5 Emissions(Tons)")) +
         ggtitle("Emissions from coal related sources by year") 

p1 <- p + geom_text(aes(label= rounded_emissions), vjust = -0.25)

plot<- p1 + theme(legend.position = "none")

print(plot)
dev.off()
