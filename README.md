# Mouse Click Game

A real-time 2D defence game written in Processing. Enemies spawn from the left and travel toward a goal; the player clicks them to destroy them before they arrive. One enemy reaching the goal ends the game.

Coursework for **6G4Z0020 Programming**, BSc (Hons) Software Engineering, Manchester Metropolitan University.

## How it plays

- Red circles spawn at the left edge at random heights and move steadily toward the green goal.
- Click an enemy to destroy it. The score increases and a replacement spawns, so the pressure stays constant.
- `A` and `D` move the defender left and right along the bottom of the screen.
- If any enemy reaches the goal, the game ends and a game-over message is displayed.

## Design

The sketch is built around three classes, each responsible for its own state, rendering and collision checks:

**`Enemy`** — holds position and speed. `MoveTowards(tx, ty)` computes the vector to the target and normalises it by its own length before applying speed, so enemies travel at a constant rate regardless of where they spawn or how far they have to go. `IsClicked()` and `HitGoal()` return booleans based on distance tests.

**`Defender`** — the player, moved one step at a time along the x-axis with bounds clamping so it can't leave the screen.

**`Goal`** — position and radius, drawn as a circle deliberately placed away from the screen edge so enemies approach from multiple angles.

Enemies live in an `ArrayList` iterated in reverse (`for (int i = enemies.size() - 1; i >= 0; i--)`). Reverse order matters because both the click handler and the draw loop can remove elements mid-iteration — going forwards would shift the remaining elements down and skip one.

Colours, sizes, speeds and the starting enemy count are all declared as constants at the top rather than scattered through the code, so the game can be rebalanced from one place.

## Running it

Install [Processing](https://processing.org/download), open `coursework.pde`, and press Run. No other dependencies.

## Possible extensions

- Multiple enemy types with different speeds and hit sizes
- Increasing difficulty — faster spawns or faster enemies as the score climbs
- Lives, so a single enemy reaching the goal doesn't end the run outright
- A persistent high score between sessions
