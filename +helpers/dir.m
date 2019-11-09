function files = dir(path)
%LIST_DIRS Call built-in dir on given path and remove dotfiles
files = dir(path);
% remove dot and dotdot folders (macos or linux)
files = files(~ismember({files.name}, {'.', '..'}));

end

