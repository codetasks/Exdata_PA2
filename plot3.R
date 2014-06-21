# Reading the data into a dataframe called 'NEI' for easier access of data from the R data file provided.
NEI <- readRDS("summarySCC_PM25.rds")

# subsetting data of interest from NEI data frame.
data <- NEI[NEI$fips=="24510",]

# Using agrregate() to group the emissions data by year and 'type' (point, nonpoint, onroad, nonroad) variable
data_by_type_year <- aggregate(Emissions ~ year + type, data=data , FUN=sum)

library(ggplot2)

# declaring the size of the png graph image that results from the plotting.
png(filename = "plot3.png", width = 720, height = 600) 

p<- ggplot(data_by_type_year, aes(x=factor(year), y=Emissions, fill=type)) +
    geom_bar(stat="identity") + facet_grid(.~type) + xlab("Year") + ylab("PM2.5 emissions") +
    ggtitle("PM2.5emissions in Baltimore-by'type'(nonroad,nonpoint,onroad,point)") 


p1 <- p + geom_text(aes(label= round(Emissions, digits= 1)), vjust =-0.25, size= 3)
plot<- p1 + theme(legend.position = "none")

print (plot)

dev.off()

