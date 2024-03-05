  function results = run_KCF(seq, res_path, bSaveImage)

    kernel.type = 'gaussian'; 

    padding = 1.5;  %extra area surrounding the target
    lambda = 1e-4;  %regularization
    output_sigma_factor = 0.1;  %spatial bandwidth (proportional to target)

    interp_factor = 0.02;
    kernel.sigma = 0.5; 
    kernel.poly_a = 1;
    kernel.poly_b = 9;  
    features.hog = true;
    features.gray = false;
    features.hog_orientations = 9;
    cell_size = 4;  
    show_visualization = 0;
    %%%%%這裏我就將seq傳給了seq_KCF （其實不用，這個多餘了。）
    %%%%%%然後直接通過調用關係，就可以將seq中的值傳給（這裏的seq是從OTB的main函數中來的） 
    %%%%%target_sz（目標大小）pos（目標位置）img_files（後續frames的地址）
    seq_KCF = seq;
    target_sz = seq_KCF.init_rect(1,[4,3]);
    pos = seq_KCF.init_rect(1,[2,1]) + floor(target_sz/2);
    img_files = seq_KCF.s_frames;
    video_path = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 上面的這些參數設置其實爲tracker(     );裏面的各種參數進行設置服務，
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%這裏的[positions , time] = tracker（）其實就是調用KCF了，裏面的各種參數可能你用不上，就要進行修改調整。
    [positions , time] = tracker(video_path, img_files, pos, target_sz, ...
            padding, kernel, lambda, output_sigma_factor, interp_factor, ...
            cell_size, features,show_visualization);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    if bSaveImage
        imwrite(frame2im(getframe(gcf)),[res_path num2str(frame) '.jpg']); 
    end

    %return results to benchmark, in a workspace variable
    %下面這些處理就是爲了將上面得到的[positions , time]變成OTB接受的返回值形式
    rects = [positions(:,2) - target_sz(2)/2, positions(:,1) - target_sz(1)/2];
    rects(:,3) = target_sz(2);
    rects(:,4) = target_sz(1);

    fps = numel(img_files) / time;
    results.type = 'rect';
    results.res = rects;%each row is a rectangle
    results.fps = fps;

  end