class GameLayer < Joybox::Core::Layer
  include Joybox::TMX
  
  scene

  def on_enter
    SimpleAudioEngine.sharedEngine.playBackgroundMusic "level1.mp3"
    
    @world = World.new(gravity: [0, -9.8])
    
    @blue_sky = LayerColor.new color: "#6365fc".to_color
    self << @blue_sky
    
    @tile_map = TileMap.new file_name: 'level1.tmx'
    self << @tile_map
    
    @walls = @tile_map.tile_layers['walls']
    walls_layer_size = @walls.layerSize

    (0..walls_layer_size.height - 1).each do |y|
      (0..walls_layer_size.width - 1).each do |x|
        tile = @walls.tileAt([x, y])
        create_rectangular_fixture(@walls, x, y) if tile 
      end
    end
    
    @player = PlayerSprite.new(@world)
    @tile_map.add_child @player, 15
    
    @hazards = @tile_map.tile_layers['hazards']
    @hazard_tiles = []
    hazards_layer_size = @hazards.layerSize

    (0..hazards_layer_size.height - 1).each do |y|
      (0..hazards_layer_size.width - 1).each do |x|
        tile = @hazards.tileAt([x, y])
        @hazard_tiles << create_rectangular_fixture(@walls, x, y) if tile 
      end
    end   
    
    @world.when_collide @player do |collision_sprite, is_touching|
      if @hazard_tiles.include? collision_sprite
        @player.die
      end
    end 
    
    schedule_update do |delta|
      if @player.alive?
        @world.step delta: delta
        @player.move_forward if @moving 
        set_viewpoint_center(@player.position)
      end
    end
    
    screen_width = Screen.width

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
  
  def set_viewpoint_center(position)
    x = [position.x, Screen.width / 2].max
    y = [position.y, Screen.height / 2].max
    x = [x, (@tile_map.mapSize.width * @tile_map.tileSize.width) - Screen.half_width].min
    y = [y, (@tile_map.mapSize.height * @tile_map.tileSize.height) - Screen.half_height].min

    viewPoint = Screen.center - [x, y].to_point
    @tile_map.position = viewPoint
  end

end