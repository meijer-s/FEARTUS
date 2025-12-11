%% =============================
%  PALM Analysis: ACQ CS×TUS×EXP
%  =============================

% --- Locate repo root (relative to this script)
thisfile = mfilename('fullpath');
[scriptdir, ~, ~] = fileparts(thisfile);
cd(scriptdir); % ensure consistent working dir

% Navigate up to FEARTUS root: stats/permutation_tests/palm_code/*thisfile*
repo_root = fullfile(scriptdir, '..', '..', '..');
repo_root = char(java.io.File(repo_root).getCanonicalPath()); % normalize

% --- Add PALM to path (you placed it under stats/permutation_tests/palm-alpha119)
addpath(fullfile(repo_root, 'stats', 'permutation_tests', 'palm-alpha119'));

% --- Define base paths (relative)
basepath = fullfile(repo_root, 'stats', 'permutation_tests');
palm_in  = fullfile(basepath, 'palm_files',   'amy_vs_hip', 'acq_unr_CSxTUSxEXP');
palm_out = fullfile(basepath, 'palm_results', 'amy_vs_hip', 'acq_unr_CSxTUSxEXP');

% --- Ensure output directory exists
if ~exist(palm_out, 'dir')
    mkdir(palm_out);
end

%% --- Exchangeability tree ---
EB = csvread(fullfile(palm_in, 'blocks_acq_unr_CSxTUSxEXP.csv'));
M  = csvread(fullfile(palm_in, 'design_acq_unr_CSxTUSxEXP.csv'));
EB = palm_reindex(EB, 'fixleaves');
Ptree = palm_tree(EB, M);
palm_ptree2dot(Ptree, fullfile(palm_in, 'exchangeability_acq_unr_CSxTUSxEXP.dot'));

%% --- Render exchangeability tree (circo) ---
dotfile = fullfile(palm_in, 'exchangeability_acq_unr_CSxTUSxEXP.dot');
svgfile = fullfile(palm_in, 'ptree_acq_unr_CSxTUSxEXP.svg');

% Make sure common locations are on PATH (Homebrew/Intel/MacPorts)
setenv('PATH', [getenv('PATH') ':/opt/homebrew/bin:/usr/local/bin:/opt/local/bin']);

% Prefer circo; fall back to dot -Kcirco if circo isn't found
[status, ~] = system('which circo');
if status == 0
    cmd = sprintf('circo "%s" -Tsvg -o "%s"', dotfile, svgfile);
else
    cmd = sprintf('dot -Kcirco "%s" -Tsvg -o "%s"', dotfile, svgfile);
end
system(cmd);

fprintf('Wrote SVG: %s\n', svgfile);

%% --- Run PALM ---
palm( ...
  '-i',  fullfile(palm_in, 'data_acq_unr_CSxTUSxEXP.csv'), ...
  '-d',  fullfile(palm_in, 'design_acq_unr_CSxTUSxEXP.csv'), ...
  '-t',  fullfile(palm_in, 'contrast_acq_unr_CSxTUSxEXP.csv'), ...
  '-eb', fullfile(palm_in, 'blocks_acq_unr_CSxTUSxEXP.csv'), ...
  '-Cstat', 'mass', '-C', 1.28, '-T', '-tfce1D', '-tableasvolume', ...
  '-o',  fullfile(palm_out, 'PALM_acq_unr_CSxTUSxEXP'));
