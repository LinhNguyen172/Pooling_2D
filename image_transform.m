% Tạo ảnh đầu vào mô phỏng từ ảnh màu có sẵn
G = imread('galaxy32x32.png');
gray_G = rgb2gray(G);
for i = 1:32
    for j = 1:32
    gray_G_resize(i,j) = gray_G(37*i-36,37*j-36);
    end
end
% Hiện thị các ảnh
close all;
figure;imshow(G);
figure;imshow(gray_G);
figure;imshow(gray_G_resize);

% Sau mô phỏng, dùng vòng for để biến đổi Pooled_G sang matrix kiểu uint8
for i = 1:16
    for j = 1:16
        Pool2D_G(i,j) = eval (strcat('uint8','(',int2str(Pooled_G(i,j)),')'));
    end
end

% Kiểm chứng kết quả mô phỏng bằng matlab
for i = 1:16
    for j = 1:16
        Manual_G(i,j) = (gray_G_resize(2*i-1,2*j-1) + gray_G_resize(2*i,2*j) + gray_G_resize(2*i,2*j-1) + gray_G_resize(2*i-1,2*j)) / 4;
    end 
end

% Kiểm tra trên ảnh
figure;imshow(Pooled2D_G);
figure;imshow(Manual_G);