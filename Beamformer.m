clc;
clear all;
close all;

num=128;  
e=0.5;
array=phased.ULA('NumElements', num, 'ElementSpacing', e);

fc=8e6;  
c=physconst('LightSpeed'); 
lambda=c/fc; 
fs=1e6;  
t=0:1/fs:1e-6;  
ang=[60; 0]; 

signal=cos(2*pi*fc*t); 

num_samples=length(t);
finalangs=repmat(ang, 1, num_samples);

received_signal=collectPlaneWave(array, signal, finalangs, fc, c);

beamformer=phased.PhaseShiftBeamformer('SensorArray', array,'OperatingFrequency', fc,'PropagationSpeed', c,'Direction', ang,'WeightsOutputPort', true);

[beamformed_signal, weights]=beamformer(received_signal);

figure;
pattern(array, fc, [-180:180], 0, 'PropagationSpeed', c,'Type', 'powerdb', 'CoordinateSystem', 'polar', 'Weights', weights);
title('Array Radiation Pattern with Beamforming');
