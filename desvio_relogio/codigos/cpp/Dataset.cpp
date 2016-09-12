#include "Dataset.h"

Dataset::Dataset(char* timestamps_path, char* radiotaps_path, int n_beacons){
    _data = std::vector<Point>();
    // Data variables
    double delta_radiotap[n_beacons-1];
    double delta_timestamp[n_beacons-1];
    double delta_offset[n_beacons-1];


    // IO variables
    std::string line, line2;
    std::string timestamp_temp;
    std::string time_temp;
    std::ifstream timestampFile (timestamps_path); // ifstream = padrão ios:in
    std::ifstream radiotapFile (radiotaps_path); // ifstream = padrão ios:in
    std::ofstream resul;


    // Auxiliary variables
    int i=0;
    int j=0;


    getline (timestampFile,line);
    timestamp_temp = line;
    double  firstTimestamp= strtoull(timestamp_temp.data(), NULL, 0);
    delta_timestamp[i]=0;
   
    
    while(getline (timestampFile,line) && i < n_beacons - 1){
        timestamp_temp = line;
        double timestamp = strtoull(timestamp_temp.data(), NULL, 16);
        delta_timestamp[i] = timestamp - firstTimestamp;
        i++;
    }

    getline (radiotapFile, line2);
    time_temp = line2;
    double first_time = strtoull (time_temp.data(), NULL, 10);
    delta_radiotap[0] = 0;
   
    while(getline (radiotapFile,line2) && j < n_beacons - 1){
        time_temp = line2;
        double tempo = strtoull(time_temp.data(), NULL, 10);

       
        delta_radiotap[j] = tempo - first_time;
        j++;
    }


    int u = 0;
    while(u < j){
        delta_offset[u] = (delta_timestamp[u]-delta_radiotap[u]);
        u++;
    }

    u = 0;
    while (u < j){
        _data.push_back(Point(delta_radiotap[u], delta_offset[u]));
        u++;
    }

}