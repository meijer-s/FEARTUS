%% =============================
%  PALM Analysis: Re-Extinction CS
%  =============================

% --- Locate repo root (relative to this script)
thisfile = mfilename('fullpath');
[scriptdir, ~, ~] = fileparts(thisfile);
cd(scriptdir); % Ensure consistent working dir

% Navigate up to FEARTUS root
% palm_code -> permutation_tests -> stats -> FEARTUS
repo_root = fullfile(scriptdir, '..', '..', '..');
repo_root = char(java.io.File(repo_root).getCanonicalPath()); % normalize paths

% --- Add PALM to path (assuming it's in stats/permutation_tests/palm-alpha119)
palm_repo_path = fullfile(repo_root, 'stats', 'permutation_tests', 'palm-alpha119');
if ~exist(palm_repo_path, 'dir')
    error('PALM folder not found at: %s', palm_repo_path);
end
addpath(palm_repo_path);

% --- Define base paths (relative)
basepath = fullfile(repo_root, 'stats', 'permutation_tests');
palm_in  = fullfile(basepath, 'palm_files', 'amy', 'amy_reext_sham_unr_CS');
palm_out = fullfile(basepath, 'palm_results', 'amy', 'amy_reext_sham_unr_CS');

% --- Ensure output directory exists
if ~exist(palm_out, 'dir')
    mkdir(palm_out);
end

%% --- Exchangeability tree ---
EB = csvread(fullfile(palm_in, 'blocks_amy_reext_sham_unr_CS.csv'));
M  = csvread(fullfile(palm_in, 'design_amy_reext_sham_unr_CS.csv'));
EB = palm_reindex(EB, 'fixleaves');
Ptree = palm_tree(EB, M);
palm_ptree2dot(Ptree, fullfile(palm_in, 'exchangeability_amy_reext_sham_unr_CS.dot'));

%% --- Run PALM ---
palm( ...
  '-i',  fullfile(palm_in, 'data_amy_reext_sham_unr_CS.csv'), ...
  '-d',  fullfile(palm_in, 'design_amy_reext_sham_unr_CS.csv'), ...
  '-t',  fullfile(palm_in, 'contrast_amy_reext_sham_unr_CS.csv'), ...
  '-eb', fullfile(palm_in, 'blocks_amy_reext_sham_unr_CS.csv'), ...
  '-Cstat', 'mass', '-C', 1.28, '-T', '-tfce1D', '-tableasvolume', ...
  '-o', fullfile(palm_out, 'PALM_amy_reext_sham_unr_CS'));
