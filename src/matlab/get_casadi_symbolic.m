import casadi.*

function sym = get_casadi_symbolic(type, name, size)
    if nargin < 3
        size = 1;
    end
    if strcmp(type, 'SX')
        sym = SX.sym(name, size);
    elseif strcmp(type, 'MX')
        sym = MX.sym(name, size);
    end
end

% tests
% type = 'SX'

% x = get_ca_symbolic(type, 'x', [3, 1]);
% disp(x)

% y = get_ca_symbolic(type, 'y', [2, 2]);

% disp(y)

% y = get_ca_symbolic(type, 'y');
% disp(y)