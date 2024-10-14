function im = makeRGB(R, G, B)

Lx=size(R,1); Ly=size(R,2);
im=zeros(Lx,Ly,3);

if ~isempty(R)
    im(:,:,1)=R;
end
if ~isempty(G)
    im(:,:,2)=G;
end
if ~isempty(B)
    im(:,:,3)=B;
end

end