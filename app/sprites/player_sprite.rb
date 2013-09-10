class PlayerSprite < Joybox::Physics::PhysicsSprite
  
  def initialize(world)
    @world = world
    @player_body = @world.new_body(
      position: [16*1, 16*8],
      type: Body::Dynamic,
      fixed_rotation: true
    ) do
      polygon_fixture(
        box: [18, 26],
        friction: 0.7,
        density: 1.0
      )
    end
    super file_name: 'koalio_stand.png', body: @player_body
    @alive = true
  end
  
  def move_forward
    if alive?
      self.body.apply_force force:[10, 0], as_impulse: true
    end
  end
  
  def jump
    if alive?
      SimpleAudioEngine.sharedEngine.playEffect 'jump.wav'
      self.body.apply_force force:[0, 250]
    end
  end
  
  def die
    @alive = false
    self.run_action Blink.with times:10
    SimpleAudioEngine.sharedEngine.playEffect 'hurt.wav'
    SimpleAudioEngine.sharedEngine.pauseBackgroundMusic
  end
  
  def alive?
    @alive
  end

  def on_enter
    # Set up
  end

  def on_exit
    # Tear down
  end

end