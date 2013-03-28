class Engine
  
  def self.run(game)

    winner=false
    dice = Dice.new(2)

    player = game.first_player

    100.times do
      dice.roll!

      player.advance(dice.total) do |tile|
        if tile.name == "Go"
          player.receive_funds(200)
          puts "#{player.name} passes Go and receives 200"
        end
      end

      tile = player.tile

      puts "#{player.name} moves #{dice.total} to #{tile.name}"

      begin
        if tile.buyable?
          if tile.available?
            player.buy tile
            puts "#{player.name} buys #{tile.name}; new balance #{player.balance}"
          else
            if tile.owner == player
              puts "#{player.name} owns #{tile.name}"
            else
              begin
                player.pay_rent tile
              rescue
                puts "#{player.name} is bankrupt!"
                winner = tile.owner
                break
              end
              puts "#{player.name} pays #{tile.owner.name} #{tile.calculate_rent} for rent on #{tile.name}"
            end
          end
        end

      rescue RuntimeError => e
        puts e.message
      end
      player = player.next
    end

    puts "#{winner.name} wins" if winner
  end

end