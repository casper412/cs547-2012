function [ output ] = sigmoidPrime( a, v )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
output=a.*sigmoid(v).*(1-sigmoid(v));

end

