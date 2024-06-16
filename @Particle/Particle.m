classdef ( Abstract ) Particle < handle & matlab.mixin.Heterogeneous

properties ( Constant )
    terminalSpeed = 299792458; % speed of light, m/s
end

methods ( Abstract )
    setAcceleration( obj, Fx, Fy );
    tick( obj, s ); % s - seconds
    getPosition( obj );
    setPosition( obj, x, y );
    getSpeed( obj );
    setSpeed( obj, vx, vy );
end

end

