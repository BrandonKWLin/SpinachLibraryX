% 1H NMR spectrum of rotenone using T1/T2 relaxation model,
% magnetic parameters from:
% 
%         http://dx.doi.org/10.1002/jhet.5570250160
%
% Calculation time: seconds
%
% matthew.krzystyniak@oerc.ox.ac.uk
% i.kuprov@soton.ac.uk

function C13_1D[2]()

% Isotopes
sys.isotopes={'13C','13C','13C'};
% Magnetic induction
sys.magnet=21.1;

% Chemical shifts
inter.zeeman.scalar={20.0 50 80};

% Scalar couplings
inter.coupling.scalar{1,2}=38; 
inter.coupling.scalar{2,3}=55; 
inter.coupling.scalar{1,3}=0.0; 
inter.coupling.scalar{3,3}=0; 
% Relaxation model
inter.relaxation={'t1_t2'};
inter.rlx_keep='diagonal';
inter.r1_rates=num2cell(1.0*ones(1,3));
inter.r2_rates=num2cell(3.0*ones(1,3));
inter.equilibrium='zero';

% Basis set
bas.formalism='sphten-liouv';
bas.approximation='IK-2';
bas.connectivity='scalar_couplings';
bas.space_level=1;
%bas.sym_group={'S3','S3','S3'};
%bas.sym_spins={[14 15 16],[17 18 19],[20 21 22]};

% Spinach housekeeping
spin_system=create(sys,inter);
spin_system=basis(spin_system,bas);

% Sequence parameters
parameters.spins={'13C'};
parameters.rho0=state(spin_system,'L+','13C','cheap');
parameters.coil=state(spin_system,'L+','13C','cheap');
parameters.decouple={};
parameters.offset=10000;
parameters.sweep=25000;
parameters.npoints=8192;
parameters.zerofill=16536;
parameters.axis_units='ppm';
parameters.invert_axis=1;

% Simulation
fid=liquid(spin_system,@acquire,parameters,'nmr');

% Apodization
fid=apodization(fid,'gaussian-1d',10);

% Fourier transform
spectrum=fftshift(fft(fid,parameters.zerofill));

% Plotting
figure(); plot_1d(spin_system,real(spectrum),parameters);

end

