def invoke_command(action, args)
  $logger.info "#{Maze::Server.commands.remaining.size} commands before"
  Maze::Server.commands.add({ action: action, args: args })
  Maze.driver.click_element :execute_command
  # Ensure fixture has read the command
  count = 100
  sleep 0.1 until Maze::Server.commands.remaining.empty? || (count -= 1) < 1
  $logger.info "#{Maze::Server.commands.remaining.size} commands after"
  Maze::Server.commands.remaining.empty?
end

Maze.hooks.pre_complete do |scenario|
  $logger.info 'Issuing clearPersistentData command'
  unless invoke_command('invoke_method', ['clearPersistentData'])
    $logger.info 'Mark as failed'
    Maze.scenario.mark_as_failed 'Fixture failed to GET clearPersistentData command - did it crash?'
  end
end
