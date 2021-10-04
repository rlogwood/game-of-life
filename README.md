# Conway's Game of Life Simulation

Following the rules  [outlined in wikipedia](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life), this ruby implemetation uses the [ruby2d gem](https://www.ruby2d.com/) with graph paper background having 20 rows and 30 columns and multicolored squares.

The game starts off with a random board and will continue until there are no state changes or it will loop if the state changes repeat in a cycle, until you right click anywhere or press any key. If it reaches a state where there are no changes a new random board is created and the simulation begins again.

You can also press any key or right click at any time to generate a new random board.

**Running the program `ruby gol.rb`**

