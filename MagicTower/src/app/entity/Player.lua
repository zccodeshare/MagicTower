local Person = require("app.entity.Person");

local Player = class("Player",Person);

function Player:ctor()
	Player.super:ctor();

	self.m_upPlayerFile = "actor_up";
	self.m_downPlayerFile = "actor_down";
	self.m_leftPlayerFile = "actor_left";
	self.m_rightPlayerFile = "actor_right";

	self.m_upId = 1;
	self.m_rightId = 1;
	self.m_downId = 1;
	self.m_leftId = 1;

	self.m_spriteX = 0;
	self.m_spriteY = 0;
	self.m_spriteW = 0;
	self.m_spriteH = 0;

	self.m_isPlaying = false; -- 是否在动

	self.m_moveTime = 0.5; -- 移动时间

	self.m_direction = "up"; -- 向上
end

-- 帧动画
function Player:show(x,y,anchorX,anchorY,root,direction)
	self.m_spriteX = x;
	self.m_spriteY = y;

	if direction == "left" then 
		self.m_sprite = display.newSprite("actors/" .. self.m_leftPlayerFile .. self.m_leftId .. ".png");
		self.m_leftId = self.m_leftId + 1;

	elseif direction == "right" then 
		self.m_sprite = display.newSprite("actors/" .. self.m_rightPlayerFile .. self.m_rightId .. ".png");
		self.m_rightId = self.m_rightId + 1;				

	elseif direction == "up" then 
		self.m_sprite = display.newSprite("actors/" .. self.m_upPlayerFile .. self.m_upId .. ".png");
		self.m_upId = self.m_upId + 1;

	elseif direction == "down" then 
		self.m_sprite = display.newSprite("actors/" .. self.m_downPlayerFile .. self.m_downId .. ".png");
		self.m_downId = self.m_downId + 1;
	end

	self.m_sprite:setAnchorPoint(anchorX,anchorY);
	self.m_sprite:pos(x,y);
	self.m_sprite:addTo(root);

	self.m_spriteW = self.m_sprite:getContentSize().width;
	self.m_spriteH = self.m_sprite:getContentSize().height;

	self.m_direction = direction;

	return self.m_sprite;
end


function Player:getWidth()
	return self.m_spriteW;
end

function Player:getHeight()
	return self.m_spriteH;
end

function Player:getWidthHeight()
	return self.m_spriteW,self.m_spriteH;
end

function Player:getCurrentPos()
	return self.m_spriteX,self.m_spriteY;
end

function Player:onLeftClick()
	if self.m_isPlaying then 
		return;
	end
	self.m_isPlaying = true;

	if (self.m_rightId % 2 ~= 0) and self.m_direction == "right" or 
	   (self.m_upId % 2 ~= 0)    and self.m_direction == "up" or 
	   (self.m_downId % 2 ~= 0)  and self.m_direction == "down" then 
		self.m_leftId = 1;

	elseif self.m_direction ~= "left" then 
		self.m_leftId = 2;
	end

	self.m_direction = "left";

	local action = cc.MoveBy:create(self.m_moveTime,cc.p(-self.m_spriteW,0));

	self.m_spriteX = self.m_spriteX - self.m_spriteW;

	self.m_sprite:setTexture("actors/" .. self.m_leftPlayerFile .. self.m_leftId .. ".png");
	local callFunc = cc.CallFunc:create(function()
		self.m_leftId = self.m_leftId + 1;
		if self.m_leftId > 4 then 
			self.m_leftId = 1;
		end
		self.m_isPlaying = false;
	end);
	self.m_sprite:runAction(cc.Sequence:create(action,callFunc));

end

function Player:onRightClick()
	if self.m_isPlaying then 
		return;
	end

	self.m_isPlaying = true;

	if (self.m_leftId % 2 ~= 0) and self.m_direction == "left" or 
		(self.m_upId % 2 ~= 0)  and self.m_direction == "up" or 
		(self.m_downId % 2 ~= 0) and self.m_direction == "down" then 
		self.m_rightId = 1;

	elseif self.m_direction ~= "right" then 
		self.m_rightId = 2;
	end

	self.m_direction = "right";
	local action = cc.MoveBy:create(self.m_moveTime,cc.p(self.m_spriteW,0));

	self.m_spriteX = self.m_spriteX + self.m_spriteW;

	self.m_sprite:setTexture("actors/" .. self.m_rightPlayerFile .. self.m_rightId .. ".png");
	local callFunc = cc.CallFunc:create(function()
		self.m_rightId = self.m_rightId + 1;
		if self.m_rightId > 4 then 
			self.m_rightId = 1;
		end
		self.m_isPlaying = false;
	end);
	self.m_sprite:runAction(cc.Sequence:create(action,callFunc));
end

function Player:onUpClick()
	if self.m_isPlaying then
		return;
	end
	self.m_isPlaying = true;

	if (self.m_leftId % 2 ~= 0) and self.m_direction == "left" or 
		(self.m_rightId % 2 ~= 0) and self.m_direction == "right" or 
		(self.m_downId % 2 ~= 0) and self.m_direction == "down" then 
		self.m_upId = 1;

	elseif self.m_direction ~= "up" then 
		self.m_upId = 2;
	end

	self.m_direction = "up";
	local action = cc.MoveBy:create(self.m_moveTime,cc.p(0,self.m_spriteH));

	self.m_spriteY = self.m_spriteY + self.m_spriteH;

	self.m_sprite:setTexture("actors/" .. self.m_upPlayerFile .. self.m_upId .. ".png");
	local callFunc = cc.CallFunc:create(function()
		self.m_upId = self.m_upId + 1;
		if self.m_upId > 4 then 
			self.m_upId = 1;
		end
		self.m_isPlaying = false;
	end);
	self.m_sprite:runAction(cc.Sequence:create(action,callFunc));
end

function Player:onDownClick()
	if self.m_isPlaying then 
		return;
	end
	self.m_isPlaying = true;

	if (self.m_leftId % 2 ~= 0) and self.m_direction == "left" or 
		(self.m_rightId % 2 ~= 0) and self.m_direction == "right" or 
		(self.m_upId % 2 ~= 0) and self.m_direction == "up" then 
		self.m_downId = 1;

	elseif self.m_direction ~= "down" then 
		self.m_downId = 2;
	end

	self.m_direction = "down";
	local action = cc.MoveBy:create(self.m_moveTime,cc.p(0,-self.m_spriteH));

	self.m_spriteY = self.m_spriteY - self.m_spriteH;

	self.m_sprite:setTexture("actors/" .. self.m_downPlayerFile .. self.m_downId .. ".png");
	local callFunc = cc.CallFunc:create(function()
		self.m_downId = self.m_downId + 1;
		if self.m_downId > 4 then 
			self.m_downId = 1;
		end
		self.m_isPlaying = false;
	end);
	self.m_sprite:runAction(cc.Sequence:create(action,callFunc));
end

function Player:clearAllDirections()
	

end

return Player;	