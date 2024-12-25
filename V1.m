% AUTHOR : ATIVON Espoir & TALL Issouf & LATIFI Jasser

clc;

% Simulation program
mu = input("Valeur de la cible :  ");
while mu < 0
    disp("La cible ne peut pas être inférieure ou égale à 0. ");
    mu = input("Valeur de la cible :  ");
end

IT = input("Valeur de IT : ");
while IT < 0
    disp("La tolérence ne peut pas être inférieure ou égale à 0. ");
    IT = input("Taille d'un échantillon : ");
end

k = input("Taille d'un échantillon : ");
while k < 0
    disp("La taille ne peut pas être inférieure ou égale à 0. ");
    k = input("Taille d'un échantillon : ");
end

% Constants
n = 1;                                          % Number of samples initially
cycle = 10;                                     % Sample produced
wear_rate = 0.01;
NQA_wear = 0.3;                                 %Max allowed wear

% Parameters
sigma = IT / 6;
LSC = mu + (IT / 2);                           %Limite Supérieur de ctrl
LIC = mu - (IT / 2);                           %Limite Inférieur de ctrl

fprintf("\n");

% preparation phase
disp("Phase de préparation : Carte de contrôle provisoire");
% data took from the sujet data[i][j] = mu + (suject[i][j] / 1000)
data = [[49.94 49.96 49.94 50.10 49.97 ];
        [49.89 49.87 50.05 49.90 49.90 ];
        [50.10 50.12 49.98 49.87 50.05 ];
        [50.05 49.90 49.89 49.87 49.96 ];
        [49.88 49.90 50.08 50.09 50.11 ];
        [50.09 50.12 50.13 50.10 50.13 ];
        [50.02 50.08 50.09 49.87 50.05 ];
        [50.05 50.10 49.87 50.05 50.12 ];
        [50.08 50.09 49.90 50.05 49.90 ];
        [50.11 49.87 50.05 50.08 49.90 ]];
disp(data);

% Simulate wear over multiple cycles
mu_production = mu;
while true
    cycle = cycle + 1;  % Increment cycle number
    fprintf("\n");
     
    % Plot updated control chart
    figure;
    st = controlchart(data, 'chart', {'xbar', 'r'});
    %title(sprintf('Carte de contrôle - Cycle %d', cycle));

    % Check if wear exceeds maintenance threshold
    if (wear(wear_rate, cycle) >= NQA_wear)
        fprintf("Maintenance nécéssaire: l'usure dépasse 0.3." + ...
            " [C]hanger l'outils | [A]rrêter : ", 's');
        if strcmpi(user_input, 'A')
            break;  % Stop simulation
        elseif strcmpi(user_input, 'C')
            cycle = 0;
        end
    end


    % Calculate Cp and Cpk for the current cycle
    sample_mean = mean(Xp);  % Mean of the current sample
    sample_std = std(Xp);    % Standard deviation of the current sample
    
    Cp = (LSC - LIC) / (6 * sample_std);
    Cpk = min((LSC - sample_mean), (sample_mean - LIC)) / (3 * sample_std);
    
    % Display Cp and Cpk

    % Mean of all mean
    sample_means = mean(Xp);

    % Display results for the current cycle
    fprintf('\nCycle %d:\n', cycle);
    fprintf('  Cp: %.4f\n', Cp);
    fprintf('  Cpk: %.4f\n', Cpk);
    fprintf('  Usure: %.2f mm \n', wear(wear_rate, cycle));
    fprintf('  Cible: %.2f mm \n', mu_with_wear);
    fprintf('  Moyenne de serie: %.2f mm\n', sample_means);
    fprintf('  Série : ');
    disp(Xp');

    if Cp < 1 || Cpk < 1
        fprintf("Attention : Processus hors contrôle (Cm ou Cmk < 1).\n");
    end

    user_input = input("[R]églage | [S]topper |" + ...
        " Entrer pour continuer la production : ", 's');
    
    if strcmpi(user_input, 'S')
        disp('Simulation arrêtée.');
        break;
    elseif strcmpi(user_input, 'R')
        mu_production = input("Nouvelle cible : ");
        disp("Réglage effectué.");
    end

    mu_with_wear = mu_production + wear(wear_rate, cycle);
    Xp = normrnd(mu_with_wear, IT, k, n);
    data = [data; Xp'];
end


% function definition
function wear_effect = wear(wear_rate, time)
    % WEAR Simulates the effect of wear
    %
    % Inputs:
    %   mu         - Initial target value (mean of the process)
    %   wear_rate  - Rate of wear per unit time
    %   time       - Time or cycle number
    %
    % Output:
    %   mu_with_wear - Updated target value with wear applied
    wear_effect = wear_rate * time;
end