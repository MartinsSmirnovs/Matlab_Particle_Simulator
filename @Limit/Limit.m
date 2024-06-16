classdef Limit
    properties ( Access = public )
        min
        max
    end

    methods ( Access = public )
        function obj = Limit( min, max )
            obj.min = min;
            obj.max = max;
        end
    end
end