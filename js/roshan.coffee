# Matter aliases
Engine = Matter.Engine
Gui = Matter.Gui
World = Matter.World
Bodies = Matter.Bodies
Body = Matter.Body
Composite = Matter.Composite
Composites = Matter.Composites
Common = Matter.Common
Constraint = Matter.Constraint
MouseConstraint = Matter.MouseConstraint
Game = {}
_engine = undefined
_sceneName = "mixed"
_sceneWidth = undefined
_sceneHeight = undefined
Game.init = ->
  canvasContainer = document.getElementById("canvas-container")
  demoStart = document.getElementById("start")
  demoStart.addEventListener "click", ->
    demoStart.style.display = "none"
    _engine = Engine.create(canvasContainer,
#      render:
#        options:
#          wireframes: true
#          showAngleIndicator: true
#          showDebug: true
    )
    Game.fullscreen()
    setTimeout (->
      Engine.run _engine
      Game.updateScene()
      return
    ), 800

#  window.addEventListener "deviceorientation", Game.updateGravity, true
  window.addEventListener "touchstart", Game.fullscreen
  window.addEventListener "touchstart", Game.action
#  window.addEventListener "orientationchange", (->
#    Game.updateGravity()
#    Game.updateScene()
#    Game.fullscreen()
#    return
#  ), false

window.addEventListener "load", Game.init
Game.mixed = ->
  Game.reset()

Game.action = ->
  World.add _engine.world, Composites.stack 0, 0, 1, 1, 0, 0, (x, y, column, row) ->
    Bodies.rectangle _sceneWidth * 0.5 - 20, 0, 40, 40,
      friction: 0.01
      restitution: 0.4

Game.updateScene = ->
  return  unless _engine
  _sceneWidth = document.documentElement.clientWidth
  _sceneHeight = document.documentElement.clientHeight
  boundsMax = _engine.world.bounds.max
  renderOptions = _engine.render.options
  canvas = _engine.render.canvas
  boundsMax.x = _sceneWidth
  boundsMax.y = _sceneHeight
  canvas.width = renderOptions.width = _sceneWidth
  canvas.height = renderOptions.height = _sceneHeight
  Game[_sceneName]()

Game.updateGravity = ->
  return  unless _engine
  orientation = window.orientation
  gravity = _engine.world.gravity
  if orientation is 0
    gravity.x = Common.clamp(event.gamma, -90, 90) / 90
    gravity.y = Common.clamp(event.beta, -90, 90) / 90
  else if orientation is 180
    gravity.x = Common.clamp(event.gamma, -90, 90) / 90
    gravity.y = Common.clamp(-event.beta, -90, 90) / 90
  else if orientation is 90
    gravity.x = Common.clamp(event.beta, -90, 90) / 90
    gravity.y = Common.clamp(-event.gamma, -90, 90) / 90
  else if orientation is -90
    gravity.x = Common.clamp(-event.beta, -90, 90) / 90
    gravity.y = Common.clamp(event.gamma, -90, 90) / 90
Game.fullscreen = ->
  _fullscreenElement = _engine.render.canvas
  if not document.fullscreenElement and not document.mozFullScreenElement and not document.webkitFullscreenElement
    if _fullscreenElement.requestFullscreen
      _fullscreenElement.requestFullscreen()
    else if _fullscreenElement.mozRequestFullScreen
      _fullscreenElement.mozRequestFullScreen()
    else _fullscreenElement.webkitRequestFullscreen Element.ALLOW_KEYBOARD_INPUT  if _fullscreenElement.webkitRequestFullscreen

Game.reset = ->
  _world = _engine.world
  Common._seed = 2
  World.clear _world
  Engine.clear _engine
  offset = 5
  World.addBody _world, Bodies.rectangle(_sceneWidth * 0.5, -offset, _sceneWidth + 0.5, 50.5,
    isStatic: true
  )
  World.addBody _world, Bodies.rectangle(_sceneWidth * 0.5, _sceneHeight + offset, _sceneWidth + 0.5, 50.5,
    isStatic: true
  )
  World.addBody _world, Bodies.rectangle(_sceneWidth + offset, _sceneHeight * 0.5, 50.5, _sceneHeight + 0.5,
    isStatic: true
  )
  World.addBody _world, Bodies.rectangle(-offset, _sceneHeight * 0.5, 50.5, _sceneHeight + 0.5,
    isStatic: true
  )