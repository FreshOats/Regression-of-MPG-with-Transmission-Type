library(ggplot2)
library(datasets)
library(plotrix)
library(dplyr)

data(mtcars)
mtcars$Transmission <- factor(mtcars$am, labels = c("Automatic", "Manual"))

#{r Exploratory1, echo = FALSE}
fit <- lm(mpg ~ Transmission, data = mtcars)

#{r Exploratory2, echo = TRUE}
summary(fit)$r.squared  ## R-squared value for model
summary(fit)$coef  ## Linear model coefficients for model

#{r Regression, echo=FALSE}
## Selecting the most influencial parameters, and changing cyl, vs, and am to 
## factor variables  
cars <- mtcars %>% select(mpg, cyl, disp, hp, drat, wt, vs, am)
cars$cyl <- factor(mtcars$cyl)
cars$vs <- factor(mtcars$vs)
cars$am <- factor(mtcars$am)

## The original linear model just looking at transmission
fit.am <- lm(mpg ~ am, data = cars)

## The linear model considering all of the new parameters
fit.all <- lm(mpg ~ ., data = cars)

## The linear model with stepwise adjustments 
fit.step <- step(fit.all, direction = "both", trace = FALSE)


#{r Step, echo=FALSE}
fit.step$call
fit.step$coefficients


#{r Rsquares, echo=FALSE} 
summary(fit.am)$adj.r.squared
summary(fit.all)$adj.r.squared
summary(fit.step)$adj.r.squared
 
#{r Exploratory, echo=FALSE}
## Exploratory Analysis, Original Model observing MPG influenced by transmission
explore <- ggplot(mtcars, aes(x=Transmission, y=mpg, fill=Transmission)) + geom_boxplot() + ggtitle("Fuel Efficiency by Transmission Type")
print(explore)

## Exploratory Analsysis, Correlations  
correlations <- round(cor(mtcars[,-12]),2)
color2D.matplot(correlations, show.values = 2, axes=FALSE, xlab="",ylab="")
axis(1,at=c(seq(from=0.5,to=10.5,by=1)),labels=colnames(correlations), cex.axis=1)
axis(2,at=c(seq(from=0.5,to=10.5,by=1)),labels=rev(colnames(correlations)), las=2, cex.axis=1)


## ANOVA Analysis of Original Model and Stepwise model
anova(fit.am, fit.step)

#{r Residuals, echo = FALSE}
## Residuals of the Stepwise Model
par(mfrow = c(2,2))
plot(fit.step)
