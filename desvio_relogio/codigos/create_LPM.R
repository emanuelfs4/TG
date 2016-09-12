library(lpSolve)
library(lpSolveAPI)

#Full directory of the Router
directory="ROUTER_DIRECTORY"


#Load the Timestamp and Station files
timestamp = read.table(paste(directory,"beacon_timestamps.txt",""))
radiotap = read.table(pastee(directory,"station_timestamps.txt",""))

array = array(dim=c(50,2))

# Getting samples of 300 beacons.
rand = sample(1:(length(timestamp$V1)-300),1)


# Selection of 300 timestamp
timestamp2 = timestamp$V1[as.numeric(rand):as.numeric(rand+300)]

# Timestamp Delta value
t = timestamp2 - timestamp2[1]

# Selection of 300 radiotap 
radiotap2 = radiotap$V1[as.numeric(rand):as.numeric(rand+300)]

# Radiotap Delta value
r = radiotap2 - radiotap2[1]

# Calculating the OFFSET
offset = t - r 

# Flag to determine if the sum of the offset-set is positive or negative.
flag = 1

if (sum(t - r) > 0){
	offset  = t - r
}else{
	offset  = r - t
	flag = -1
}


###Start of the creation of the Linear Programming Model.
#Creating the file
sink("./model.lp")

# Creating the minimization function
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

# Creating the constraing functions

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

# Reads the Linear Programming Model
lpm = read.lp("./model.lp", type=c("lp"), verbose = "neutral")

# Solves it if possible
solve(lpm)

var = get.variables(lpm)


#print("LPM Slope:")
var[1] = var[1]* flag
skew_lpm = var[1]*1000000

lsf = lsfit(r,offset)


#print("LSF Slope:")
lsf$coefficients[2] = lsf$coefficients[2]*flag
skew_lsf = lsf$coefficients[2]*1000000

Radiotap = r
Offset = flag*offset

# Plot of the LSF and LPM on the same graph

plot(Radiotap, Offset,pch='.',  xlab="Time from beginning of experiment (μs)", ylab="Clock offset (μs)")
abline(lsf, col="blue", lwd=2)
abline(var[2],var[1], col="red", lwd=2)
dev.off()

legend("topright", c(paste("LPM (", round(var[1]*1000000, digits=2),")"), paste("LSF (", round(lsf$coefficients[2]*1000000, digits=2),")")), lty=c(1,1), col=c("red", "blue"), lwd=c(2,2), cex=0.7)

## CALCULATING THE THRESHOLD

final_thr = 0
thr = abs(offset[2] - offset[1])/abs(r[2] - r[1])

# Print the initial threshold
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

# Printing the Threshold
print(final_thr)

## Printing the Slopes
print("Slope LPM:")
print(skew_lpm)

print("Slope LSF:")
print(skew_lsf)
