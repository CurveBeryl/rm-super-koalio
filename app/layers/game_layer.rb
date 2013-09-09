class GameLayer < Joybox::Core::Layer
  include Joybox::TMX
  
  scene

  def on_enter
    @world = World.new(gravity: [0, -9.8])
    
    @blue_sky = LayerColor.new color: "#6365fc".to_color
    self << @blue_sky
    
    @tile_map = TileMap.new file_name: 'level1.tmx'
    self << @tile_map
    
    @walls = @tile_map.tile_layers['walls']
    _tileSize = @walls.tileset.tileSize
    _layerSize = @walls.layerSize

    (0.._layerSize.height - 1).each do |y|
      (0.._layerSize.width - 1).each do |x|
        tile = @walls.tileAt([x, y])
        create_rectangular_fixture(@walls, x, y) if tile 
      end
    end
    
    @player = PlayerSprite.new(@world)
    @tile_map.add_child @player, 15
    
    schedule_update do |delta|
      @world.step delta: delta
      @player.move_forward if @moving 
    end
    
    screen_width = Director.sharedDirector.winSize.width

    on_touches_began do |touches, event|
      touches.each do |touch|
        location = touch.locationInView(touch.view)
        location.x > (screen_width / 2) ? (@moving = true) : @player.jump  
      end
    end
    
    on_touches_ended do |touches, event|
      touches.each do |touch|
        @moving = false
      end
    end
    
  end

  def on_exit
    # Tear down
  end
  
  def create_rectangular_fixture(layer, x, y)
    p = layer.positionAt [x, y]
    tw = layer.tileset.tileSize.width
    th = layer.tileset.tileSize.height

    # create the body, define the shape and create the fixture
    body = @world.new_body(
      position: [p.x, p.y - th], 
      type: Body::Static) do
        polygon_fixture box: [tw, th],
                        density: 1.0,
                        friction: 0.3,
                        restitution: 0.0
    end
  end

end