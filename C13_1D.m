% Modified Spinach File that loops inter.coupling.scalar{1,2} = 50 “+ 1”
function C13_1D()

% Isotopes
sys.isotopes={'13C','13C','13C'};
% Magnetic induction
sys.magnet=21.1;

% Chemical shifts
inter.zeeman.scalar={10.0, 40, 70};

% Loop to increment scalar coupling and generate figures
for increment = 0:99  % Adjust the range as needed
    % Scalar couplings
    inter.coupling.scalar{1,2} = 50 + increment;  % Increment each time
    inter.coupling.scalar{2,3} = 55;
    inter.coupling.scalar{1,3} = 0.0;
    inter.coupling.scalar{3,3} = 0;

    % Relaxation model
    inter.relaxation = {'t1_t2'};
    inter.rlx_keep = 'diagonal';
    inter.r1_rates = num2cell(1.0 * ones(1, 3));
    inter.r2_rates = num2cell(3.0 * ones(1, 3));
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
    title(['Scalar Coupling {1,2} = ', num2str(50 + increment)]);  % Add a title to each figure
end

