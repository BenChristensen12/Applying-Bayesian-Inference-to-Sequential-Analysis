p_fair = 0.5;
upper_bound = .95;
lower_bound = .05;
num_trials = 1000;
trick_probabilities = [.6:.1:1];
prior_probabilities = [.1:.2:.9];
trick_proportions = [0:.2:1];
coin_flips = [];
HR = [];
FAR = [];
Dprimes = [];
for p_trick = trick_probabilities
    for original_prior = prior_probabilities
        start_point = original_prior;%change starting point according to prior belief
        for prop_trick = trick_proportions
            false_alarms = 0;
            hits = 0;
            num_negs = 0;
            num_positives = 0;
            %Start Trials
            for trial = 1:num_trials
                posterior = original_prior;
                posterior_history = [posterior];
                if rand < prop_trick %coin is a trick coin
                    coin_prob = p_trick;
                    num_positives = num_positives + 1;
                    trick_coin = 1;
                else
                    coin_prob = p_fair; %coin is fair
                    num_negs = num_negs + 1;
                    trick_coin = 0;
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
                   %if loop_count > 100
                   %    break
                   %end
                end
                if posterior > upper_bound %decided it was a trick coin
                    if trick_coin == 1
                        hits = hits + 1;               
                    else
                        false_alarms = false_alarms + 1;
                    end
                end
                coin_flips = [coin_flips length(posterior_history) - 1];
            end
            hit_rate = hits / num_positives;
            f_a_rate = false_alarms / num_negs;
            HR = [HR hit_rate];
            FAR = [FAR f_a_rate];
            Dprimes = [Dprimes TSD(f_a_rate, hit_rate)];
        end
    end
end

%figure; hold on;
%yline(upper_bound, 'r--', 'Threshold', 'LineWidth', 3)
%yline(lower_bound, 'r--', 'Threshold', 'LineWidth', 3)
%yline(start_point, ':', 'Start Point', 'LineWidth', 3)
%xlabel("Coin Flips")
%plot(y_history)

figure; hold on;
scatter(FAR, HR);
title("Bayesian Inference");
xlabel("False Alarm Rate")
ylabel("Hit Rate")
plot([0:.1:1], [0:.1:1],':')
mean(coin_flips)
mean(Dprimes(:),'omitnan')

