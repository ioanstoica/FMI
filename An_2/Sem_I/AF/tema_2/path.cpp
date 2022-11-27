// Stoica Ioan
// https://leetcode.com/problems/path-with-maximum-probability/submissions/

class Solution
{
public:
    double maxProbability(int n, vector<vector<int>> &edges,
                          vector<double> &succProb, int start, int end)
    {
        vector<vector<pair<int, double>>> graph(n);
        priority_queue<pair<double, int>> Heap;
        Heap.emplace(1.0, start);
        vector<bool> seen(n);

        for (int i = 0; i < edges.size(); ++i)
        {
            const int u = edges[i][0];
            const int v = edges[i][1];
            const double prob = succProb[i];
            graph[u].emplace_back(v, prob);
            graph[v].emplace_back(u, prob);
        }

        while (!Heap.empty())
        {
            const auto [prob, u] = Heap.top();
            Heap.pop();
            if (u == end)
                return prob;
            if (seen[u])
                continue;
            seen[u] = true;
            for (const auto &[nextNode, edgeProb] : graph[u])
            {
                if (seen[nextNode])
                    continue;
                Heap.emplace(prob * edgeProb, nextNode);
            }
        }

        return 0;
    }
};

// COMPLEXITY: O(n log n)