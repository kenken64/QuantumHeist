# Challenge 2 - Evaluation Template

## Student Information
| Field | Details |
|-------|---------|
| Student Name | |
| Student ID | |
| Submission Date | |
| Evaluator | |

---

## 1. Algorithm Design & Implementation

### 1.1 Core Algorithm Selection
| Criteria | Comments |
|----------|----------|
| Appropriate algorithm choice (BFS/Dijkstra/A*) | |
| Justification for algorithm selection | |
| Understanding of graph traversal concepts | |

### 1.2 State Representation
| Criteria | Comments |
|----------|----------|
| Position tracking (row, column) | |
| Time/cost tracking | |
| Collected items tracking (gems, keys) | |
| Used resources tracking (portals, time rift) | |
| State uniqueness/hashing implementation | |

### 1.3 State Space Management
| Criteria | Comments |
|----------|----------|
| Efficient visited state tracking | |
| Proper state transitions | |
| Handling of all game elements | |

---

## 2. Data Structures

### 2.1 Priority Queue / Heap
| Criteria | Comments |
|----------|----------|
| Correct implementation of min-heap | |
| Proper insert operation (bubble up) | |
| Proper extract operation (bubble down) | |
| Time complexity adherence O(log n) | |

### 2.2 Bit Manipulation
| Criteria | Comments |
|----------|----------|
| Use of bitmasks for state compression | |
| Correct bitwise operations (AND, OR, shift) | |
| Efficient memory usage | |

### 2.3 Map/Set Usage
| Criteria | Comments |
|----------|----------|
| Appropriate use of hash maps | |
| Efficient lookup operations | |
| Proper key design for memoization | |

---

## 3. Game Mechanics Implementation

### 3.1 Basic Movement
| Criteria | Comments |
|----------|----------|
| Four-directional movement | |
| Boundary checking | |
| Wall collision detection | |
| Time cost per move (1 unit) | |

### 3.2 Collectibles
| Criteria | Comments |
|----------|----------|
| Gem collection logic | |
| Key collection logic | |
| Win condition (all gems + exit) | |

### 3.3 Special Elements
| Criteria | Comments |
|----------|----------|
| Door mechanics (key requirement) | |
| Portal teleportation (0 time cost) | |
| Portal pairing logic | |
| Portal single-use constraint | |
| Laser timing (time % 3 == 0) | |
| Time rift implementation (-2 time) | |
| Time rift single-use constraint | |

---

## 4. Code Quality

### 4.1 Structure & Organization
| Criteria | Comments |
|----------|----------|
| Modular design | |
| Function decomposition | |
| Separation of concerns | |
| File organization | |

### 4.2 Readability
| Criteria | Comments |
|----------|----------|
| Meaningful variable names | |
| Consistent naming conventions | |
| Appropriate comments | |
| Code formatting | |

### 4.3 Error Handling
| Criteria | Comments |
|----------|----------|
| Input validation | |
| Edge case handling | |
| Graceful failure modes | |
| Missing start/exit detection | |

---

## 5. Complexity Analysis

### 5.1 Time Complexity
| Criteria | Comments |
|----------|----------|
| Correct analysis provided | |
| Understanding of state space size | |
| Priority queue operation costs | |
| Overall complexity calculation | |

**Expected:** O(R × C × 2^(G+K+P) × log(states))

### 5.2 Space Complexity
| Criteria | Comments |
|----------|----------|
| Visited map space analysis | |
| Priority queue space analysis | |
| Overall space calculation | |

**Expected:** O(R × C × 2^(G+K+P))

---

## 6. Testing & Correctness

### 6.1 Test Case Results
| Test Case | Expected | Actual | Pass/Fail |
|-----------|----------|--------|-----------|
| Test 1: Simple Path | 6 | | |
| Test 2: Key and Door | 8 | | |
| Test 3: Portal Shortcut | 6 | | |
| Test 4: Laser Timing | 6 | | |
| Test 5: Multiple Gems | 12 | | |
| Test 6: Time Rift | 8 | | |
| Test 7: Impossible | -1 | | |
| Test 8: Complex | verify | | |
| Test 9: Laser Field | verify | | |
| Test 10: Portal Chain | verify | | |

### 6.2 Edge Cases
| Criteria | Comments |
|----------|----------|
| Empty grid handling | |
| No gems scenario | |
| Blocked paths | |
| Multiple optimal paths | |

---

## 7. Performance

### 7.1 Execution Metrics
| Test Case | Execution Time | States Explored |
|-----------|---------------|-----------------|
| Simple tests | | |
| Complex tests | | |
| Demo puzzle | | |

### 7.2 Optimization
| Criteria | Comments |
|----------|----------|
| Pruning strategies | |
| Early termination | |
| Memory efficiency | |

---

## 8. Documentation

### 8.1 Code Documentation
| Criteria | Comments |
|----------|----------|
| Function documentation | |
| Algorithm explanation | |
| Complexity annotations | |

### 8.2 External Documentation
| Criteria | Comments |
|----------|----------|
| README provided | |
| Usage instructions | |
| Design decisions explained | |

---

## Summary

### Strengths
1.
2.
3.

### Areas for Improvement
1.
2.
3.

### Additional Comments


---

## Grade Breakdown

| Section | Weight | Score |
|---------|--------|-------|
| 1. Algorithm Design | /25 | |
| 2. Data Structures | /20 | |
| 3. Game Mechanics | /20 | |
| 4. Code Quality | /15 | |
| 5. Complexity Analysis | /10 | |
| 6. Testing & Correctness | /5 | |
| 7. Performance | /3 | |
| 8. Documentation | /2 | |
| **Total** | **/100** | |

---

*Evaluation completed on: ________________*

*Evaluator signature: ________________*
