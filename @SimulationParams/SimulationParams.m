classdef SimulationParams
    properties ( Access = public )
        xLimits = Limit.empty % Limits of x plane
        yLimits = Limit.empty % Limits of y plane
        electronCount % count of electrons at any time on the field
        copperCount % count of copper particles at any time on the field
        Fx % x component of force that affects electrons
        Fy % y component of foce that affects electrons
        interactionRadius % radius of particles where interaction between happens
        vibrationRadius % how far can copper particles vibrate
        tickSeconds % the time step
        maxCopperSpeed % max speed of copper particles m/s (for both x and y components)
    end
end