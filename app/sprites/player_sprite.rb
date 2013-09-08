class PlayerSprite < Joybox::Core::Sprite
  
  def initialize
    super file_name: 'koalio_stand.png', position: [100, 50]
  end

  def on_enter
    # Set up
  end

  def on_exit
    # Tear down
  end

end