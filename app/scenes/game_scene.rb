class GameScene < Joybox::Core::Scene

  def on_enter
    self << GameLayer.new
  end

  def on_exit
    # Tear down
  end

end