Class = require 'class';
push = require 'push';
require 'Paddle';
require 'Ball';

BACK_COLOR = {40/255, 45/255, 52/255, 255/255};
W_WIDTH = 1366;
W_HEIGHT = 768;
V_WIDTH = 432;
V_HEIGHT = 243;
P_SPEED = 200;


function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest');
	love.window.setTitle("pong");
	math.randomseed(os.time());
	
	smallFont = love.graphics.newFont('font.ttf', 8);	--set directory for font
	scoreFont = love.graphics.newFont('font.ttf', 32);

	push:setupScreen(V_WIDTH, V_HEIGHT, W_WIDTH, W_HEIGHT, {
		fullscreen = true,
		resizable = false,
		vsync = true
	});

	player1 = Paddle(10, 30, 5, 20);
	player2 = Paddle(V_WIDTH - 10, V_HEIGHT - 30, 5, 20);
	ball = Ball(V_WIDTH / 2 - 2, V_HEIGHT / 2 - 2, 4, 4);

	p1score = 0;
	p2score = 0;

	gameState = 'start';
end


function love.keypressed(key)
	if key == 'escape' then
		love.event.quit();
	elseif key == 'return'or key == 'enter' then
		if gameState == 'start' then
			gameState = 'play';
		else
			gameState = 'start';
			ball:reset();
		end
	end
end


function love.update(dt)

	if ball.x < 0 then
		p2score = p2score + 1;
		ball:reset();
		gameState = 'start';
	end

	if ball.x > V_WIDTH - 4 then
		p1score = p1score + 1;
		ball:reset();
		gameState = 'start';
	end

	--player 1 movement
	if love.keyboard.isDown('w') then
		player1.dy = -P_SPEED;
	elseif love.keyboard.isDown('s') then
		player1.dy = P_SPEED;
	end

	--player 2 movement
	if love.keyboard.isDown('up') then
		player2.dy = -P_SPEED;
	elseif love.keyboard.isDown('down') then
		player2.dy = P_SPEED;
	end

	if gameState == 'play' then

		if ball:collides(player1) then
			ball.dx = -ball.dx * 1.03;
			ball.x = player1.x + 5;

			if ball.dy < 0 then
				ball.dy = -math.random(10, 150);
			else
				ball.dy = math.random(10, 150);
			end

		end

		if ball:collides(player2) then
			ball.dx = -ball.dx * 1.03;
			ball.x = player2.x - 4;

			if ball.dy < 0 then
				ball.dy = -math.random(10, 150);
			else
				ball.dy = math.random(10, 150);
			end

		end

		if ball.y <= 0 then
			ball.y = 0;
			ball.dy = -ball.dy;
		end

		if ball.y >= V_HEIGHT - 4 then
			ball.y = V_HEIGHT - 4;
			ball.dy = - ball.dy;
		end

		ball:update(dt);

	end

	player1:update(dt);
	player2:update(dt);

end


function love.draw()

	push:apply('start');

	love.graphics.clear(BACK_COLOR);

	displayText();

	player1:render();
	player2:render();
	ball:render();

	displayFPS();

	push:apply('end');

end


function displayFPS()
	love.graphics.setFont(smallFont);
	love.graphics.setColor(0, 255, 0, 255);
	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10);
end


function displayText()

	if gameState == 'start' then
		love.graphics.setFont(smallFont);
		love.graphics.printf('Press \'return\' to start', 0, 20, V_WIDTH, 'center');
	end

	love.graphics.setFont(scoreFont);
	love.graphics.print(p1score, V_WIDTH / 2 - 50, V_HEIGHT / 2 - 50);
	love.graphics.print(p2score, V_WIDTH / 2 + 30, V_HEIGHT / 2 - 50);

end