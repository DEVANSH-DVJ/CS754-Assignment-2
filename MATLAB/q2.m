clc;
clear;
close all;

% Reading
orig = cast(imread("data/barbara256.png"),'double');
H = size(orig, 1);
W = size(orig, 2);
% figure; imshow(cast(orig, 'uint8'));

% Adding Gaussian Noise
noise_img = orig + 2*randn(H, W);
% figure; imshow(cast(noise_img, 'uint8'));

phi = randn(32, 64);
psi = kron(dctmtx(8)', dctmtx(8)');
A = phi*psi;

alpha = floor(eigs(A'*A,1)) + 1;
iter = 1000;
lambda = 1;

recon_img = zeros(H, W, 'double');
avg_mat = zeros(H, W, 'double');

tic;
for i=1:H-7
    for j=1:W-7
        y = phi * reshape(noise_img(i:i+7,j:j+7), [8*8 1]);
        theta = ista(y, A, lambda, alpha, iter);
        recon_img(i:i+7,j:j+7) = recon_img(i:i+7,j:j+7) + reshape(psi*theta, [8 8]);
        avg_mat(i:i+7,j:j+7) = avg_mat(i:i+7,j:j+7) + ones(8,8);
        i, j % Prints the coordinates, to check for speed and debugging
    end
end

recon_img(:,:) = recon_img(:,:)./avg_mat(:,:);
recon_img(recon_img < 0) = 0;
recon_img(recon_img > 255) = 255;
figure;
imshow(cast([recon_img(:,:), orig(:,:)], 'uint8'));
% imwrite(cast([recon_img(:,:,i), F(:,:,i)], 'uint8'), sprintf('results/%s_%i_%i.png',name,T,i));
% fprintf('RMSE for frame %i : %f\n',i,norm(recon_img(:,:,i)-F(:,:,i), 'fro')^2/norm(F(:,:,i), 'fro')^2);
% fprintf('RMSE of video sequence : %f\n',i,norm(reshape(recon_img(:,:,:)-F(:,:,:), [H*W*T 1]))^2/norm(reshape(F(:,:,:), [H*W*T 1]))^2);

toc;
