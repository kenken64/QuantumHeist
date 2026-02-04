# Best vs Worst Path Comparison

## Overview

This document compares the two pathfinding approaches used in Challenge 2: the **Best Path** (optimal/shortest) and **Worst Path** (longest valid path).

---

## Algorithm Comparison

| Aspect | Best Path | Worst Path |
|--------|-----------|------------|
| **Goal** | Minimize time | Maximize time |
| **Algorithm** | Dijkstra's (Min-Heap) | Modified BFS (Max tracking) |
| **Priority** | Process lowest time first | Explore all paths, track maximum |
| **State Update** | Update if new time is LOWER | Update if new time is HIGHER |
| **Guarantee** | Optimal solution guaranteed | Longest path within limits |

---

## Technical Implementation

### Best Path (Dijkstra's Algorithm)

```
Data Structure: Min-Heap Priority Queue
Strategy: Always process the state with lowest time first

When visiting a state:
  - If new_time < visited_time: Update and enqueue
  - First time reaching goal = optimal solution
```

**Key Properties:**
- Greedy approach (always picks minimum)
- Guarantees global optimum
- Early termination on first goal reach

### Worst Path (Modified BFS)

```
Data Structure: Queue with max-time tracking
Strategy: Explore all paths, keep track of maximum time to goal

When visiting a state:
  - If new_time > visited_time: Update and enqueue
  - Continue until all paths explored or limit reached
```

**Key Properties:**
- Exhaustive exploration
- Tracks maximum instead of minimum
- Requires time cap to prevent infinite loops

---

## Performance Comparison

### Demo Puzzle Results

| Metric | Best Path | Worst Path |
|--------|-----------|------------|
| **Time Units** | 44 | 143 |
| **Path Steps** | 46 | 47 |
| **States Explored** | ~5,400 | ~498,000 |
| **Execution Time** | ~22ms | ~888ms |

### Why Worst Path is Slower

1. **More States**: Must explore many more possibilities
2. **No Early Termination**: Cannot stop at first solution
3. **Cycle Handling**: Must track longer paths through same positions
4. **Time Cap Needed**: Without limits, could explore infinitely

---

## State Transition Logic

### Best Path State Update
```javascript
// Update only if we found a FASTER way
if (!visited.has(hash) || visited.get(hash) > newTime) {
    visited.set(hash, newTime);  // Store minimum time
    pq.insert(newState);
}
```

### Worst Path State Update
```javascript
// Update only if we found a SLOWER way
if (!visited.has(hash) || visited.get(hash) < newTime) {
    visited.set(hash, newTime);  // Store maximum time
    queue.push(newState);
}
```

---

## Use Cases

### When to Use Best Path
- Finding optimal solutions
- Competitive scenarios (minimize score/time)
- Real-world navigation (shortest route)
- Resource optimization

### When to Use Worst Path
- Testing system limits
- Finding edge cases
- Stress testing
- Analyzing puzzle complexity
- Educational purposes (understanding state space)

---

## Complexity Analysis

### Best Path
| Complexity | Formula |
|------------|---------|
| Time | O(S × log S) where S = state space |
| Space | O(S) |

### Worst Path
| Complexity | Formula |
|------------|---------|
| Time | O(S × T) where T = time limit |
| Space | O(S) |

**Note:** Worst path has higher practical complexity due to revisiting states with different times.

---

## Visual Comparison

### Best Path Strategy
```
Start ──► Always pick fastest ──► First goal = Answer
              │
              ▼
         [Min-Heap]
         ┌─────────┐
         │ Time: 5 │ ◄── Process this first
         │ Time: 8 │
         │ Time: 12│
         └─────────┘
```

### Worst Path Strategy
```
Start ──► Explore everything ──► Track all goals ──► Pick slowest
              │
              ▼
          [Queue]
         ┌─────────┐
         │ Time: 5 │
         │ Time: 8 │     Compare all
         │ Time: 12│ ◄── Keep maximum
         └─────────┘
```

---

## Code Differences

### Priority Queue (Best Path)
```javascript
// Min-Heap: smallest time bubbles up
bubbleUp(idx) {
    if (heap[parentIdx].time <= heap[idx].time) break;
    // Parent stays if smaller or equal
}
```

### Queue with Max Tracking (Worst Path)
```javascript
// Track maximum time to each state
if (visited.get(hash) < newTime) {
    visited.set(hash, newTime);  // Update to larger time
}
```

---

## Limitations

### Best Path
- Cannot find alternative optimal paths
- Single solution only
- May miss interesting longer routes

### Worst Path
- Requires time cap (maxTime = 200)
- Computationally expensive
- May not find true worst if cap too low
- Not practical for large state spaces

---

## Summary Table

| Feature | Best Path | Worst Path |
|---------|-----------|------------|
| Speed | Fast | Slow |
| Memory | Moderate | Higher |
| Accuracy | Guaranteed optimal | Best within limits |
| Use Case | Production | Analysis/Testing |
| Complexity | O(S log S) | O(S × T) |
| Early Exit | Yes | No |

---

## Recommendations

1. **For solving puzzles**: Use Best Path
2. **For testing coverage**: Use Worst Path
3. **For comparison**: Run both and analyze the difference
4. **For large puzzles**: Avoid Worst Path (too slow)

---

*Document Version: 1.0*
