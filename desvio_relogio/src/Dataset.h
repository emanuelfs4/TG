#pragma once
#include <vector>
#include <string>
#include <sstream>
#include <cmath>
#include <fstream>
#include <stdlib.h>

/**
    Auxiliary class used inside datasets.
    Behaves like a normal 2-dimensional point.

*/
class Point {
private:
    double _x;
    double _y;
public:
    double getX(){
        return _x;
    }

    double getY(){
        return _y;
    }

    void setX(double x){
        _x = x;
    }

    void setY(double y){
        _y = y;
    }

    Point(double x, double y){
        _x = x;
        _y = y;
    }

    std::string toString(){
        std::ostringstream s;
        s << "(" << _x << ", " << _y << ")";
        return s.str();
    }

};

/**
    Class that represents a certain ammount of data.
    The data contained in any dataset is always an array of 2-dimensional Points.
*/
class Dataset{
private:
    std::vector<Point> _data;

public:
    Dataset(){
        _data = std::vector<Point>();
    }

    Dataset(std::vector<Point> data){
        _data = data;
    }

    Dataset(char* timestamps_path, char* radiotaps_path, int n_beacons);


    std::vector<Point> getData(){
        return _data;
    }

    Point pointAt(int i){
        return _data.at(i);
    }

    void insert (Point a){
        _data.push_back(a);
    }

    int size(){
        return _data.size();
    }

    std::string toString(){
        std::ostringstream s;
        s << "[";
        for (int i = 0; i < _data.size(); ++i)
        {
            s << _data.at(i).toString() + ", ";
        }
        s << "]";
        return s.str();
    }

    /**
        Creates a new dataset that contains a portion of the points contained in this dataset.
    */
    Dataset subDataset(int bgn, int end){
        return Dataset(std::vector<Point>(_data.begin()+bgn, _data.begin()+end));
    }

   
    
};