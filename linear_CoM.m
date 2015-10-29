function CoM = linear_CoM(intensity,threshold)
% Julien B. Azimzadeh, August 2015
% CoM = linear_CoM(intensity,threshold) finds the center of mass of a
% vector of weight values 'intensity'. 
% 'Threshold' is a value above which the intensities must be in order to be
% part of the center of mass calculation.
% Intensities must be > 0

% Check that all intensity values are greater than zero.
if sum(intensity(intensity<0)) ~= 0
    error('Error: all intensities must be positive.')
end

% If no threshold was specified, use a value of zero. This uses all of the
% intensity values for the CoM calculation.
if ~exist('threshold', 'var') 
  threshold = 0;
end

intensity(intensity < threshold) = 0;       % Assign a zero to values below the threshold so that they do not contribute to the CoM calculation

index_vector = [2:length(intensity)+1];       % Make a vector that has the indices of the intensity vector
intensity = double(intensity);              % Convert from uint8 to double
distance_mass = index_vector .* intensity;  % Multiply index value (distance) by weight (intensity)
CoM = sum(distance_mass) / sum(intensity);

end