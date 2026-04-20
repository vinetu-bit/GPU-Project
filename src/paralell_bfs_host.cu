#include <iostream>
#include <vector>
#include <climits>
#include "../include/bfs_help_functions.h"

// Kernel deklarálás
__global__ void kernel(int* frontier, int* visited, int* cost, int* adj_list, int V, int* neighbor_sizes);

std::vector<int> gpu_bfs(const std::vector<std::vector<int>>& adj_list, int source_vertex) {
    // Csúcsok száma a gráfban
    const int V = adj_list.size();

    // Szomszédok száma csúcsonként (erre majd lehet kitalálok valami jobb megoldást)
    std::vector<int> neighbor_sizes;
    for(auto element : adj_list) {
        neighbor_sizes.emplace_back(static_cast<int>(element.size()));
    }

    // Segéd vektorok
    std::vector<int> frontier = std::vector<int>(V, false);
    std::vector<int> visited = std::vector<int>(V, false);
    std::vector<int> cost = std::vector<int>(V, INT_MAX);

    // GPU memória allokálása
    int* gpu_frontier = nullptr;
    int* gpu_visited = nullptr;
    int* gpu_cost = nullptr;
    int* gpu_adj = nullptr;
    int* gpu_neighbor_sizes = nullptr;

    cudaMalloc(&gpu_frontier, V * sizeof(int));
    cudaMalloc(&gpu_visited, V * sizeof(int));
    cudaMalloc(&gpu_cost, V * sizeof(int));
    cudaMalloc(&gpu_adj, V * V * sizeof(int));
    cudaMalloc(&gpu_neighbor_sizes, V * sizeof(int));

    // Adatok átmásolása a device-ra
    cudaMemcpy(gpu_frontier, frontier.data(), V * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(gpu_visited, visited.data(), V * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(gpu_cost, cost.data(), V * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(gpu_adj, adj_list.data()->data(), V * V * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(gpu_neighbor_sizes, neighbor_sizes.data(), V * sizeof(int), cudaMemcpyHostToDevice);

    // Algoritmus
    frontier[source_vertex] = true;
    cost[source_vertex] = 0;
    while (!all_false(frontier)) {
        constexpr int threads_per_block = 512;
        const int blocks_per_grid = (V + threads_per_block - 1) / threads_per_block;
        // Kernel hívás
        kernel<<<blocks_per_grid, threads_per_block>>>(gpu_frontier, gpu_visited, gpu_cost, gpu_adj, V, gpu_neighbor_sizes);
        cudaMemcpy(frontier.data(), gpu_frontier, V * sizeof(int), cudaMemcpyDeviceToHost);
        cudaDeviceSynchronize();
    }
    // Eredmény vissza másolása a host-ra
    cudaMemcpy(cost.data(), gpu_cost, V * sizeof(int), cudaMemcpyDeviceToHost);

    // GPU memória felszabadítása
    cudaFree(gpu_frontier);
    cudaFree(gpu_visited);
    cudaFree(gpu_cost);
    cudaFree(gpu_neighbor_sizes);

    // Eredmény :)
    return cost;
}

// Majd lesz normális teszt is
// Példa input-ra: (1-es jelöli az utat 0-ás a falat)
// [
// 0 0 0 0 0
// 1 1 0 1 0
// 0 1 1 1 0
// 0 1 0 0 0
// ]
int main() {
    std::vector<std::vector<int>> labyrinth = {{0,0,0,0,0},{1,1,0,1,0},{0,1,1,1,0},{0,1,0,0,0}};
    std::vector<std::vector<int>> converted_graph = convert_to_adj_list(labyrinth);

    for(auto row : converted_graph) {
        for(auto element : row) {
            std::cout << element << " ";
        }
        std::cout << std::endl;
    }

    std::vector<int> cpu_result = cpu_bfs(converted_graph, 0);
    std::vector<int> gpu_result = gpu_bfs(converted_graph, 0);

    std::cout << "CPU - Results: " << std::endl;
    for(auto element : cpu_result) {
        std::cout << element << std::endl;
    }
    std::cout << "GPU - Results: " << std::endl;
    for(auto element : cpu_result) {
        std::cout << element << std::endl;
    }
}
// TODO valahogy a BFS eredményét lefordítani koordinátákra, hogy megmondjuk mely "négyzeteken" keresztül vezet
// az út a labirintusban.
