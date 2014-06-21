NEI <- readRDS("summarySCC_PM25.rds") # reading the data into a dataframe called 'NEI' for easier access of data from the R data file provided.
  
  
data<-aggregate(NEI$Emissions, by=list(year = NEI$year), FUN=sum) # assigning the data of interest to 'data' after subsetting from the NEI dataframe .
  
png(filename = "plot1.png", width = 480, height = 480) # declaring the size of the png graph image that results from the plotting.

options(scipen=2) # introducing a penalty for displaying scientific notation of integers in the graph and making the graph more readable

# setting the color, defining x -axis and y-axis, labelling the respective axes, setting the range of the y axis..  
plot <- barplot( data$x, main = "Emissions from PM2.5 for each year(1999-2008)",ylim = c(0,8000000),ylab="Emissions from PM2.5(in tons)",xlab="Years",
    names = c("1999", "2002", "2005", "2008"),col=c("orangered", "dodgerblue4", "dodgerblue3", "forestgreen") ) 
  
text(x= plot, y = data$x, label = round(data$x ,0), pos=3)
    
dev.off()

