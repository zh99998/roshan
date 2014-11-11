# Matter aliases
Engine = Matter.Engine
World = Matter.World
Bodies = Matter.Bodies
Body = Matter.Body
Composite = Matter.Composite
Composites = Matter.Composites
Common = Matter.Common
Constraint = Matter.Constraint
RenderPixi = Matter.RenderPixi
Events = Matter.Events
Bounds = Matter.Bounds
Vector = Matter.Vector
Vertices = Matter.Vertices
MouseConstraint = Matter.MouseConstraint
Mouse = Matter.Mouse
Query = Matter.Query

Game = {}
_engine = undefined
_sceneName = "mixed"
_sceneWidth = undefined
_sceneHeight = undefined
_sceneEvents = []
_isMobile = /(ipad|iphone|ipod|android)/gi.test(navigator.userAgent);
Game.init = ->
  canvasContainer = document.getElementById("canvas-container")
  GameStart = document.getElementById("start")
  GameStart.addEventListener "click", ->
    GameStart.style.display = "none"
    _engine = Engine.create canvasContainer,
      render:
        options:
          wireframes: false
#          showAngleIndicator: true
#          showDebug: true
    if (_isMobile)
      Game.fullscreen()
      new FastButton window, Game.fullscreen

    setTimeout ->
      Engine.run _engine
      Game.updateScene()
    , 800

    new FastButton window, Game.action
      #  window.addEventListener "deviceorientation", Game.updateGravity, true
#  window.addEventListener "orientationchange", (->
#    Game.updateGravity()
#    Game.updateScene()
#    Game.fullscreen()
#    return
#  ), false

Game.mixed = ->
  Game.reset()
  roshan = Bodies.rectangle 100, _sceneHeight - 50, 200, 100,
    friction: 0.01
    restitution: 0.4
  bottom = Bodies.rectangle 100, _sceneHeight, 200, 1,
    isStatic: true

  #direction = true
  _sceneEvents.push Events.on _engine, "tick", (event)->
    roshan.position.x = _sceneWidth / 2 + 100 * Math.sin(_engine.timing.timestamp * 0.001)
    Body.translate bottom, x: roshan.position.x - bottom.position.x, y: 0


#    if direction
#      Body.translate roshan, x: 1, y: 0
#      if roshan.position.x >= _sceneWidth - 100
#        direction = false
#    else
#      Body.translate roshan, x: -1, y: 0
#      if roshan.position.x <= 100
#        direction = true


    #
    #roshan.setStatic true
    #Body.applyGravityAll([roshan], { x: 0, y: -1 })

  World.add _engine.world, roshan
  World.add _engine.world, bottom


Game.action = ->
  World.add _engine.world, Bodies.rectangle _sceneWidth * 0.5, 0, 61, 52,
    friction: 0.01
    restitution: 0.4
    render:
      sprite:
        texture: './img/block/0.png'


Game.updateScene = ->
  return unless _engine
  if _isMobile
    _sceneWidth = document.documentElement.clientWidth
    _sceneHeight = document.documentElement.clientHeight
  else
    _sceneWidth = 500
    _sceneHeight = 500
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
#  offset = 5
#  World.addBody _world, Bodies.rectangle(_sceneWidth * 0.5, -offset, _sceneWidth + 0.5, 50.5,
#    isStatic: true
#  )
#  World.addBody _world, Bodies.rectangle(_sceneWidth * 0.5, _sceneHeight + offset, _sceneWidth + 0.5, 50.5,
#    isStatic: true
#  )
#  World.addBody _world, Bodies.rectangle(_sceneWidth + offset, _sceneHeight * 0.5, 50.5, _sceneHeight + 0.5,
#    isStatic: true
#  )
#  World.addBody _world, Bodies.rectangle(-offset, _sceneHeight * 0.5, 50.5, _sceneHeight + 0.5,
#    isStatic: true
#  )

Game.init()