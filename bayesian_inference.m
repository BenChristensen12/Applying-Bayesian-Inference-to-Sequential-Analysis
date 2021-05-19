%Initial Setup
upper_bound = 0.95;
lower_bound = 0.05;
original_prior = .7;
p_trick = .6;
p_fair = .5;
start_point = original_prior;
prop_trick = .7;
num_trials = 10000;
coin_flips = [];
type_i = 0;
type_ii = 0;
%Start Trials
for trial = 1:num_trials
    posterior = original_prior;
    posterior_history = [posterior];
    if rand < prop_trick %coin is a trick coin
        coin_prob = p_trick;
    else
        coin_prob = p_fair; %coin is fair 
    end
    loop_count = 0;
    while posterior < upper_bound && posterior > lower_bound
       prior = posterior; %use the posterior of the last flip as the prior for the next flip
       if rand < coin_prob %flip is heads
           posterior = (p_trick * prior) / (p_trick * prior + p_fair * (1-prior));
       else %flip is tails
           posterior = ((1-p_trick) * prior) / (((1-p_trick) * prior) + ((1-p_fair) * (1-prior)));
       end
       posterior_history = [posterior_history posterior];
       loop_count = loop_count + 1;
       if loop_count > 1000
           break
       end
    end

    if posterior > upper_bound
        coin_type = "trick";
        if coin_prob == p_fair
            type_ii = type_ii + 1;
        end
    end
    if posterior < lower_bound
        coin_type = "fair";
        if coin_prob == p_trick
            type_i = type_i + 1;
        end
    end
    coin_flips = [coin_flips length(posterior_history) - 1];
end


figure; hold on;
yline(upper_bound, 'r--', 'Threshold', 'LineWidth', 3)
yline(lower_bound, 'r--', 'Threshold', 'LineWidth', 3)
yline(start_point, ':', 'Start Point', 'LineWidth', 3)
xlabel("Coin Flips")
plot(posterior_history)

mean(coin_flips)

