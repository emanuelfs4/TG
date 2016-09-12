#include "Dataset.h"
#include <stdio.h>
#include <gsl/gsl_fit.h>      
#include <glpk.h>             

std::vector<Dataset> separateData (Dataset offset_set, double threshold);
double _delta(Point a, Point b);
double calculateThreshold(Dataset offset_set);
