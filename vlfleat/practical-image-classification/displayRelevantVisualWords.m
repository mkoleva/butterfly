function displayRelevantVisualWords(im, w)
% DISPLAYRELEVANTVISUALWORDS  Display relevant visual words from an image
%   DISPLAYRELEVANTVISUALWORDS(IM, W) displays in sequence the visual
%   words in the vector SELECTION. A visual word is displayed as a
%   sample of the patches in the image IM that match the most relevant
%   visual words according to the calssifier W.

% Author: Andrea Vedaldi

if isstr(im)
  if exist(im, 'file')
    fullPath = im ;
  else
    fullPath = fullfile('data','images',[im '.png']) ;
  end
  im = imread(fullPath) ;
end
im0 = standardizeImage(im) ;

vocabulary = load('data/vocabulary.mat') ;
numWords = size(vocabulary.words,2) ;

width = size(im,2) ;
height= size(im,1) ;
[keypoints, descriptors] = computeFeatures(im) ;
[words, distances] = quantizeDescriptors(vocabulary, descriptors) ;
histogram = computeHistogram(width, height, keypoints, words) ;
% histogram = sqrt(histogram) ;

weights = w .* histogram ;

[scores, perm] = sort(weights, 'descend') ;
perm = mod(perm-1, numWords) + 1 ;
words = mod(words-1, numWords) + 1 ;

for k = 1:length(perm)

  % find the visual words equal to word0
  word0 = perm(k) ;
  inds = find(words == word0) ;
  if isempty(inds), continue ; end

  [drop, perm_] = sort(distances(inds), 'descend') ;
  perm_ = vl_colsubset(perm_, 25*25, 'beginning') ;

  patches = cell(1, numel(perm_)) ;
  for j = 1:numel(perm_)
    u0 = keypoints(1,inds(perm_(j))) ;
    v0 = keypoints(2,inds(perm_(j))) ;
    s0 = keypoints(4,inds(perm_(j))) ;

    delta = round(s0*2) ;
    u1 = max(1,u0-delta) ;
    u2 = min(size(im0,2),u0+delta) ;
    v1 = max(1,v0-delta) ;
    v2 = min(size(im0,1),v0+delta) ;
    patches{j} = imresize(im0(v1:v2,u1:u2,:),[32 32]) ;
  end

  if isempty(patches)
    warning('Skipping visual word %d as no matches fonud', selection(k)) ;
    continue ;
  end

  figure(100) ; clf ;
  subplot(1,2,1) ;
  composite = cat(4,patches{:}) ;
  composite = max(0,min(1,composite)) ;
  [drop, perm__] = sort(distances(inds(perm_)), 'descend') ;
  composite = composite(:,:,:,perm__) ;
  if ndims(composite) > 3
    vl_imarray(composite) ;
  else
    image(composite) ;
  end
  set(gca,'xtick',[],'ytick',[]) ; axis image ;
  axis image ;
  title(sprintf('Visual word %d (rank %d, weight * count %f)', word0, k, scores(perm_(j))));

  subplot(1,2,2) ;
  imagesc(im0) ; hold on ;
  kp = keypoints([1 2 4], inds) ;
  kp(3,:) = kp(3,:) * 2 ;
  vl_plotframe(kp, 'linewidth', 2) ;
  axis image ;

  drawnow ;
  fprintf('Press any key to advance. Press Ctrl-C to stop.\n') ;
  pause ;
end
