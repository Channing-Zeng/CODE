### This script implements the oviposition analysis presented in Vasconcellos et al. (2014)
### We model daily oviposition counts from Oncopeltus females using a zero-inflated Poisson (ZIP) generalised linear model (GLM)  
## Copyleft (or the one to blame): Carvalho, LMF (2014)
## last updated: 09/11/2014
ovi <- data.frame(read.table("data/oncopeltus_oviposition.csv", header = TRUE))
ovi$STATUS <- factor(ovi$STATUS)
library(pscl); library(ggplot2)
m <- zeroinfl(COUNT~DAY+STATUS, data = ovi)
p <- predict(m)
se.p <- sqrt(mean((ovi$COUNT-p)^2))/sqrt(length(p))
###
conf.band <- function(x, sd, alpha){
  lwr = x - qnorm(alpha/2)*sd
  upr = x + qnorm(alpha/2)*sd  
  return(data.frame(lwr, upr))
}

bands <- conf.band(p,se.p,.05)
bigdt <- data.frame(ovi, p, bands)
bigdt$Infection_status <- factor(ifelse(bigdt$STATUS==0,1,0),
                                  labels = c("Infected", "Uninfected"))# monstruous trick to fool ggplot
#
pdf(file = "figs/oviposition.pdf")
ggplot(bigdt, aes(x = DAY, y = p)) +
  ggtitle("Oviposition versus infection status") + 
  geom_ribbon(aes(ymin = lwr, ymax = upr, fill =  as.factor(ifelse(STATUS==0, 1, 0))), alpha = 0.2) +
  scale_x_continuous("Time (days)", expand = c(0, 0)) +
  scale_y_continuous("Eggs per female", expand = c(0, 0)) +
  guides(fill = FALSE)+
  geom_line(aes(colour = Infection_status), size = 1)+
  labs(fill="Infection status") +
  theme_bw() +
  theme(axis.text = element_text(size = 16, face = "bold"),
        plot.title = element_text(size = 18, face = "bold"),
        legend.text = element_text(size = 15),
        axis.title = element_text(size = 18, face = "bold"))
dev.off()