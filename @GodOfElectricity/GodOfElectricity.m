classdef GodOfElectricity < handle

properties( Access = public )
    electrons = Electron.empty
    coppers = Copper.empty
end

properties( Access = private )
    Fx, Fy % electric field force
    xLimits, yLimits % borders
    interactionRadius
    particles = Particle.empty
    tickSeconds
end

methods
    function obj = GodOfElectricity( params )
        obj.Fx = params.Fx;
        obj.Fy = params.Fy;
        obj.xLimits = params.xLimits;
        obj.yLimits = params.yLimits;
        obj.interactionRadius = params.interactionRadius;
        obj.tickSeconds = params.tickSeconds;

        % Spawn particles randomly
        obj.electrons = spawnInitialElectrons( params.electronCount, obj.xLimits.max, obj.yLimits.max );
        obj.coppers = spawnCoppers( params.copperCount, obj.xLimits.max, obj.yLimits.max, params.maxCopperSpeed, params.vibrationRadius );
        obj.particles = [ obj.electrons obj.coppers ];
    end

    function obj = tick( obj )
        obj.electrons = obj.moveElectrons( obj.tickSeconds );
        obj.coppers = obj.moveCoppers( obj.tickSeconds );
        obj.particles = [ obj.electrons obj.coppers ];
        collide( obj.particles, obj.interactionRadius );
    end
end

methods ( Access = private )
    function movedElectrons = moveElectrons( obj, s )
        movedElectrons = [];
        for i = 1:length( obj.electrons )
            obj.electrons( i ).setAcceleration( obj.Fx, obj.Fy );
            obj.electrons( i ).tick( s );
                        
            % Bounce electron that came to y limit
            bounceFromYLimit( obj.electrons( i ), obj.yLimits.min, obj.yLimits.max );
            
            % Keep only those electrons that are in valid x coordinates
            movedElectrons = [ movedElectrons, nextElectron( obj.electrons( i ), obj.xLimits.max, obj.yLimits.max ) ];
        end
    end

    function movedCoppers = moveCoppers( obj, s )
        for i = 1:length( obj.coppers )
            obj.coppers( i ).tick( s );
        end
        movedCoppers = obj.coppers;
    end
end

end

function electron = nextElectron( electron, xMax, yMax )
    [ x, y ] = electron.getPosition();

    if( x <= xMax && x >= 0 )
        % Keep current electron
        electron = electron;
    else
        % Spawn a new electron if current one is out of bounds
        x = 0;
        y = rand * yMax;
        electron = spawnElectron( x, y );
    end
end

function electron = spawnElectron( x, y )
    vx = 30 * rand + 0.01;
    vy = 2*rand - 1;
    electron = Electron( x, y, vx, vy );
end

function electron = bounceFromYLimit( electron, yMin, yMax )
    [ x, y ] = electron.getPosition();
    [ vx, vy ] = electron.getSpeed();

    if( y <= yMin )
       electron.setPosition( x, yMin );
       electron.setSpeed( vx, abs( vy ) );
    end

    if( y >= yMax )
       electron.setPosition( x, yMax );
       electron.setSpeed( vx, -abs( vy ) );
    end
end

function electrons = spawnInitialElectrons( count, xMax, yMax )
    electrons = [];
    % Spawn initial electrons randomly
    for i = 1:count
        x = rand * xMax;
        y = rand * yMax;
        electrons = [ electrons, spawnElectron( x, y ) ];
    end
end

function coppers = spawnCoppers( count, xMax, yMax, vMax, radius )
    coppers = [];
    % Spawn copper atoms randomly
    for i = 1:count
        x = rand * xMax;
        y = rand * yMax;
        coppers = [ coppers, Copper( x, y, vMax, radius ) ];
    end
end
