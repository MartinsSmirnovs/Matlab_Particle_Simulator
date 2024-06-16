classdef Copper < Particle

properties ( Access = private )
    x0, y0; % coordinates around which the particle is going to move
    x, y; % coordinates of the atom
    radius; % how far from coordinates can this particle move away
    vx, vy; % speed components of coordinates, m/s
    vMax; % max speed of components
end

properties ( Constant )
    m = 1.0552061e-25;   % kg
end

methods
    function obj = Copper( x0, y0, vMax, radius ) % s - seconds
        obj.x0 = x0;
        obj.y0 = y0;
        obj.x = obj.x0;
        obj.y = obj.y0;
        obj.vx = 0;
        obj.vy = 0;
        obj.radius = radius;
        obj.vMax = vMax;
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
        obj.x = getCoordinate( x, obj.x0 - obj.radius, obj.x0 + obj.radius );
        obj.y = getCoordinate( y, obj.y0 - obj.radius, obj.y0 + obj.radius );
    end

    function [x, y] = getPosition( obj )
        x = obj.x;
        y = obj.y;
    end

    function obj = tick( obj, s ) % s - seconds
        % Multiply max speed by 2 because max speed of a component
        % is meant as a max speed in a single direction (positive or
        % negative). Since we are lowering the rand value we have to 
        % compensate it with a coefficient.
        obj.vx = ( rand - 0.5 ) * obj.vMax * 2;
        obj.vy = ( rand - 0.5 ) * obj.vMax * 2;

        obj.setPosition( obj.x + obj.vx*s, obj.y + obj.vy*s );
    end

    function obj = setAcceleration( obj, ~, ~ )
        % External forces do not do anything to this type of particle
        disp( 'External forces do not affect Copper' )
    end
end

end

function coordinate = getCoordinate( a, aMin, aMax )
    if( a > aMax )
        coordinate = aMax;
    elseif( a < aMin )
        coordinate = aMin;
    else
        coordinate = a;
    end
end
