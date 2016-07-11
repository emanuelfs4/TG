#include "Dataset.h"
#include "DatasetOperations.h"
#include <iostream>


int main(){
	
	Dataset dataset = Dataset(
		"/home/efds/Dropbox/TG/skews/scripts/all_data/pairs/dlink_2e69/data_dlink_2b69-1000-1/beacon_timestamps.txt", 
		"/home/efds/Dropbox/TG/skews/scripts/all_data/pairs/dlink_2e69/data_dlink_2b69-1000-1/station_timestamps.txt",
		50);

	double thr = calculateThreshold(dataset); 	
	std::vector<Dataset> results = separateData(dataset, 0.003);
	std::cout << results.size() << "\n";
	std::cout <<  thr << "\n";
	return 0;
}