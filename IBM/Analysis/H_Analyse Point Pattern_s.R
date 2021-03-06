analyse_ppp <- function(scenario_run, file_path){
  par(mfrow=c(1,3))
  #Mean and sd's of the runs
  ##densities <- tibble(scenario=factor(), mean=numeric(0), sd=numeric(0))
  #Value of Ripley's K at different r (0, 2, 5, 10, 20, 30 m)
  RKs <- tibble(file_path=factor(), scenario=factor(), '2'=numeric(0), '5'=numeric(0),
                '10'=numeric(0),'15'=numeric(0), '20'=numeric(0), '30'=numeric(0), '40'=numeric(0))
  
  #mean, sd and value of mark correlation function
  MCs <- tibble(scenario=factor(),'0'=numeric(0), '2'=numeric(0),'4'=numeric(0), '6'=numeric(0),
                '8'=numeric(0),'10'=numeric(0), '12'=numeric(0),'14'=numeric(0))
  
  #read output files from current scenario
  Output_files <- list.files(path=file_path, pattern=sprintf('Output %s *', scenario_run))
  
  for (file_title in Output_files){
    #print(file_title)
    title_full = paste(file_path, file_title, sep="/")
    data = read.table(title_full, header=T)
    X<-data$x
    Y<- (94*0.5-data$y)
    day<-data$day
    points <- ppp(X, Y, window=raster, marks=as.factor(day))
    unitname(points) <- c('metres', 'metres')
    #plot(points, use.marks=F)
    
    #Densities#
    ###########
    #lambda<-summary(points)$intensity
    #plot(points, cex=0.5, chars=16, cols=colfunc(31),leg.side = "left", main="Day number", legend=T)
    #DensityVisualisation <- density(points, sigma = 2)
    # plot(DensityVisualisation, main="")
    # plot(points, add = TRUE, use.marks = FALSE, cex = 0.2)
    # contour(DensityVisualisation,add=TRUE, axes=FALSE)
    # persp(DensityVisualisation, visible=TRUE, shade = 0.3, expand=10,
    #       main=" ", zlab="Density nests",cex=10)
    #densities <- add_row(densities, scenario=scenario_run, mean=mean(DensityVisualisation),
                         #sd=sd(DensityVisualisation))
    #Ripley's K#
    ############
    # RipleyK<-Kest(points, rmax=40)
    # plot(RipleyK, main="Ripley's K")
    RipleyK30 <- as.data.frame(Kest(points, r=c(0,2,5,10,15,20,30,40)))
    values = RipleyK30$iso
    # el_list <- list()
    # for (i in RipleyK30$iso){el_list = c(i, el_list)}
    # el_list <- rev(el_list)
    RKs <- add_row(RKs, scenario=scenario_run, file_path=file_title, '2'=values[2], '5'=values[3],
                   '10'=values[4],'15'=values[5],'20'=values[6], '30'=values[7], '40'=values[8])
    # rbind(RKs, append('random', el_list))
    
    #Mark correlation#
    #################
    # EDay = envelope(points,markcorr,nsim=10,rank=1)
    # plot(EDay)
    MC_df = as.data.frame(markcorr(points, r=c(0,2,4,6,8,10,12,14)))
    values = MC_df$iso
    #MC_df
    # el_list <- list()
    # for (i in MC_df$iso){el_list = c(i, el_list)}
    # el_list <- rev(el_list)
    MCs <- add_row(MCs, scenario=scenario_run, '0' = values[1],
                   '2'=values[2], '4'=values[3], '6'=values[4], '8'=values[5], '10'=values[6],
                   '12'=values[7],'14'=values[8])
    # rbind(MCs, append(list('random', mean(MC_df$iso), sd(MC_df$iso)), el_list))
  }
  #print(densities)
  return(list(RKs, MCs))
}