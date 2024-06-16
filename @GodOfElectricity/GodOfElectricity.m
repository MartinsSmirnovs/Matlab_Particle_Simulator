classdef GodOfElectricity < handle

properties( Access = public )
    electrons = Electron.empty
    passedElectrons = Electron.empty % Electrons that moved past y limit
    coppers = Copper.empty    
end

properties( Access = private )
    Fx, Fy % electric field force
    xLimits, yLimits % borders
    interactionRadius
    tickSeconds
    passedElectronsCounter
    timeCounter % in seconds
    I % current
end

methods
    function obj = GodOfElectricity( params )
        obj.Fx = params.Fx;
        obj.Fy = params.Fy;
        obj.xLimits = params.xLimits;
        obj.yLimits = params.yLimits;
        obj.interactionRadius = params.interactionRadius;
        obj.tickSeconds = params.tickSeconds;
        obj.passedElectronsCounter = 0;
        obj.timeCounter = Counter( 1 );
        obj.I = 0;

        % Spawn particles randomly
        obj.electrons = spawnInitialElectrons( params.electronCount, obj.xLimits.max, obj.yLimits.max );
        obj.coppers = spawnCoppers( params.copperCount, obj.xLimits.max, obj.yLimits.max, params.maxCopperSpeed, params.vibrationRadius );
    end

    function obj = tick( obj )
        obj.electrons = obj.moveElectrons( obj.tickSeconds );
        obj.coppers = obj.moveCoppers( obj.tickSeconds );
        collide( [ obj.electrons obj.coppers ], obj.interactionRadius );
        obj.countElectrons();
    end

    function I = getI( obj )
        I = obj.I;
    end

    function U = getU( obj )
        U = ( sqrt( obj.Fx^2 + obj.Fy^2 ) * ( obj.xLimits.max - obj.xLimits.min ) ) / Electron.q;
    end
end

methods ( Access = private )
    function countElectrons( obj )
        obj.passedElectronsCounter = obj.passedElectronsCounter + length( obj.passedElectrons );
        if( obj.timeCounter.targetReached( obj.tickSeconds ) )
            % I = q/dt; q = n_of_electrons*q_of_electron; dt = 1;
            % Since the amount of electrons in a simulation is severely
            % limited, it makes sense to boost the number up by some big
            % coefficient k
            k = 10e10;
            obj.I = obj.passedElectronsCounter * Electron.q * k;
            obj.passedElectronsCounter = 0;
        end
    end

    function movedElectrons = moveElectrons( obj, s )
        obj.passedElectrons = [];
        movedElectrons = [];
        for i = 1:length( obj.electrons )
            obj.electrons( i ).setAcceleration( obj.Fx, obj.Fy );
            obj.electrons( i ).tick( s );
                        
            % Bounce electron that came to y limit
            bounceFromYLimit( obj.electrons( i ), obj.yLimits.min, obj.yLimits.max );
            
            % Keep only those electrons that are in valid x coordinates
            electron = nextElectron( obj.electrons( i ), obj.xLimits.max, obj.yLimits.max );
            movedElectrons = [ movedElectrons, electron ];
    	    
            % If new electron was spawned store the old one
            if( obj.electrons( i ) ~= electron )
                obj.passedElectrons = [ obj.passedElectrons, electron ];
            end
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
