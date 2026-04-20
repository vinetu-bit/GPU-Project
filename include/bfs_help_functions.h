#pragma once

#include <vector>

std::vector<std::vector<int>> convert_to_adj_list(const std::vector<std::vector<int>>& input);
std::vector<int> cpu_bfs(const std::vector<std::vector<int>>& adj_list, int source_vertex);
bool all_false(const std::vector<int>& v);
