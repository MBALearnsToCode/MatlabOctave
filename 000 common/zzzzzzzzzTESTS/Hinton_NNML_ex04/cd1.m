function ret = cd1(rbm_w, visible_data)
% <rbm_w> is a matrix of size <number of hidden units> by
% <number of visible units>
% <visible_data> is a (possibly but not necessarily binary)
% matrix of size <number of visible units> by <number of data
% cases>
% The returned value is the gradient approximation produced by
% CD-1. It's of the same shape as <rbm_w>.
    
    visible_data = sample_bernoulli(visible_data);

    v0 = visible_data;
    m = columns(visible_data);
    
    h0 = visible_state_to_hidden_probabilities...
       (rbm_w, visible_data);
    h0 = sample_bernoulli(h0);
    positivePhase = h0 * v0';
    
    v1 = hidden_state_to_visible_probabilities...
       (rbm_w, h0);
    v1 = sample_bernoulli(v1);
    h1 = visible_state_to_hidden_probabilities...
       (rbm_w, v1);
    %h1 = sample_bernoulli(h1);

    negativePhase = h1 * v1';
    
    ret = (positivePhase - negativePhase) / m;   
    
end