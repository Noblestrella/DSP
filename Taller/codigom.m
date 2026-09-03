%% EJERCICIO 1
% Composición de señales discretas a partir de señales elementales
% Nombre: Joseph Alexander Guerra Villalba
% Grupo: 21

clear;
clc;
close all;

%% Vector de tiempo discreto
n = -20:20;


%% 1. PULSO RECTANGULAR A PARTIR DE ESCALONES u[n]


% Definición del escalón unitario
u1 = double(n >= 0);
u2 = double(n >= 6);

% Pulso rectangular:
% x[n] = u[n] - u[n-6]
x_rect = u1 - u2;

% Transformaciones

% Desplazamiento: x[n-3]
x_desplazada = double(n-3 >= 0) - double(n-3 >= 6);

% Reflexión: x[-n]
x_reflejada = double(-n >= 0) - double(-n >= 6);

% Escalado de amplitud
x_escalada = 2 * x_rect;



%% GRAFICAS DEL PULSO RECTANGULAR


figure;

subplot(4,1,1);
stem(n, x_rect, 'filled');
grid on;
title('Pulso rectangular x[n] = u[n] - u[n-6]');
xlabel('n');
ylabel('Amplitud');

subplot(4,1,2);
stem(n, x_desplazada, 'filled');
grid on;
title('Desplazamiento: x[n-3]');
xlabel('n');
ylabel('Amplitud');

subplot(4,1,3);
stem(n, x_reflejada, 'filled');
grid on;
title('Reflexión: x[-n]');
xlabel('n');
ylabel('Amplitud');

subplot(4,1,4);
stem(n, x_escalada, 'filled');
grid on;
title('Escalado de amplitud: 2x[n]');
xlabel('n');
ylabel('Amplitud');



%% 2. SECUENCIA FINITA COMO SUMA DE IMPULSOS
%% x[n] = SUMA x[k] delta[n-k]


% Valores de la secuencia
k = [-3 -2 -1 0 1 2 3];
xk = [2 1 -1 3 2 -2 1];

% Inicializar señal
x_impulsos = zeros(size(n));

% Construcción mediante impulsos desplazados
for i = 1:length(k)
    
    % Delta[n-k]
    delta = double(n == k(i));
    
    % x[k] * delta[n-k]
    x_impulsos = x_impulsos + xk(i)*delta;
    
end


%% Grafica de la secuencia construida

figure;

stem(n, x_impulsos, 'filled');
grid on;
title('Secuencia finita construida como suma de impulsos desplazados');
xlabel('n');
ylabel('x[n]');



%% TRANSFORMACIONES DE LA SECUENCIA DE IMPULSOS


% Desplazamiento hacia la derecha: x[n-2]
x_imp_desplazada = zeros(size(n));

for i = 1:length(k)
    delta = double(n == k(i)+2);
    x_imp_desplazada = x_imp_desplazada + xk(i)*delta;
end


% Reflexión x[-n]
x_imp_reflejada = zeros(size(n));

for i = 1:length(k)
    delta = double(n == -k(i));
    x_imp_reflejada = x_imp_reflejada + xk(i)*delta;
end


% Escalado
x_imp_escalada = 3*x_impulsos;


figure;

subplot(3,1,1);
stem(n, x_imp_desplazada, 'filled');
grid on;
title('Secuencia desplazada x[n-2]');
xlabel('n');
ylabel('Amplitud');

subplot(3,1,2);
stem(n, x_imp_reflejada, 'filled');
grid on;
title('Secuencia reflejada x[-n]');
xlabel('n');
ylabel('Amplitud');

subplot(3,1,3);
stem(n, x_imp_escalada, 'filled');
grid on;
title('Secuencia escalada 3x[n]');
xlabel('n');
ylabel('Amplitud');



%% 3. TREN DE PULSOS PERIODICO


% Periodo
N = 8;

% Ancho del pulso
L = 3;

% Inicializar señal
tren_pulsos = zeros(size(n));

% Construcción del tren periódico
for i = 1:length(n)
    
    % Pulso activo durante L muestras
    if mod(n(i), N) >= 0 && mod(n(i), N) < L
        tren_pulsos(i) = 1;
    end
    
end


%% Transformaciones del tren de pulsos

% Desplazamiento
tren_desplazado = zeros(size(n));

for i = 1:length(n)
    
    if mod(n(i)-2, N) >= 0 && mod(n(i)-2, N) < L
        tren_desplazado(i) = 1;
    end
    
end


% Reflexión
tren_reflejado = zeros(size(n));

for i = 1:length(n)
    
    if mod(-n(i), N) >= 0 && mod(-n(i), N) < L
        tren_reflejado(i) = 1;
    end
    
end


% Escalado
tren_escalado = 2*tren_pulsos;



%% GRAFICAS DEL TREN DE PULSOS


figure;

subplot(4,1,1);
stem(n, tren_pulsos, 'filled');
grid on;
title('Tren de pulsos periódico');
xlabel('n');
ylabel('Amplitud');

subplot(4,1,2);
stem(n, tren_desplazado, 'filled');
grid on;
title('Tren desplazado');
xlabel('n');
ylabel('Amplitud');

subplot(4,1,3);
stem(n, tren_reflejado, 'filled');
grid on;
title('Tren reflejado');
xlabel('n');
ylabel('Amplitud');

subplot(4,1,4);
stem(n, tren_escalado, 'filled');
grid on;
title('Tren escalado en amplitud');
xlabel('n');
ylabel('Amplitud');
