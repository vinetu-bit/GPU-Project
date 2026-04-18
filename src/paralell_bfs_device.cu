__global__ void kernel(int* frontier, int* visited, int* cost, int* adj_list, int V, int* neighbor_sizes) {
    int id = blockIdx.x * blockDim.x + threadIdx.x;
    if(id < V) {
        if(frontier[id]) {
            frontier[id] = false;
            visited[id] = true;
            for(int j = 0; j < neighbor_sizes[id]; j++) {
                if(!visited[adj_list[id*neighbor_sizes[id]+j]]) {
                    cost[adj_list[id*neighbor_sizes[id]+j]] = cost[id] + 1;
                    frontier[adj_list[id*neighbor_sizes[id]+j]] = true;
                }
            }
        }
    }
}
