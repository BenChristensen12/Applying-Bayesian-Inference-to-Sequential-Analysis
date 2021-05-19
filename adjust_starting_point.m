%Initial Setup
upper_bound = log((1-alpha)/alpha);
lower_bound = log(beta/(1-beta));
prior = .7;
p_trick = .6;
p_fair = .5;
start_point = (upper_bound - lower_bound)*prior + lower_bound;%change starting point according to prior belief
w_h = log(p_trick/p_fair); %This is the drift rate of y;
w_t = log((1-p_trick)/(1-p_fair));
alpha = .05;
beta = .05;
prop_trick = .7;
num_trials = 10000;
coin_flips = [];
type_i = 0;
type_ii = 0;


%Start Trials
for trial = 1:num_trials
    if rand < prop_trick
        coin_prob = p_trick;
    else
        coin_prob = p_fair;
    end
    y = start_point;
    y_history = [y];
    while y < log((1-alpha)/alpha) && y > log(beta/(1-beta))
       if rand < coin_prob
           y = y + w_h;
       else
           y = y + w_t;
       end
       y_history = [y_history y];
    end

    if y > upper_bound
        coin_type = "trick";
        if coin_prob == p_fair
            type_ii = type_ii + 1;
        end
    end
    if y < lower_bound
        coin_type = "fair";
        if coin_prob == p_trick
            type_i = type_i + 1;
        end
    end
    coin_flips = [coin_flips length(y_history) - 1];
end


figure; hold on;
yline(upper_bound, 'r--', 'Threshold', 'LineWidth', 3)
yline(lower_bound, 'r--', 'Threshold', 'LineWidth', 3)
yline(start_point, ':', 'Start Point', 'LineWidth', 3)
xlabel("Coin Flips")
plot(y_history)

mean(coin_flips)

