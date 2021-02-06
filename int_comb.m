function [ do ] = int_comb( di, bw, trunc, mode )

	len = size(di, 1);
	do = zeros(len, 1);
	
	max_bw = 2^(bw - 1) - 1;
	min_bw = -2^(bw - 1);
	
	max_bw_val = 2^bw;
	
	do(1, 1) = di(1, 1);
	
	for i = 2:1:len
        if mode == 0
            do(i, 1) = di(i, 1) + do(i - 1, 1);
        else
            do(i, 1) = di(i, 1) - di(i - 1, 1);
        end
		 
		 if do(i, 1) > max_bw
			 do(i, 1) = do(i, 1) - max_bw_val;
		 elseif do(i, 1) < min_bw
			 do(i, 1) = max_bw_val + do(i, 1);
		 end
	end

	do = floor(do / 2^( bw - trunc ));
	
end

