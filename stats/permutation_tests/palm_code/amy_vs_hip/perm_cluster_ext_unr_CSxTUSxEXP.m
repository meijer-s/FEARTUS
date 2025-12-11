%% =============================
%  PALM Analysis: EXT CS×TUS×EXP
%  =============================

% --- Locate repo root (relative to this script)
thisfile = mfilename('fullpath');
[scriptdir, ~, ~] = fileparts(thisfile);
cd(scriptdir); % Ensure consistent working dir

% stats/permutation_tests/palm_code/<thisfile>
% Go up to FEARTUS root
repo_root = fullfile(scriptdir, '..', '..', '..');
repo_root = char(java.io.File(repo_root).getCanonicalPath()); % normalize

% --- Add PALM to path (under stats/permutation_tests)
addpath(fullfile(repo_root, 'stats', 'permutation_tests', 'palm-alpha119'));

% --- Define base paths (relative)
basepath = fullfile(repo_root, 'stats', 'permutation_tests');
palm_in  = fullfile(basepath, 'palm_files',   'amy_vs_hip', 'ext_unr_CSxTUSxEXP');
palm_out = fullfile(basepath, 'palm_results', 'amy_vs_hip', 'ext_unr_CSxTUSxEXP');

% --- Ensure output directory exists
if ~exist(palm_out, 'dir')
    mkdir(palm_out);
end

%% --- Exchangeability tree ---
EB = csvread(fullfile(palm_in, 'blocks_ext_unr_CSxTUSxEXP.csv'));
M  = csvread(fullfile(palm_in, 'design_ext_unr_CSxTUSxEXP.csv'));
EB = palm_reindex(EB, 'fixleaves');
Ptree = palm_tree(EB, M);
palm_ptree2dot(Ptree, fullfile(palm_in, 'exchangeability_ext_unr_CSxTUSxEXP.dot'));

%% --- Run PALM ---
palm( ...
  '-i',  fullfile(palm_in, 'data_ext_unr_CSxTUSxEXP.csv'), ...
  '-d',  fullfile(palm_in, 'design_ext_unr_CSxTUSxEXP.csv'), ...
  '-t',  fullfile(palm_in, 'contrast_ext_unr_CSxTUSxEXP.csv'), ...
  '-eb', fullfile(palm_in, 'blocks_ext_unr_CSxTUSxEXP.csv'), ...
  '-Cstat', 'mass', '-C', 1.28, '-T', '-tfce1D', '-tableasvolume', ...
  '-o',  fullfile(palm_out, 'PALM_ext_unr_CSxTUSxEXP'));
