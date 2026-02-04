# Challenge 2

An algorithm challenge implementing pathfinding with state compression, bit manipulation, and priority queues.

## Overview

Navigate through a grid-based puzzle to collect all gems and reach the exit in minimum time while handling obstacles like doors, lasers, portals, and time rifts.

## Quick Start

```bash
# Run interactive mode
npm start

# Run demo
npm run demo

# Run all tests
npm run test
```

Or directly with Node.js:
```bash
node quantum-heist.js           # Interactive mode
node quantum-heist.js --demo    # Demo puzzle
node quantum-heist.js --test    # All tests
node quantum-heist.js --help    # Help
```

## Grid Elements

| Symbol | Element | Description |
|--------|---------|-------------|
| `S` | Start | Starting position |
| `E` | Exit | Goal (must have all gems) |
| `G` | Gem | Collectible (must get all) |
| `K` | Key | Unlocks matching door |
| `D` | Door | Requires corresponding key |
| `P` | Portal | Teleport to paired portal (0 time, single use per pair) |
| `L` | Laser | Blocks when time % 3 == 0 |
| `T` | Time Rift | Rewind 2 time units (single use) |
| `#` | Wall | Impassable |
| `.` | Empty | Free space |

## Movement Rules

- **Basic movement:** Up, Down, Left, Right - costs 1 time unit each
- **Portal:** Instant teleport - costs 0 time units
- **Time Rift:** Subtracts 2 from current time

## Algorithm

Uses Dijkstra's algorithm with:
- **State compression** via bitmasks for collected items
- **Min-heap priority queue** for optimal path selection
- **Multi-dimensional state space** tracking position, items, and resources

### Complexity

- **Time:** O(R × C × 2^(G+K+P) × log(states))
- **Space:** O(R × C × 2^(G+K+P))

Where R=rows, C=columns, G=gems, K=keys, P=portal pairs

## Project Structure

```
├── quantum-heist.js      # Main program
├── package.json          # NPM configuration
├── run-demo.ps1          # PowerShell runner
├── run-demo.sh           # Shell runner
├── EVALUATION_TEMPLATE.md # Grading rubric
├── SOLUTION_GUIDE.md     # Detailed solution guide
└── README.md             # This file
```

## Test Cases

| Test | Description | Expected |
|------|-------------|----------|
| 1 | Simple path | 6 |
| 2 | Key and door | 8 |
| 3 | Portal shortcut | 6 |
| 4 | Laser timing | 6 |
| 5 | Multiple gems | 12 |
| 6 | Time rift | 8 |
| 7 | Impossible | -1 |
| 8-10 | Complex | Verify |

## Requirements

- Node.js >= 14.0.0

## License

MIT
