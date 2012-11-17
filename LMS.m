function [e, w1] = LMS( w0,x,d,eta)
%LMS [e, w1] = LMS( w0,x,d,eta)
%   Detailed explanation goes here
y=w0*x';
e=d-y;
w1=w0+eta*x*e;
end
