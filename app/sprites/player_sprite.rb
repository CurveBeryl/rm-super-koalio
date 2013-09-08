class PlayerSprite < Joybox::Physics::PhysicsSprite
  
  def initialize(world)
    @player_body = world.new_body(
      position: [16*1, 16*8],
      type: KDynamicBodyType
    ) do
      polygon_fixture(
        box: [18, 26],
        friction: 0.7,
        density: 1.0
      )
    end
    super file_name: 'koalio_stand.png', body: @player_body
  end

  def on_enter
    # Set up
  end

  def on_exit
    # Tear down
  end

end