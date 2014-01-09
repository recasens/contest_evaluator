function visualizemodel(model, components, layers)

% visualizemodel(model)
% Visualize a model.

clf;
if nargin < 2
  components = 1:length(model.rules{model.start});
end

if nargin < 3
  layers = 1;
end

k = 1;
for i = components
  for layer = layers
    visualizecomponent(model, i, length(layers)*length(components), k, layer);
    k = k+1;
  end
end

function visualizecomponent(model, c, nc, k, layer)

rhs = model.rules{model.start}(c).rhs;
root = -1;
parts = [];
defs = {};
anchors = {};
% assume the root filter is first on the rhs of the start rules
if model.symbols(rhs(1)).type == 'T'
  % handle case where there's no deformation model for the root
  root = model.symbols(rhs(1)).filter;
else
  % handle case where there is a deformation model for the root
  root = model.symbols(model.rules{rhs(1)}(layer).rhs).filter;
end
for i = 2:length(rhs)
  defs{end+1} = model.rules{rhs(i)}(layer).def.w;
  anchors{end+1} = model.rules{model.start}(c).anchor{i};
  fi = model.symbols(model.rules{rhs(i)}(layer).rhs).filter;
  parts = [parts fi];
end
% make picture of root filter
pad = 1;
bs = 20;
w = model.filters(root).w;
scale = max(w(:));

ratio = 0;

im = HOGpicture(w, bs);
im = uint8(im * (255/scale));
%im = uint8(ratio * double(im) + (1 - ratio) * double(im2uint8(imresize(invertHOG(max(w, 0)), [size(im,1) size(im,2)]))));
im = imresize(im, 2);
im = padarray(im, [pad pad], 0);

% draw root
numparts = length(parts);
if numparts > 0
  subplot(nc,3,1+3*(k-1));
else
  subplot(nc,1,k);
end
imagesc(im)
colormap gray;
axis equal;
axis off;
title(sprintf('%i x %i', size(w,1), size(w,2)));

%imwrite(im, sprintf('models/color/%s_%i_root.jpg', model.class, k));

% draw parts and deformation model
if numparts > 0
  def_im = zeros(size(im));
  def_scale = 500;
  for i = 1:numparts
    % part filter
    w = model.filters(parts(i)).w;
    p = HOGpicture(w, bs);
    p = uint8(p * (255/scale));    
    %p = uint8(ratio * double(p) + (1-ratio) * double(im2uint8(imresize(invertHOG(max(w,0)), [size(p,1) size(p,2)]))));
    p = padarray(p, [pad pad], 0);
    % border 
    p(:,1:2*pad, :) = 128;
    p(:,end-2*pad+1:end, :) = 128;
    p(1:2*pad,:,:) = 128;
    p(end-2*pad+1:end,:,:) = 128;
    % paste into root
    x1 = (anchors{i}(1))*bs+1;
    y1 = (anchors{i}(2))*bs+1;
    x2 = x1 + size(p, 2)-1;
    y2 = y1 + size(p, 1)-1;
    im(y1:y2, x1:x2, :) = p;

    % deformation model
    probex = size(p,2)/2;
    probey = size(p,1)/2;
    for y = 2*pad+1:size(p,1)-2*pad
      for x = 2*pad+1:size(p,2)-2*pad
        px = ((probex-x)/bs);
        py = ((probey-y)/bs);
        v = [px^2; px; py^2; py];
        p(y, x) = defs{i} * v * def_scale;
      end
    end
    def_im(y1:y2, x1:x2, :) = p;
  end

  imwrite(im, sprintf('models/color/%s_%i_parts.jpg', model.class, k));
    
  
  % plot parts
  subplot(nc,3,2+3*(k-1));
  imagesc(im); 
  colormap gray;
  axis equal;
  axis off;
  
  % plot deformation model
  subplot(nc,3,3+3*(k-1));
  def_im(def_im > 1) = 1;
  def_im(def_im < 0) = 0;
  imagesc(def_im);
  colormap gray;
  axis equal;
  axis off;
end

set(gcf, 'Color', 'white')