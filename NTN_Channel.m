
commonParams = struct;
commonParams.CarrierFrequency = 1e9;              % In Hz

commonParams.SatelliteAltitude = 600000;          % In m
commonParams.SatelliteSpeed = 7340; %7562.2;             % In m/s
commonParams.MobileSpeed = 0.8*1000/3600;           % In m/s
commonParams.SampleRate = 500000;                % In Hz
% Set the random stream and seed, for reproducibility
commonParams.RandomStream = "mt19937ar with seed";

% Set the number of sinusoids used in generation of Doppler spread
commonParams.NumSinusoids = 48;

% Number of users on Earth
for k=1:64

commonParams.ElevationAngle = 10+0.64*k;                 % In degrees
commonParams.Seed = 73*k;

% Initialize the NTN TDL channel parameters in a structure
ntnTDLParams = commonParams;
ntnTDLParams.NTNChannelType = "TDL";
ntnTDLParams.DelayProfile = "NTN-TDL-D";
ntnTDLParams.DelaySpread =(sqrt(6378^2 * sin(commonParams.ElevationAngle*pi/180)^2 +(commonParams.SatelliteAltitude/1000)^2 +2*6378*(commonParams.SatelliteAltitude/1000)) - 6378*sin(commonParams.ElevationAngle*pi/180))/(3*(10^5)); %6e-3;                          % In s
ntnTDLParams.TransmissionDirection = "Downlink";
ntnTDLParams.MIMOCorrelation = "Low";
ntnTDLParams.Polarization = "Co-Polar";
% Modify the below parameters, when DelayProfile is set to Custom
%ntnTDLParams.PathDelays = 0;                               % In s
%ntnTDLParams.AveragePathGains = 0;                         % In dB
ntnTDLParams.FadingDistribution = "Rician";
ntnTDLParams.Environment= "Suburban"
%ntnTDLParams.NormalizePathGains=false;
%ntnTDLParams.NormalizeChannelOutputs=false;
% Set the antenna configuration
% Modify the below parameters, when MIMOCorrelation is set to a value other
% than Custom
ntnTDLParams.NumTransmitAntennas = 32;
ntnTDLParams.NumReceiveAntennas = 2;
% Modify the below parameters, when MIMOCorrelation is set to Custom and
% Polarization is set to Co-Polar or Cross-Polar
%ntnTDLParams.TransmitCorrelationMatrix = 1;
%ntnTDLParams.ReceiveCorrelationMatrix = [1 0; 0 1];
% Modify the below parameters, when MIMOCorrelation is set to Custom and
% Polarization is set to Cross-Polar
%ntnTDLParams.TransmitPolarizationAngles = [45 -45];        % In degrees
%ntnTDLParams.ReceivePolarizationAngles = [90 0];           % In degrees
%ntnTDLParams.XPR = 10;                                     % In dB
% Modify the below parameters, when both MIMOCorrelation and Polarization
% are set to Custom
%ntnTDLParams.SpatialCorrelationMatrix = [1 0; 0 1];

in = complex(randn(50,ntnTDLParams.NumTransmitAntennas), ...
    randn(50,ntnTDLParams.NumTransmitAntennas));
% Generate a random input
%rng(commonParams.Seed);
ntnTDLChan = HelperSetupNTNChannel(ntnTDLParams);
% in = complex(randn(commonParams.SampleRate,tdlChanInfo.NumTransmitAntennas), ...
%     randn(commonParams.SampleRate,tdlChanInfo.NumTransmitAntennas));
% Generate the faded waveform for NTN TDL channel
[tdlOut,tdlPathGains(k,:,:,:,:),tdlSampleTimes] = HelperGenerateNTNChannel(ntnTDLChan,in);
end

