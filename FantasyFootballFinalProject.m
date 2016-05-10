clear,clc
allPlayers=webread( 'http://www03.myfantasyleague.com/2016/export?TYPE=players&L=&W=&JSON=1');
roster=webread('http://www60.myfantasyleague.com/2016/export?TYPE=rosters&L=76845&W=&JSON=1');
for n=1:17
    url='http://www59.myfantasyleague.com/2015/export?TYPE=playerScores&JSON=1&L=35465&W=';
    url=strcat(url,num2str(n));
    week(n,:)=webread(url);
end
%{
fname = 'players.json';
fid = fopen(fname);
raw = fread(fid,inf);
allPlayers = char(raw');
fclose(fid);
data = JSON.parse(allPlayers);
%}

for n = 1:length(allPlayers.players.player)
    fprintf('Players name: %s\n', ...
        allPlayers.players.player{n,1}.name)
end