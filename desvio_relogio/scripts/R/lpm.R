library(lpSolve)
library(lpSolveAPI)

timestamp = read.table("/home/efds/Dropbox/TG/skews/scripts/data_manel-10000/beacon_timestamps.txt")
radiotap = read.table("/home/efds/Dropbox/TG/skews/scripts/data_manel-10000/station_timestamps.txt")



array = array(dim=c(50,2))

for (k in 1:50) {
  
  rand = sample(1:(length(timestamp$V1)-300),1)
  timestamp2 = timestamp$V1[as.numeric(rand):as.numeric(rand+300)]
  
  t = timestamp2 - timestamp2[1]
  
  radiotap2 = radiotap$V1[as.numeric(rand):as.numeric(rand+300)]
  
  r = radiotap2 - radiotap2[1]
  
  offset = t - r 
  
  flag = 1
  
  if (sum(t - r) > 0){
    offset  = t - r
    
  }else{
    
    offset  = r - t
    flag = -1
  }
  
  
  sink("/home/efds/Dropbox/TG/R/model.lp")
    
  cat ("min: ")
  cat (sum(r)/length(r)-1)
  cat (" x ")
  cat ("+")
  cat (" y ")
  if ((-1)*(sum(offset)/length(r)-1) >= 0){ 
    cat(" + ")
    cat ((-1)*(sum(offset)/length(r)-1))
  
  } else {
    cat ((-1)*(sum(offset)/length(r)-1))
  }
  cat (";")
  cat("\n")
  
  for(i in 2:length(r)){
    
    cat(r[i])
    cat(" x ")
    cat("+") 
    cat(" y ")
    cat(" >= ")
    cat(offset[i])
    cat(";")
    cat("\n") 
    
  }
  
  sink()
  
  lpm = read.lp("/home/efds/Dropbox/TG/R/model.lp", type=c("lp"), verbose = "neutral")
  solve(lpm)
  var = get.variables(lpm)
  #abline(var)
  print("LPM Slope:")
  var[1] = var[1]* flag
  skew_lpm = var[1]*1000000
  
  lsf = lsfit(r,offset)
  print("LSF Slope:")
  
  lsf$coefficients[2] = lsf$coefficients[2]*flag
  skew_lsf = lsf$coefficients[2]*1000000
  Radiotap = r
  Offset = flag*offset
  
  plot(Radiotap, Offset,pch='.',  xlab="Time from beginning of experiment (μs)", ylab="Clock offset (μs)")
  abline(lsf, col="blue", lwd=2)
  abline(var[2],var[1], col="red", lwd=2)
  
  legend("topright", c(paste("LPM (", round(var[1]*1000000, digits=2),")"), paste("LSF (", round(lsf$coefficients[2]*1000000, digits=2),")")), lty=c(1,1), col=c("red", "blue"), lwd=c(2,2), cex=0.7)
  
  ## CALCULATING THE THRESHOLD
  
  final_thr = 0
  thr = abs(offset[2] - offset[1])/abs(r[2] - r[1])
  print(thr)
  for (i in 3:length(r)) {
    new_thr = abs(offset[i] - offset[i-1])/abs(r[i] - r[i-1])
    if( new_thr >= thr ) {
      thr = new_thr
    } 
  }
  if (thr >= final_thr) {
    final_thr = thr
    
  }
  print(final_thr)
  
  ## Printing the Slopes
  
  print("Slope LPM:")
  print(skew_lpm)
  
  print("Slope LSF:")
  print(skew_lsf)
  
  print(k)
  array[as.numeric(k),][1] = skew_lpm
  array[as.numeric(k),][2] = as.numeric(skew_lsf)

}

len = 10000
timestamp2 = timestamp$V1[0:len]

t = timestamp2 - timestamp2[1]

radiotap2 = radiotap$V1[0:len]

r = radiotap2 - radiotap2[1]

offset = t - r 

flag = 1

if (sum(t - r) > 0){
  offset  = t - r
  
}else{
  
  offset  = r - t
  flag = -1
}


sink("/home/efds/Dropbox/TG/R/model.lp")

cat ("min: ")
cat (sum(r)/length(r)-1)
cat (" x ")
cat ("+")
cat (" y ")
if ((-1)*(sum(offset)/length(r)-1) >= 0){ 
  cat(" + ")
  cat ((-1)*(sum(offset)/length(r)-1))
  
} else {
  cat ((-1)*(sum(offset)/length(r)-1))
}
cat (";")
cat("\n")

for(i in 2:length(r)){
  
  cat(r[i])
  cat(" x ")
  cat("+") 
  cat(" y ")
  cat(" >= ")
  cat(offset[i])
  cat(";")
  cat("\n") 
  
}

sink()

lpm_total = read.lp("/home/efds/Dropbox/TG/R/model.lp", type=c("lp"), verbose = "neutral")
solve(lpm_total)
var = get.variables(lpm_total)
#abline(var)
print("LPM Slope:")
var[1] = var[1]* flag
skew_lpm_total = var[1]*1000000

lsf_total = lsfit(r,offset)
print("LSF Slope:")

lsf_total$coefficients[2] = lsf_total$coefficients[2]*flag
skew_lsf_total = lsf_total$coefficients[2]*1000000
Radiotap = r
Offset = flag*offset

lpm_sample = array[,1]
lsf_sample = array[,2]

print(lpm_sample)
print(lsf_sample)

png(filename="./lpm_total.png")
plot(lpm_sample, xlab="# Experimento", ylab="Desvio de relógio estimado", main="MPL",ylim=c(0,30), pch=4,col='blue')
abline(skew_lpm_total, 0,lty=2,lwd=2)
dev.off()

png(filename="./lsf_total.png")
plot(lsf_sample, xlab="# Experimento", ylab="Desvio de relógio estimado", main="MMQ",ylim=c(0,30), pch=3,col='red')
abline(skew_lsf_total, 0,lty=2,lwd=2)
dev.off()

