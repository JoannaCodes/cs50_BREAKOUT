--Update: require 'src/states/EnterHighScoreState' and require 'src/states/PaddleSelectState'
--Libraries
push = require 'lib/push'

Class = require 'lib/class'

--Source
require 'src/constants'

require 'src/Util'

--Sprites
require 'src/Paddle'
require 'src/Ball'
require 'src/Brick'

--State Machine
require 'src/StateMachine'
require 'src/LevelMaker'

require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/ServeState'
require 'src/states/PlayState'
require 'src/states/GameOverState'
require 'src/states/VictoryState'
require 'src/states/HighScoreState'
require 'src/states/EnterHighScoreState'
require 'src/states/PaddleSelectState'