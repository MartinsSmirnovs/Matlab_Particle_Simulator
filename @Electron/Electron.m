classdef Electron < Particle

properties ( Access = private )
    x, y; % coordinates
    vx, vy; % speed components of coordinates, m/s
    avx, avy; % acceleration components of speed, m/s^2
end

properties ( Constant )
    m = 9.1093837e-31; % kg
end

methods
    function obj = Electron( x, y, vx, vy ) % s - seconds
        obj.x = x;
        obj.y = y;
        obj.vx = vx;
        obj.vy = vy;
    end

    function obj = setSpeed( obj, vx, vy )
        obj.vx = vx;
        obj.vy = vy;
    end

    function [vx, vy] = getSpeed( obj )
        vx = obj.vx;
        vy = obj.vy;
    end

    function obj = setPosition( obj, x, y )
        obj.x = x;
        obj.y = y;
    end

    function [x, y] = getPosition( obj )
        x = obj.x;
        y = obj.y;
    end

    function obj = tick( obj, s ) % s - seconds
        tmpX = obj.vx + obj.avx*s;
        tmpY = obj.vy + obj.avy*s;
        
        if( sqrt( tmpX^2 + tmpY^2 ) <= obj.terminalSpeed )
            obj.vx = tmpX;
            obj.vy = tmpY;
        else
            disp( 'Terminal velocity reached!' )
        end

        obj.x = obj.x + obj.vx*s;
        obj.y = obj.y + obj.vy*s;
    end

    function obj = setAcceleration( obj, Fx, Fy )
        obj.avx = acceleration( obj.m, Fx );
        obj.avy = acceleration( obj.m, Fy );
    end
end

end

function a = acceleration( m, F )
    a = F/m;
end
