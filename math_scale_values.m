%https://in.mathworks.com/matlabcentral/answers/75568-how-can-i-normalize-data-between-0-and-1-i-want-to-use-logsig
function [newValue] = math_scale_values( originalValue, minOriginalRange, maxOriginalRange, minNewRange, maxNewRange)
%  MATH_SCALE_VALUES
%   Converts a value from one range into another
%       (maxNewRange - minNewRange)(originalValue - minOriginalRange)
%    y = ----------------------------------------------------------- + minNewRange      
%               (maxOriginalRange - minOriginalRange)

newValue = minNewRange + (((maxNewRange - minNewRange) * (originalValue - minOriginalRange))/(maxOriginalRange - minOriginalRange));

end