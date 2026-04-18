#pragma once

#include <chrono>
#include <iostream>

class Timer {
private:
    std::chrono::time_point<std::chrono::steady_clock> start_time_point_m;
    const std::string default_stop_message = "Time elapsed: ";
public:
    void start() {
        start_time_point_m = std::chrono::high_resolution_clock::now();
    }
    void stop(const std::string& stop_message) {
        auto end_time_point = std::chrono::high_resolution_clock::now();

        auto start = std::chrono::time_point_cast<std::chrono::microseconds>(start_time_point_m).time_since_epoch().count();
        auto end = std::chrono::time_point_cast<std::chrono::microseconds>(end_time_point).time_since_epoch().count();

        std::cout << stop_message << end - start << "us" << std::endl;
    }
    void stop() {
        auto end_time_point = std::chrono::high_resolution_clock::now();

        auto start = std::chrono::time_point_cast<std::chrono::microseconds>(start_time_point_m).time_since_epoch().count();
        auto end = std::chrono::time_point_cast<std::chrono::microseconds>(end_time_point).time_since_epoch().count();

        std::cout << default_stop_message << end - start << "us" << std::endl;
    }
};
