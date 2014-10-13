function ret = cd1(rbm_w, visible_data)
% <rbm_w> is a matrix of size <number of hidden units> by
% <number of visible units>
% <visible_data> is a (possibly but not necessarily binary)
% matrix of size <number of visible units> by <number of data
% cases>
% The returned value is the gradient approximation produced by
% CD-1. It's of the same shape as <rbm_w>.

    
    visible_data = sample_bernoulli(visible_data);

    
    positivePhase = negativePhase = 0;
    v0 = visible_data;
    m = columns(visible_data);
    
    h0 = visible_state_to_hidden_probabilities...
       (rbm_w, visible_data);
    h0 = sample_bernoulli(h0);
    for (i = 1 : m)     
       positivePhase += h0(:, i) * v0(:, i)';       
    endfor
    
    
    v1 = hidden_state_to_visible_probabilities...
       (rbm_w, h0);
    v1 = sample_bernoulli(v1);
    h1 = visible_state_to_hidden_probabilities...
       (rbm_w, v1);
    %h1 = sample_bernoulli(h1);
    
    for (i = 1 : m)
       negativePhase += h1(:, i) * v1(:, i)';       
    endfor
    
    ret = (positivePhase - negativePhase) / m;   
    
end