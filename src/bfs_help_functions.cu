#include "../include/bfs_help_functions.h"
#include <vector>
#include <climits>

// Átalakítja a labirintust egy szomszédossági listában reprezentált gráffá
std::vector<std::vector<int>> convert_to_adj_list(const std::vector<std::vector<int>>& input) {
    size_t rows = input.size();
    size_t cols = input[0].size();

    std::vector<std::vector<int>> converted_result = std::vector<std::vector<int>>(rows, std::vector<int>());

    for(size_t i = 0; i < rows; i++) {
        for(size_t j = 0; j < cols; j++) {
            if(input[i][j] && i != j){
                converted_result[i].emplace_back(static_cast<int>(j));
                converted_result[j].emplace_back(static_cast<int>(i));
            }
        }
    }
    return converted_result;
}

// Segéd fv. csak megnézi, hogy egy tömb-ben minden elem 0-e azaz false
bool all_false(const std::vector<int>& v) {
    for(auto element : v) {
        if(element) {
            return false;
        }
    }
    return true;
}

// CPU-s implementáció benchmark-hoz
std::vector<int> cpu_bfs(const std::vector<std::vector<int>>& adj_list, int source_vertex) {
    // Csúcsok száma a gráfban (Hány olyan "kocka" van a labirintusban ami nem fal)
    const int V = adj_list.size();

    // Segéd vektorok definiálása
    std::vector<int> frontier = std::vector<int>(V, false);
    std::vector<int> visited = std::vector<int>(V, false);
    std::vector<int> cost = std::vector<int>(V, INT_MAX);

    // Algoritmus
    frontier[source_vertex] = true;
    cost[source_vertex] = 0;
    while (!all_false(frontier)) {
        for(int i = 0; i < V; i++) {
            if(frontier[i]) {
                frontier[i] = false;
                visited[i] = true;
                const int neighbor_size = adj_list[i].size();
                for(int j = 0; j < neighbor_size; j++) {
                    if(!visited[adj_list[i][j]]) {
                        cost[adj_list[i][j]] = cost[i] + 1;
                        frontier[adj_list[i][j]] = true;
                    }
                }
            }
        }
    }
    return cost;
}
