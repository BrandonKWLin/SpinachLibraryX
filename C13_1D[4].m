% Modified Spinach File to make it compatible with 4 13C carbon atoms. 
% This is not an increment/loop. While this works, this is still a W.I.P.
function C13_1D[4]()

% Isotopes
sys.isotopes = {'13C', '13C', '13C', '13C'};  % 4 spins

% Magnetic induction
sys.magnet = 21.1;

% Chemical shifts
inter.zeeman.scalar = {10.0, 40, 70, 100};  % 4 chemical shifts

% Scalar couplings (4x4 matrix required)
inter.coupling.scalar = {
    0,   50,   0,   0;  % Couplings for spin 1
   50,    0,  55,   0;  % Couplings for spin 2
    0,   55,    0,   0; % Couplings for spin 3
    0,    0,    0,   0   % Couplings for spin 4
};

% Relaxation model
inter.relaxation = {'t1_t2'};
inter.rlx_keep = 'diagonal';
inter.r1_rates = num2cell(1.0 * ones(1, 4));  % Updated for 4 spins
inter.r2_rates = num2cell(3.0 * ones(1, 4));  % Updated for 4 spins
inter.equilibrium = 'zero';

% Basis set
bas.formalism = 'sphten-liouv';
bas.approximation = 'IK-2';
bas.connectivity = 'scalar_couplings';
bas.space_level = 1;

% Spinach housekeeping
spin_system = create(sys, inter);
spin_system = basis(spin_system, bas);

% Sequence parameters
parameters.spins = {'13C'};
parameters.rho0 = state(spin_system, 'L+', '13C', 'cheap');
parameters.coil = state(spin_system, 'L+', '13C', 'cheap');
parameters.decouple = {};
parameters.offset = 10000;
parameters.sweep = 25000;
parameters.npoints = 8192;
parameters.zerofill = 16536;
parameters.axis_units = 'ppm';
parameters.invert_axis = 1;

% Simulation
fid = liquid(spin_system, @acquire, parameters, 'nmr');

% Apodization
fid = apodization(fid, 'gaussian-1d', 10);

% Fourier transform
spectrum = fftshift(fft(fid, parameters.zerofill));

% Plotting
figure(); 
plot_1d(spin_system, real(spectrum), parameters);

end
