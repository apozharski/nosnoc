clear all
clc
close all

import casadi.*


%% settings
% collocation settings
settings = default_settings_fesd();

settings.d = 2;                            % Degree of interpolating polynomial
% MPCC settings
settings.mpcc_mode = 3;                    % 1 - extact, 2 - smooth  ,3 -relax , 4 - penalty, 5 - elastic mode
settings.s_elastic_max = 1e1;              % upper bound for elastic variables
settings.objective_scaling_direct = 0;                   % in penalty methods  1: J = J+(1/p)*J_comp (direct)  , 0 : J = p*J+J_comp (inverse)
% Penalty/Relaxation paraemetr
settings.sigma_0 = 1e1;                     % starting smouothing parameter
settings.sigma_N = 1e-10;                   % end smoothing parameter
settings.kappa = 0.1;                      % decrease rate
settings.N_homotopy = ceil(abs(log(settings.sigma_N/settings.sigma_0)/log(settings.kappa)))+1 ;% number of steps
settings.comp_tol = 1e-14;

% time freezing settings 
settings.initial_theta = 0.5;

%^ IPOPT Settings
opts_ipopt.verbose = false;
opts_ipopt.ipopt.max_iter = 250;
opts_ipopt.ipopt.print_level = 0;
opts_ipopt.ipopt.mu_strategy = 'adaptive';
opts_ipopt.ipopt.mu_oracle = 'quality-function';
settings.opts_ipopt = opts_ipopt;
%% Generate Model
model = temp_control_model_voronoi();
%% Call FESD Integrator - Simulation
model.T_sim = 4;
model.N_stages = 2;
model.N_finite_elements = 1;
model.h = 0.01;
settings.gamma_h = 1;
model.T = model.N_stages*model.h;
settings.use_previous_solution_as_initial_guess = 1;
[results,stats] = integrator_fesd(model,settings);
%% Read and plot Result
plot_results_for_paper
%% complementarity stats
figure
semilogy(complementarity_stats+1e-16,'k',LineWidth=1.5)
grid on
xlabel('$\tau$ [numerical time]','Interpreter','latex')
ylabel('Complementarity residual','Interpreter','latex')