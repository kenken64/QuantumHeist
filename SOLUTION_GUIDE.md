# Challenge 2 - Comprehensive Solution Guide

## Table of Contents
1. [Problem Overview](#1-problem-overview)
2. [Theoretical Foundation](#2-theoretical-foundation)
3. [Algorithm Selection](#3-algorithm-selection)
4. [Data Structures](#4-data-structures)
5. [State Representation](#5-state-representation)
6. [Implementation Details](#6-implementation-details)
7. [Complexity Analysis](#7-complexity-analysis)
8. [Optimization Techniques](#8-optimization-techniques)
9. [Common Pitfalls](#9-common-pitfalls)
10. [Extensions and Variations](#10-extensions-and-variations)

---

## 1. Problem Overview

### 1.1 Problem Statement
Navigate through a museum grid to collect all gems and reach the exit in minimum time while handling various obstacles and mechanics.

### 1.2 Grid Elements
| Symbol | Element | Description |
|--------|---------|-------------|
| `S` | Start | Initial position |
| `E` | Exit | Goal position |
| `G` | Gem | Must collect all |
| `K` | Key | Unlocks corresponding door |
| `D` | Door | Requires matching key |
| `P` | Portal | Teleport to paired portal |
| `L` | Laser | Active when time % 3 == 0 |
| `T` | Time Rift | Rewind 2 time units |
| `#` | Wall | Impassable |
| `.` | Empty | Free movement |

### 1.3 Movement Rules
- **Basic Movement:** Up, Down, Left, Right (1 time unit each)
- **Portal:** Instant teleport (0 time units), each pair usable once
- **Time Rift:** Subtract 2 from current time, usable once globally

### 1.4 Win Condition
Reach the exit `E` after collecting ALL gems `G` in minimum total time.

---

## 2. Theoretical Foundation

### 2.1 Graph Theory Perspective
The problem can be modeled as a weighted graph traversal:
- **Nodes:** States (position + collected items + used resources)
- **Edges:** Valid transitions (movements, portal use, time rift)
- **Weights:** Time cost of each transition

### 2.2 State Space
The state space is multi-dimensional:
```
State = (row, col, gems_collected, keys_collected, portals_used, rift_used)
```

This creates a state space of size:
```
|S| = R × C × 2^G × 2^K × 2^P × 2
```

Where:
- R = number of rows
- C = number of columns
- G = number of gems
- K = number of keys
- P = number of portal pairs

### 2.3 Optimal Substructure
The problem exhibits optimal substructure: the optimal path to any state consists of optimal paths to intermediate states. This property allows us to use dynamic programming approaches like Dijkstra's algorithm.

---

## 3. Algorithm Selection

### 3.1 Why Dijkstra's Algorithm?

| Algorithm | Pros | Cons | Verdict |
|-----------|------|------|---------|
| BFS | Simple, O(V+E) | Only for unweighted graphs | Not suitable (time rift creates negative-like effects) |
| DFS | Low memory | No optimality guarantee | Not suitable |
| Dijkstra | Optimal, handles weights | O((V+E) log V) | **Best choice** |
| A* | Potentially faster | Requires admissible heuristic | Viable but complex |

### 3.2 Dijkstra's Algorithm Overview
```
1. Initialize distances to infinity, start to 0
2. Add start state to priority queue
3. While queue not empty:
   a. Extract minimum distance state
   b. If goal state, return solution
   c. For each neighbor:
      - Calculate new distance
      - If better than known, update and enqueue
4. Return no solution
```

### 3.3 Modifications for This Problem
1. **State includes more than position:** Must track collected items
2. **Multiple goal conditions:** Position AND all gems collected
3. **Non-standard transitions:** Portals (0 cost), time rifts (negative cost)

---

## 4. Data Structures

### 4.1 Min-Heap Priority Queue

A min-heap maintains the heap property: parent ≤ children.

**Structure:**
```
        10
       /  \
      15   20
     / \
    25  30
```

**Array Representation:**
```
Index:  0   1   2   3   4
Value: [10, 15, 20, 25, 30]

Parent of i: floor((i-1)/2)
Left child of i: 2i + 1
Right child of i: 2i + 2
```

**Operations:**

**Insert (Bubble Up):**
```javascript
insert(item) {
    heap.push(item);
    let idx = heap.length - 1;
    while (idx > 0) {
        let parentIdx = Math.floor((idx - 1) / 2);
        if (heap[parentIdx].time <= heap[idx].time) break;
        swap(heap[parentIdx], heap[idx]);
        idx = parentIdx;
    }
}
```
Time: O(log n)

**Extract Min (Bubble Down):**
```javascript
extractMin() {
    if (heap.length === 0) return null;
    if (heap.length === 1) return heap.pop();

    const min = heap[0];
    heap[0] = heap.pop();

    let idx = 0;
    while (true) {
        let smallest = idx;
        let left = 2 * idx + 1;
        let right = 2 * idx + 2;

        if (left < heap.length && heap[left].time < heap[smallest].time)
            smallest = left;
        if (right < heap.length && heap[right].time < heap[smallest].time)
            smallest = right;
        if (smallest === idx) break;

        swap(heap[smallest], heap[idx]);
        idx = smallest;
    }
    return min;
}
```
Time: O(log n)

### 4.2 Bitmask for State Compression

Instead of arrays/sets, use integers where each bit represents an item.

**Example: 3 Gems**
```
Gems collected: [true, false, true]
Bitmask: 101 (binary) = 5 (decimal)

Bit 0 (rightmost): Gem 0 → 1 (collected)
Bit 1: Gem 1 → 0 (not collected)
Bit 2: Gem 2 → 1 (collected)
```

**Operations:**
```javascript
// Check if gem i is collected
isCollected = (gemMask & (1 << i)) !== 0;

// Collect gem i
newMask = gemMask | (1 << i);

// Check if all n gems collected
allCollected = gemMask === (1 << n) - 1;
// For n=3: (1 << 3) - 1 = 8 - 1 = 7 = 111 (binary)
```

**Why Bitmasks?**
- Memory efficient: 32 items in one integer
- Fast operations: O(1) bitwise operations
- Easy hashing: Integer comparison vs array comparison

### 4.3 Hash Map for Visited States

**Key Design:**
```javascript
hash() {
    return `${row},${col},${gemMask},${keyMask},${portalMask},${riftUsed}`;
}
```

**Why String Keys?**
- JavaScript Maps handle string keys efficiently
- Easy to construct and compare
- Human-readable for debugging

---

## 5. State Representation

### 5.1 State Class
```javascript
class State {
    constructor(r, c, time, gemMask, keyMask, portalMask, riftUsed) {
        this.r = r;              // Current row
        this.c = c;              // Current column
        this.time = time;        // Time elapsed
        this.gemMask = gemMask;  // Bitmask: collected gems
        this.keyMask = keyMask;  // Bitmask: collected keys
        this.portalMask = portalMask;  // Bitmask: used portal pairs
        this.riftUsed = riftUsed;      // Boolean: time rift used
    }
}
```

### 5.2 State Transitions

**Movement Transition:**
```
Current: (r, c, t, gems, keys, portals, rift)
Move Down: (r+1, c, t+1, gems', keys', portals, rift)

Where gems' and keys' may be updated if item at new position
```

**Portal Transition:**
```
Current: (r, c, t, gems, keys, portals, rift)
Use Portal: (r', c', t, gems', keys', portals | (1 << portalIdx), rift)

Note: Time does not increase!
```

**Time Rift Transition:**
```
Current: (r, c, t, gems, keys, portals, false)
Use Rift: (r, c, t-2, gems, keys, portals, true)

Constraints: t >= 2, rift not already used
```

### 5.3 State Validity
A state is valid if:
1. Position within grid bounds
2. Position is not a wall
3. If position is a door, corresponding key is collected
4. If position is a laser, current time % 3 ≠ 0

---

## 6. Implementation Details

### 6.1 Grid Parsing
```javascript
function parseMuseum(grid) {
    const museum = {
        grid: grid.map(row => row.split('')),
        rows: grid.length,
        cols: grid[0].length,
        start: null,
        exit: null,
        gems: [],
        keys: [],
        doors: [],
        portals: new Map(),
        timeRifts: [],
        lasers: []
    };

    // Scan grid and populate element lists
    for (let r = 0; r < museum.rows; r++) {
        for (let c = 0; c < museum.cols; c++) {
            const cell = museum.grid[r][c];
            // Identify and store each element type
        }
    }

    // Pair portals in order of appearance
    return museum;
}
```

### 6.2 Main Solver Loop
```javascript
function solve(grid) {
    const museum = parseMuseum(grid);
    const pq = new MinHeap();
    const visited = new Map();

    // Initialize
    const start = new State(museum.start.r, museum.start.c, 0, 0, 0, 0, false);
    pq.insert(start);
    visited.set(start.hash(), 0);

    while (!pq.isEmpty()) {
        const current = pq.extractMin();

        // Skip if we've found better path to this state
        if (visited.get(current.hash()) < current.time) continue;

        // Check win condition
        if (isAtExit(current) && hasAllGems(current)) {
            return current.time;
        }

        // Generate and process all valid next states
        for (const next of generateNextStates(current, museum)) {
            const hash = next.hash();
            if (!visited.has(hash) || visited.get(hash) > next.time) {
                visited.set(hash, next.time);
                pq.insert(next);
            }
        }
    }

    return -1; // No solution
}
```

### 6.3 Generating Next States
```javascript
function generateNextStates(current, museum) {
    const states = [];

    // 1. Four directional movements
    const directions = [[-1,0], [1,0], [0,-1], [0,1]];
    for (const [dr, dc] of directions) {
        const nr = current.r + dr;
        const nc = current.c + dc;
        if (isValidMove(nr, nc, current.keyMask, current.time + 1, museum)) {
            const next = createMovementState(current, nr, nc, museum);
            states.push(next);
        }
    }

    // 2. Portal usage
    if (isOnPortal(current, museum) && !portalUsed(current, museum)) {
        const next = createPortalState(current, museum);
        states.push(next);
    }

    // 3. Time rift usage
    if (isOnTimeRift(current, museum) && !current.riftUsed && current.time >= 2) {
        const next = createTimeRiftState(current);
        states.push(next);
    }

    return states;
}
```

### 6.4 Laser Timing Logic
```javascript
function isLaserActive(r, c, time, museum) {
    const isLaser = museum.lasers.some(l => l.r === r && l.c === c);
    return isLaser && (time % 3 === 0);
}
```

**Laser Pattern:**
| Time | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
|------|---|---|---|---|---|---|---|---|---|
| Active | Yes | No | No | Yes | No | No | Yes | No | No |

---

## 7. Complexity Analysis

### 7.1 State Space Size
```
|States| = R × C × 2^G × 2^K × 2^P × 2
```

**Example Calculation:**
- Grid: 12 × 15 = 180 positions
- Gems: 3 → 2³ = 8 combinations
- Keys: 1 → 2¹ = 2 combinations
- Portal pairs: 4 → 2⁴ = 16 combinations
- Time rift: 2 states

Total: 180 × 8 × 2 × 16 × 2 = **92,160 possible states**

### 7.2 Time Complexity
```
O(|States| × log|States|)
= O(R × C × 2^(G+K+P) × log(R × C × 2^(G+K+P)))
```

**Breakdown:**
- Each state processed at most once: O(|States|)
- Priority queue operations: O(log |States|)
- State generation: O(1) per state (constant neighbors)

### 7.3 Space Complexity
```
O(|States|) = O(R × C × 2^(G+K+P))
```

**Components:**
- Visited map: O(|States|)
- Priority queue: O(|States|) worst case
- Parent map (for path reconstruction): O(|States|)

### 7.4 Practical Limits
| Items | State Space | Feasibility |
|-------|-------------|-------------|
| G+K+P ≤ 10 | ~10^6 | Fast |
| G+K+P ≤ 15 | ~10^7 | Acceptable |
| G+K+P ≤ 20 | ~10^8 | Slow |
| G+K+P > 20 | ~10^9+ | Impractical |

---

## 8. Optimization Techniques

### 8.1 Early Termination
Since Dijkstra's processes states in order of time, the first time we reach the goal state is guaranteed optimal. No need to continue searching.

### 8.2 State Pruning
Skip states where:
- Already visited with lower or equal time
- Gems collected is subset of previously visited state at same position with same time

### 8.3 Efficient State Hashing
Use numeric operations instead of string concatenation when possible:
```javascript
// Slower
hash = `${r},${c},${gemMask},${keyMask}`;

// Faster (if values fit)
hash = r * 1000000 + c * 10000 + gemMask * 100 + keyMask;
```

### 8.4 Lazy State Creation
Don't create state objects until needed:
```javascript
// Check validity before creating
if (!isValidMove(nr, nc, keyMask, newTime)) continue;
const newState = new State(...); // Only create if valid
```

---

## 9. Common Pitfalls

### 9.1 Forgetting Time in Laser Check
```javascript
// WRONG: Checking current time
if (isLaserActive(nr, nc, current.time)) continue;

// CORRECT: Checking arrival time
if (isLaserActive(nr, nc, current.time + 1)) continue;
```

### 9.2 Portal Pair Indexing
```javascript
// WRONG: Using position as index
portalMask |= (1 << portalPosition);

// CORRECT: Using pair index
const pairIndex = getPortalPairIndex(r, c);
portalMask |= (1 << pairIndex);
```

### 9.3 Time Rift Edge Cases
```javascript
// WRONG: No time check
if (hasTimeRift && !riftUsed) { ... }

// CORRECT: Ensure time >= 2
if (hasTimeRift && !riftUsed && current.time >= 2) { ... }
```

### 9.4 Door-Key Matching
```javascript
// WRONG: Any key opens any door
if (keyMask > 0) { /* can pass door */ }

// CORRECT: Specific key for specific door
const doorIdx = getDoorIndex(r, c);
if (keyMask & (1 << doorIdx)) { /* can pass */ }
```

### 9.5 Visited State Check
```javascript
// WRONG: Only checking existence
if (visited.has(hash)) continue;

// CORRECT: Checking if new path is better
if (visited.has(hash) && visited.get(hash) <= newTime) continue;
```

---

## 10. Extensions and Variations

### 10.1 Multiple Exits
Modify goal condition to check for any exit:
```javascript
if (exits.some(e => e.r === current.r && e.c === current.c) && hasAllGems) {
    return current.time;
}
```

### 10.2 Gem Values (Weighted Collection)
Add value tracking to state and optimize for maximum value:
```javascript
class State {
    // ... existing fields
    this.totalValue = totalValue;
}
```

### 10.3 Moving Obstacles
Expand state to include obstacle positions or time-index the grid:
```javascript
function getCell(r, c, time) {
    // Return cell state at given time
}
```

### 10.4 Bidirectional Search
Search from both start and goal, meeting in the middle:
- Reduces search space from O(b^d) to O(2 × b^(d/2))
- Complex to implement with item collection requirements

### 10.5 A* Heuristic
Admissible heuristic for faster solving:
```javascript
function heuristic(state) {
    // Manhattan distance to nearest uncollected gem + distance to exit
    let minDist = Infinity;
    for (const gem of uncollectedGems(state)) {
        minDist = Math.min(minDist, manhattan(state, gem));
    }
    return minDist + manhattan(nearestUncollected, exit);
}
```

---

## Appendix A: Complete Test Cases

| Test | Description | Expected Time | Key Concept |
|------|-------------|---------------|-------------|
| 1 | Simple path | 6 | Basic pathfinding |
| 2 | Key and door | 8 | Item dependencies |
| 3 | Portal shortcut | 6 | Zero-cost transitions |
| 4 | Laser timing | 6 | Temporal constraints |
| 5 | Multiple gems | 12 | Collection ordering |
| 6 | Time rift | 8 | Negative cost handling |
| 7 | Impossible | -1 | No solution detection |
| 8-10 | Complex | Verify | Combined mechanics |

---

## Appendix B: Pseudocode Summary

```
FUNCTION SolveChallenge2(grid):
    museum ← ParseGrid(grid)
    pq ← MinHeap()
    visited ← HashMap()

    startState ← State(museum.start, time=0, items=empty)
    pq.insert(startState)
    visited[startState.hash()] ← 0

    WHILE pq is not empty:
        current ← pq.extractMin()

        IF visited[current.hash()] < current.time:
            CONTINUE

        IF current.position = museum.exit AND current.hasAllGems():
            RETURN current.time

        FOR each validNeighbor of current:
            neighbor ← CreateNeighborState(current, direction)
            hash ← neighbor.hash()

            IF hash not in visited OR visited[hash] > neighbor.time:
                visited[hash] ← neighbor.time
                pq.insert(neighbor)

        IF current on portal AND portal not used:
            portalState ← CreatePortalState(current)
            // ... same insert logic

        IF current on timeRift AND rift not used AND time ≥ 2:
            riftState ← CreateRiftState(current)
            // ... same insert logic

    RETURN -1  // No solution exists
```

---

## References

1. Dijkstra, E. W. (1959). "A note on two problems in connexion with graphs"
2. Cormen, T. H., et al. "Introduction to Algorithms" - Chapter 24: Single-Source Shortest Paths
3. Russell, S., & Norvig, P. "Artificial Intelligence: A Modern Approach" - Chapter 3: Solving Problems by Searching

---

*Document Version: 1.0*
*Last Updated: February 2026*
