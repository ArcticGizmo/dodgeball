# Ball Handling
- add ability to pick up ball (as item for now)
- add ability to catch ball (secondary action - rather than reflect)
- add ability to return the ball (primary action)
- prevent you from being able to catch your own ball immediately after throwing it
- if the ball hits the player
    - ball is destroyed and replaced
    - player is destroyed
    - player spawned back after 2 seconds

- make a ball dangerous only if it is above a certain speed
- add ability to pick up a ball that is moving slowly

# Ball Physics
- adjust bounce and friction to make ti feel more ball like


# catchable projectiles
- create base class for catchable projectiles
- ability to set owner id


# Test Enemy
- make it reflect the ball back towards the player
    - add random variation 


# Mechanics
- return thrown ball
- ability to catch
- holding balls/items can reflect/deflect attacks


# Idea
- per game, players are given a random set of hats to pick from (and have to run to get them)
- ability to throw entities on a funny path
- have a bomerang ball
    - can be done by setting a high initial speed with a retarding force (should stop after collision with anything)