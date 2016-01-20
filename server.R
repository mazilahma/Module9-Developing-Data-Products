library(ggplot2)
library(data.table)

function(input, output) {
  dt <- read.csv("Denggi.csv")
  
  output$data_table <- renderTable({
      dat <- as.data.table(dt)
      dyear <- as.character(input$datayear)
      
      if (dyear == "2012"){ 
        # Return first 20 rows
        dat <- dat[dat$Year =="2012"]
        head(dat, 20)}
      else if (dyear == "2013"){
        dat <- dat[dat$Year =="2013"]
        head(dat, 20)}
      else if (dyear == "2014"){
        dat <- dat[dat$Year =="2014"]
        head(dat, 20)}
      else{
        dat <- dat[dat$Year =="2015"]
        head(dat, 20)}
    })
    
    output$data_plot <- renderPlot({
      dat <- as.data.table(dt)
      dgraf <- as.character(input$graf1)
      
      if (dgraf == "By Year"){ 
        dat.by.year <- dat[,sum(Total_Cases),by=Year]
        names(dat.by.year) <- c('Year','Total_Cases')
        graf1 <- barplot(dat.by.year$Total_Cases,names.arg=dat.by.year$Year, main="Total Dengue Cases from 2012 to 2015", xlab="Year", ylab="Total Cases", ylim=c(0,250000),col="blue")
        text(x = graf1, y = dat.by.year$Total_Cases, label = dat.by.year$Total_Cases, pos = 3, cex = 0.8, col = "red")
      }
      else if (dgraf == "Top 10 States"){
        #data by state - top 10 state
        dat.by.state <- dat[,sum(Total_Cases),by=State]
        names(dat.by.state) <- c('State','Total_Cases')
        dat.top.10 <-  head(dat.by.state[order(dat.by.state$Total_Cases, decreasing = TRUE)], 10)
        
        graf2 <- barplot(dat.top.10$Total_Cases,names.arg=dat.top.10$State, main="Top 10 Dengue Cases By States", xlab="State", ylab="Total Cases", ylim=c(0,250000),col="red")
        ## Add text at top of bars
        text(x = graf2, y = dat.top.10$Total_Cases, label = dat.top.10$Total_Cases, pos = 3, cex = 0.8, col = "red")
      }
      else {
        dat.by.state <- dat[,sum(Total_Cases),by=Year]
        dat.state<-dat[dat$State=="Perlis" | dat$State=="Sarawak" | dat$State=="Terengganu" |dat$State=="Johor"]
        dat.state.count <- dat.state[,sum(Total_Cases),by="Year,State"]
        names(dat.state.count) <- c('year','state','total')
        
        ggplot(data=dat.state.count, aes(x=factor(year), y=total, fill=state))+geom_bar(stat="identity",position="dodge")+labs(title="Comparison of Dengue Cases in 4 States", x="Year",y="Total Cases", fill="State")+theme_bw()
        
        }
    })
}