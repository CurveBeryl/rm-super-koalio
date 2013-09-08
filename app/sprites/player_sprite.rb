class PlayerSprite < Joybox::Physics::PhysicsSprite
  
  def initialize(world)
    body = world.new_body position: [100, 50], type: KDynamicBodyType
    super file_name: 'koalio_stand.png', body: body
  end

  def on_enter
    # Set up
  end

  def on_exit
    # Tear down
  end

end