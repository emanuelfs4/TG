#include "DatasetOperations.h"

// Desvio Relativo
double _delta (Point a, Point b){
    if (std::abs(a.getX() - b.getX()) == 0){
        return -1;
    } else {
        double deltaX = std::abs(a.getX() - b.getX());
        double deltaY = std::abs(a.getY() - b.getY());
        double aux = deltaY/deltaX;
        return aux;
    }
    
}

// Algoritmo 1
double calculateThreshold(Dataset offset_set){
    double finalThreshold = 0;
    int i, j;
    double threshold;

        threshold = _delta(offset_set.pointAt(0), offset_set.pointAt(1));
    
        for(j = 2; j < offset_set.size(); j++){
            double d = _delta(offset_set.pointAt(j), offset_set.pointAt(j-1));
            if (d >= threshold ){
                threshold = d;
            }
        }

        if (threshold >= finalThreshold){
            finalThreshold = threshold;
        }
      
    return finalThreshold;
}


// Algoritmo 2
std::vector<Dataset> separateData (Dataset offset_set, double threshold) {
    std::vector<int> count;
    std::vector<int> current_offset;
    std::vector<Point> current_point;
    std::vector<Dataset> datasets;

    count.push_back(1);
    current_offset.push_back(0);
    current_point.push_back (offset_set.pointAt(0) );
    datasets.push_back (Dataset());
    datasets.at(0).insert(offset_set.pointAt(0));

    int i, j;
    bool underThreshold;
    for (i = 1; i < offset_set.size(); i++){
        underThreshold = false;
        for (j = 0; j < datasets.size(); j++){
            printf("Dataset: %d\n", j);
            printf("%s\n", datasets.at(j).toString().data());
            int k = current_offset.at(j);
            double d = _delta (offset_set.pointAt(i), offset_set.pointAt(k));
            printf("Delta: %lf\n", d);
            if (d <= threshold){
                underThreshold = true;
                datasets.at(j).insert(offset_set.pointAt(i));
                count.at(j) = count.at(j) + 1;
                current_point.at(j) = offset_set.pointAt(i);
                current_offset.at(j) = i;
           }

           printf("\n\n", d);

        }

        if (underThreshold == false){
            printf("new dataset\n");
            datasets.push_back(Dataset());
            datasets.back().insert(offset_set.pointAt(i));
            count.push_back(1);
            current_point.push_back(offset_set.pointAt(i));
            current_offset.push_back(i);
        }

        printf("*********************\n");

    }

    return datasets;

}
