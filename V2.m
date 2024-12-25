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

disp("Taille d'un échantillon : 5");
pause(1);

% Constants
k = 5;                                        % Sample size
n = 1;                                        % Number of samples initially
cycle = 0;                                    % Cycle factor for wear
wear_rate = 0.01;
NQA_wear = 0.3;                               % Max allowed wear
D5 = 0;
D6 = 4.92;

% Parameters
sigma = IT / 6;
LSC = mu + 3 * sigma / sqrt(k);               %Limite Supérieur de ctrl
LIC = mu - 3 * sigma / sqrt(k);               %Limite Inférieur de ctrl
LSCR = D6 * sigma;
LICR = D5 * sigma;
disp("LSC LIC LSCR LICR : ");
disp([LSC LIC LSCR LICR]);
pause(2)

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
sample_means = [49,982 49,922 50,024 49,934 50,012 50,114 50,022 50,038 50,004 50,002];
disp(data);

% initialize figure
figure;
hold on;
st = controlchart(data, 'chart', {'xbar', 'r'});

% Simulate wear over multiple cycles
mu_production = mu;
while true
    cycle = cycle + 1;  % Increment cycle number
    fprintf("\n");

    mu_with_wear = mu_production + wear(wear_rate, cycle);
    Xp = normrnd(mu_with_wear, IT, k, n);
    data = [data; Xp'];
     
    % Plot updated control chart
    [st, d] = controlchart(data, 'chart', {'xbar', 'r'});

    % Check if wear exceeds maintenance threshold
    if (wear(wear_rate, cycle) >= NQA_wear)
        user_input = input("Maintenance nécéssaire: l'usure dépasse 0.3." + ...
            " [C]hanger l'outils | Entrer pour arrêter : ", 's');
        if strcmpi(user_input, 'C')
            cycle = 0;
        else
            break;
        end
    end

    % update means array
    sample_mean = mean(Xp);  % Mean of the current sample
    sample_means = [sample_means, sample_mean];
    sample_mean = mean(sample_means);

    % Calculate Cp and Cpk for the current cycle
    Cp = (LSC - LIC) / (6 * sample_mean);
    Cpk = min((LSC - sample_mean), (sample_mean - LIC)) / (3 * std(sample_means));

    % Display results for the current cycle
    fprintf('\nCycle %d:\n', cycle);
    fprintf('  Cp: %.4f\n', Cp);
    fprintf('  Cpk: %.4f\n', Cpk);
    fprintf('  Usure: %.2f mm \n', wear(wear_rate, cycle));
    fprintf('  Cible: %.2f mm \n', mu_with_wear);
    fprintf('  Moyenne de serie: %.2f mm\n', mean(Xp));
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