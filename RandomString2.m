function String = RandomString2(n)

% generates a random string of lower case letters of length n
% n must be less than the number of possible letters
% elements of the returned string are exclusive

LetterStore = char(97:122); % string containing all allowable letters (in this case lower case only)
Idx = randperm(length(LetterStore));
String = LetterStore(Idx(1:n));