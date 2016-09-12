all: mainSeparateData

main:  Main.o DatasetOperations.o Dataset.o
	g++ -static Main.o DatasetOperations.o Dataset.o -lm -lgsl -lgslcblas -lglpk -o main

Main.o: Main.cpp
	g++ -c Main.cpp

DatasetOperations.o: DatasetOperations.cpp
	g++ -c DatasetOperations.cpp

Dataset.o: Dataset.cpp
	g++ -c Dataset.cpp

clean:
	rm -rf *.o main

mainSeparateData: mainSeparateData.o DatasetOperations.o Dataset.o
	g++ -static mainSeparateData.o DatasetOperations.o Dataset.o -lm -lgsl -lgslcblas -lglpk -o main

mainSeparateData.o: mainSeparateData.cpp
	g++ -c mainSeparateData.cpp