% Clear workspace and close figures
clc;
clear all;
close all;

% Step 1: Define Sensor Array
num_elements = 128;  % Number of elements in the array
element_spacing = 0.5; % Half-wavelength spacing
array = phased.ULA('NumElements', num_elements, 'ElementSpacing', element_spacing);

% Step 2: Define Signal Properties
carrier_frequency = 8e6;  % Carrier frequency in Hz (8 MHz)
c = physconst('LightSpeed'); % Speed of light
lambda = c / carrier_frequency; % Wavelength
fs = 1e6;  % Sampling frequency in Hz
t = 0:1/fs:1e-3;  % Time vector (1 ms duration)
incidentAngle = [60; 0]; % Desired direction in azimuth and elevation (degrees)

% Step 3: Generate a Test Signal
signal = cos(2 * pi * carrier_frequency * t); % Example signal

% Step 4: Replicate the Incident Angle
num_samples = length(t);
finalIncidentAngles = repmat(incidentAngle, 1, num_samples);

% Step 5: Simulate Arrival of Plane Wave
received_signal = collectPlaneWave(array, signal, finalIncidentAngles, carrier_frequency, c);

% Step 6: Apply Beamforming
beamformer = phased.PhaseShiftBeamformer('SensorArray', array, ...
    'OperatingFrequency', carrier_frequency, ...
    'PropagationSpeed', c, ...
    'Direction', incidentAngle, ...
    'WeightsOutputPort', true);

% Beamforming the received signal
[beamformed_signal, weights] = beamformer(received_signal);

% Step 7: Plot the Waveforms
figure;
subplot(2, 1, 1);
plot(t, real(received_signal(:,1)));
title('Received Signal at Array Element 1');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2, 1, 2);
plot(t, real(beamformed_signal));
title('Beamformed Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Step 8: Visualize Array Pattern
figure;
pattern(array, carrier_frequency, [-180:180], 0, 'PropagationSpeed', c, ...
    'Type', 'powerdb', 'CoordinateSystem', 'polar', 'Weights', weights);
title('Array Radiation Pattern with Beamforming');
