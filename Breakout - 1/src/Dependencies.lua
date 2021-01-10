--Update: require 'src/Util', require 'src/Paddle', require 'src/states/PlayState','src/Bricks',
--'src/LevelMaker'
--Libraries
push = require 'lib/push'

Class = require 'lib/class'

--Source
require 'src/constants'

require 'src/Util'

--Sprites
require 'src/Paddle'
require 'src/Ball'

--State Machine
require 'src/StateMachine'

require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/PlayState'