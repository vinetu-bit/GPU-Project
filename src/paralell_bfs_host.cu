#include <iostream>
#include <vector>
#include <climits>

// Kernel deklarálás
__global__ void kernel(int* frontier, int* visited, int* cost, int* adj_list, int V, int* neighbor_sizes);

// Segéd fv. cpu_bfs-hez
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
int main() {
    std::vector<std::vector<int>> graph = {{1,4},{0,2,4,6},{1,3},{2,4},{1,3},{0,6},{1,5}};
    std::vector<int> cpu_result = cpu_bfs(graph, 0);
    std::vector<int> gpu_result = gpu_bfs(graph, 0);

    std::cout << "CPU - Results: " << std::endl;
    for(auto element : cpu_result) {
        std::cout << element << std::endl;
    }
    std::cout << "GPU - Results: " << std::endl;
    for(auto element : cpu_result) {
        std::cout << element << std::endl;
    }
}
