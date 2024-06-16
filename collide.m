function collide( particles, radius )
    collisionPairs = findCollidedParticlePairs( particles, radius );
    handleCollisions( collisionPairs, radius )
end

function pairs = findCollidedParticlePairs( particles, radius )
    pairs = {};
    for i = 1:length( particles )
        first = particles( i );
        [ x1, y1 ] = first.getPosition();
        for j = ( i + 1 ):length( particles )
            second = particles( j );
            [ x2, y2 ] = second.getPosition();

            distance = sqrt( ( x2 - x1 )^2 + ( y2 - y1 )^2 );
            if( distance <= 2 * radius )
                pairs{ end + 1 } = { first, second };
            end
        end
    end
end

function handleCollisions( collisionPairs, radius )
    for i = 1:length( collisionPairs )
        pair = collisionPairs{ i };
        collision( pair{ 1 }, pair{ 2 }, radius );
    end
end

function collision( left, right, radius )
    % The balls tend to stick sometimes, you know what to do
    unstickBallsX( left, right, radius );
    unstickBallsY( left, right, radius );

    [ ~, y1 ] = left.getPosition();
    [ ~, y2 ] = right.getPosition();

    dy = y2 - y1;
    dx = 2 * radius;

    collisionAxisAngle = atan2( dy, dx );
    collisionAxisAngleCos = cos( collisionAxisAngle );
    collisionAxisAngleSin = sin( collisionAxisAngle );

    [ vx1, vy1 ] = left.getSpeed();
    [ vx2, vy2 ] = right.getSpeed();
    
    % Rotate both balls so that their y speed components are parallel to
    % each other
    collisionMatrix = [ collisionAxisAngleCos collisionAxisAngleSin; -collisionAxisAngleSin collisionAxisAngleCos ];
    result = collisionMatrix * [ vx1; vy1 ];
    vx1_r = result( 1 ); 
    result = collisionMatrix * [ vx2; vy2 ];
    vx2_r = result( 1 ); 
    
    % Calculate speeds depending on mass and speed of particles
    vx1_final = ( ( left.m - right.m )*vx1_r + 2*right.m*vx2_r )/( left.m + right.m );
    vx2_final = ( ( right.m - left.m )*vx2_r + 2*left.m*vx1_r )/( left.m + right.m );

    % Now just rotate everything back
    result = inv( collisionMatrix )*[ vx1_final; vy1 ];
    vx1 = result( 1 );
    vy1 = result( 2 );
    result = inv( collisionMatrix )*[ vx2_final; vy2 ];
    vx2 = result( 1 );
    vy2 = result( 2 );

    left.setSpeed( vx1, vy1 );
    right.setSpeed( vx2, vy2 );

    lossOfEnergy( left, right )
end

function lossOfEnergy( left, right )
    % If the particles are different, make their bouncing lose some energy
    if( ~strcmp( class( left ), class( right ) ) )
        [ vx1, vy1 ] = left.getSpeed();
        [ vx2, vy2 ] = right.getSpeed();
        vx1 = vx1 * 0.9;
        vy1 = vy1 * 0.9;
        vx2 = vx2 * 0.9;
        vy2 = vy2 * 0.9;
        left.setSpeed( vx1, vy1 );
        right.setSpeed( vx2, vy2 );
    end
end

function unstickBallsY( left, right, radius )
    [ x1, y1 ] = left.getPosition();
    [ x2, y2 ] = right.getPosition();
    
    % If balls are stuck, unstuck them
    dy = y1 - y2;
    if( abs( dy ) < 2 * radius )
        overlap = 2 * radius - abs( dy );
        if( y1 <= y2 )
            left.setPosition( x1, y1 - ( overlap / 2  ) );
            right.setPosition( x2, y2 + ( overlap / 2 ) );
        else
            left.setPosition( x1, y1 + ( overlap / 2  ) );
            right.setPosition( x2, y2 - ( overlap / 2 ) );
        end
    end
end

function unstickBallsX( left, right, radius )
    [ x1, y1 ] = left.getPosition();
    [ x2, y2 ] = right.getPosition();

    % If balls are stuck, unstuck them
    dx = x1 - x2;
    if( abs( dx ) < 2 * radius )
        overlap = 2 * radius - abs( dx );
        if( x1 <= x2 )
            left.setPosition( x1 - ( overlap / 2 ), y1 );
            right.setPosition( x2 + ( overlap / 2 ), y2 );
        else
            left.setPosition( x1 + ( overlap / 2 ), y1 );
            right.setPosition( x2 - ( overlap / 2 ), y2 );
        end
    end
end

