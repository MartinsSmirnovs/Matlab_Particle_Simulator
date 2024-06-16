classdef Counter < handle

properties ( Access = private )
    max
    x
end

methods ( Access = public )
    function obj = Counter( max )
        obj.max = max;
        obj.x = 0;
    end

    function result = targetReached( obj, x )
        obj.x = obj.x + x;
        if( obj.x >= obj.max )
            obj.x = 0;
            result = true;
        else
            result = false;
        end
    end
end

end