function data = add_noise(data)

zero_ind = find(data == 0);
zero_count = length(zero_ind);
noise = randn(zero_count, 1);
data(zero_ind) = noise;
end

