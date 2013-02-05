
% --------------------------------------------------------------------
%                                     Compute a visual word vocabulary
% --------------------------------------------------------------------
%setup ;

% from 50 background images
names{1} = textread('data/admiral.txt','%s') ;
names{2} = textread('data/machaon.txt','%s') ;
names{3} = textread('data/peacock.txt','%s') ;
names{4} = textread('data/swallowtail.txt','%s') ;
names{5} = textread('data/zebra.txt','%s') ;
names = cat(1,names{:})' ;
if ~exist('data/vocabulary.mat')
  %vocabulary = computeVocabularyFromImageList(vl_colsubset(names,200,'uniform')) ;
  vocabulary = computeVocabularyFromImageList(names) ;
  save('data/vocabulary.mat', '-STRUCT', 'vocabulary') ;
else
  vocabulary = load('data/vocabulary.mat') ;
end


%
% Compute histograms
%

for subset = {'admiral', ...
              'admiral_val', ...
              'machaon', ...
              'machaon_val', ...
              'peacock', ...
              'peacock_val', ...
              'swallowtail', ...
              'swallowtail_val', ...
              'zebra', ...
              'zebra_val'}
  fprintf('Processing %s\n', char(subset)) ;
  names = textread(fullfile('data', [char(subset) '.txt']), '%s') ;
  histograms = computeHistogramsFromImageList(vocabulary, names,'../data/cache') ;
  save(fullfile('data',[char(subset) '_hist.mat']), 'names', 'histograms') ;
end