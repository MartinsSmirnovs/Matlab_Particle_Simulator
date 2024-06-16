clc, clear, addpath( pwd )

params = SimulationParams;
params.electronCount = 50;
params.copperCount = 30;
params.Fx = 1e-27;
params.Fy = 0;
params.tickSeconds = 0.001;
params.maxCopperSpeed = 500;
% Important!
% Since the representation of particles are graph circles, they do not
% change their dimensions relative to graph size. It means that 
% if graph height to width proportion is 4:1, the balls will still be 
% circular and their behavior might look weird - they may seem not to be
% colliding when they look like they are touching, while in reality they
% are not touching in context of their actual coordinates
params.xLimits = Limit( 0, 100 );
params.yLimits = Limit( 0, 100 );
params.interactionRadius = 0.5;
params.vibrationRadius = 0.5;
displaySize = [ 50, 50, 900, 900 ];

godOfElectricity = GodOfElectricity( params );

figure
set( gca, 'XLim', [ params.xLimits.min params.xLimits.max ] )
set( gca,'YLim', [ params.yLimits.min params.yLimits.max ] )
set( gcf, 'Position',  displaySize )
hold on

initialElectronPositions = getPositions( godOfElectricity.electrons );
initialCopperPositions = getPositions( godOfElectricity.coppers );
electronHandle = plot( initialElectronPositions( :, 1 ), initialElectronPositions( :, 2 ), 'o' );
copperHandle = plot( initialCopperPositions( :, 1 ), initialCopperPositions( :, 2 ), 'o' );

while 1
    godOfElectricity.tick();
    electronPositions = getPositions( godOfElectricity.electrons );
    copperPositions = getPositions( godOfElectricity.coppers );

    set( electronHandle, 'XData', electronPositions( :, 1 ) )
    set( electronHandle, 'YData', electronPositions( :, 2 ) )
    set( copperHandle, 'XData', copperPositions( :, 1 ) )
    set( copperHandle, 'YData', copperPositions( :, 2 ) )

    pause( 0.01 );
end

function positions  = getPositions( particles )
    particleCount = length( particles );
    positions = zeros( particleCount, 2 );
    for i = 1:particleCount
        [ x, y ] = particles( i ).getPosition();
        positions( i, 1 ) = x;
        positions( i, 2 ) = y;
    end
end
