--[[
定时器类
@author xianlinli@gmail.com
]]
local Timer = {
    m_scheduler = cc.Director:getInstance():getScheduler(),
    m_timers = {};
}

--[[
启动定时器
@param callback 回调方法
@param interval 间隔
@param runCount 运行次数
@param data 数据
@return timerId
]]
function Timer:start(callback, interval, runCount, data)
    local timerId;
    local onTick = function(dt)
        callback(dt, data, timerId);
        if runCount ~= nil then
            runCount = runCount - 1;
            if runCount <= 0 then -- 达到指定运行次数,杀掉
                self:kill(timerId);
            end
        end
    end
    timerId = self.m_scheduler:scheduleScriptFunc(onTick, interval, false);
    self.m_timers[timerId] = 1;
    return timerId;
end

--[[
启动一个只执行一次的定时器
@param callback 回调方法
@param data 数据
]]
function Timer:runOnce(callback, data)
    self:start(callback, 0, 1, data);
end

--[[
杀掉指定定时器
@param timerId 定时器ID
]]
function Timer:kill(timerId)
    self.m_scheduler:unscheduleScriptEntry(timerId);
    self.m_timers[timerId] = nil;
end

--[[
杀掉所有定时器
]]
function Timer:killAll()
    for timerId, flag in pairs(self.m_timers) do
        self:kill(timerId);
    end
end

return Timer;
