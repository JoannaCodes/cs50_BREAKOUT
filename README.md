# cs50_BREAKOUT

<H3> assignment2 </H3>
  Remake of Breakout from Harvard's CS50's Introduction to Game Development Online Course.
 
<H3> Specifications </H3>
  <p>1. Add a Powerup class to the game that spawns a powerup (images located at the bottom of the sprite sheet in the distribution code). This Powerup should spawn randomly, be it on a timer or when the Ball hits a Block enough times, and gradually descend toward the player. Once collided with the Paddle, two more Balls should spawn and behave identically to the original, including all collision and scoring points for the player. Once the player wins and proceeds to the VictoryState for their current level, the Balls should reset so that there is only one active again.</p>
  <p>2. Grow and shrink the Paddle such that it’s no longer just one fixed size forever. In particular, the Paddle should shrink if the player loses a heart (but no smaller of course than the smallest paddle size) and should grow if the player exceeds a certain amount of score (but no larger than the largest Paddle). This may not make the game completely balanced once the Paddle is sufficiently large, but it will be a great way to get comfortable interacting with Quads and all of the tables we have allocated for them in main.lua!</p>
  <p>3. Add a locked Brick (located in the sprite sheet) to the level spawning, as well as a key powerup (also in the sprite sheet). The locked Brick should not be breakable by the ball normally, unless they of course have the key Powerup! The key Powerup should spawn randomly just like the Ball Powerup and descend toward the bottom of the screen just the same, where the Paddle has the chance to collide with it and pick it up. You’ll need to take a closer look at the LevelMaker class to see how we could implement the locked Brick into the level generation. Not every level needs to have locked Bricks; just include them occasionally! Perhaps make them worth a lot more points as well in order to compel their design. Note that this feature will require changes to several parts of the code, including even splitting up the sprite sheet into Bricks!</p>
 
<H5>
<p>URL: https://cs50.harvard.edu/games/2018/projects/2/breakout/</p>


Code Location: cs50_BREAKOUT
<p>MULTIBALL POWER UP --> PLAYSTATE: Line 35, 44-45, 91-103, 275-285 changes -> Line 130, 134, 158, 341</p>
<p>                   --> VICTORYSTATE: Line 32-33,54 changes -> Line 130, 134, 158, 341</p>

<p>PADDLE SHRINK AND GROW --> PLAYSTATE: Line 367-390, 195-204, 308</p>

<p>LOCKBRICK and KEY POWER UP --> LEVELMAKER: Line 118-122</p>
<p>                           --> BRICK: Line 56, 95, 100-116, 181</p>
<p>                           --> PLAYSTATE: Line 56, 105-109, 163-182, 181</p>
 
