SM = load('Monthly.txt');

[M,N]= size(SM);

train=0.7;
test=0.3;

S=SM(1:floor(0.7*M));
S1=SM(floor(0.7*M)+1:M);