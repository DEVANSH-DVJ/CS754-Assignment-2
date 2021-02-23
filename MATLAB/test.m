clc;
clear;
close all;

% Reading
orig = cast(imread("data/barbara256.png"),'double');
H = size(orig, 1);
W = size(orig, 2);
% figure; imshow(cast(orig, 'uint8'));

phi = randn(32, 64);
% psi = kron(dctmtx(8)', dctmtx(8)');
% [a,b,c,d] = dwt2(orig, 'db1');
[a b c d] = dwt2(orig, 'db1');
reach = idwt2(a, b, c, d, 'db1');

