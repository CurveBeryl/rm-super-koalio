class GameLayer < Joybox::Core::Layer
  include Joybox::TMX
  
  def on_enter
    @blue_sky = CCLayerColor.alloc.initWithColor([100, 100, 250, 255])
    self << @blue_sky
    
    @tile_map = TileMap.new file_name: 'level1.tmx'
    self << @tile_map
  end

  def on_exit
    # Tear down
  end

end