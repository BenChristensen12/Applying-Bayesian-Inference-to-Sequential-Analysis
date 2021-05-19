p_fair = 0.5;
alpha = .05;
beta = .05;
upper_bound = log((1-alpha)/alpha);
lower_bound = log(beta/(1-beta));
num_trials = 1000;
coin_flips = [];
trick_probabilities = [.6:.1:1];
prior_probabilities = [.1:.2:.9];
trick_proportions = [0:.2:1];
HR = [];
FAR = [];
Dprimes = [];
for p_trick =trick_probabilities
    w_h = log(p_trick/p_fair); %This is the drift rate of y;
    w_t = log((1-p_trick)/(1-p_fair));     
    for prior = prior_probabilities
        start_point = (upper_bound - lower_bound)*prior + lower_bound;%change starting point according to prior belief
        for prop_trick = trick_proportions
            false_alarms = 0;
            hits = 0;
            num_negs = 0;
            num_positives = 0;
            %Start Trials
            for trial = 1:num_trials
                if rand < prop_trick %trick coin
                    coin_prob = p_trick;
                    num_positives = num_positives + 1;
                    trick_coin = 1;
                else %fair coin
                    coin_prob = p_fair;
                    num_negs = num_negs + 1;
                    trick_coin = 0;
                end
                y = start_point;
                y_history = [y];
                while y < upper_bound && y > lower_bound
                   if rand < coin_prob %heads
                       y = y + w_h;
                   else %tails
                       y = y + w_t;
                   end
                   y_history = [y_history y];
                end

                if y > upper_bound %decided it was a trick coin
                    if trick_coin == 1 %it actually was a trick coin
                        hits = hits + 1;
                    else
                        false_alarms = false_alarms + 1;
                    end
                end
                coin_flips = [coin_flips length(y_history) - 1];
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
title("Changing Starting Point")
xlabel("False Alarm Rate")
ylabel("Hit Rate")
plot([0:.1:1], [0:.1:1],':')
mean(coin_flips)
mean(Dprimes(:),'omitnan')

