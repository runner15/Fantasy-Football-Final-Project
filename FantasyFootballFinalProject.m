%% Initialize variables
clear,clc
allPlayers=webread( 'http://www03.myfantasyleague.com/2016/export?TYPE=players&L=&W=&JSON=1');
roster=webread('http://www60.myfantasyleague.com/2016/export?TYPE=rosters&L=76845&W=&JSON=1');
franchise=webread('http://www60.myfantasyleague.com/2016/export?TYPE=league&L=76845&W=&JSON=1');
for n=1:17
    url='http://www59.myfantasyleague.com/2015/export?TYPE=playerScores&JSON=1&L=35465&W=';
    url=strcat(url,num2str(n));
    week(n,:)=webread(url);
end
%% Create better players array
for j=1:length(allPlayers.players.player)
    players(j).id=allPlayers.players.player{j,1}.id;
    players(j).info.name=allPlayers.players.player{j,1}.name;
    players(j).info.position=allPlayers.players.player{j,1}.position;
    players(j).info.team=allPlayers.players.player{j,1}.team;
end
%% Create raw roster data
allRostersMat = zeros(19,12);
for k=1:length(roster.rosters.franchise)
    for i=1:length(roster.rosters.franchise(k).player)
        allRostersMat(i,k) = str2double(roster.rosters.franchise(k).player(i,1).id);
        rawData(k).franchise = roster.rosters.franchise(k);
        rawData(k).franchise.name = franchise.league.franchises.franchise{k,1}.name;
        index = find(strcmp({rawData(k).franchise.player(i).id}, {players.id})==1);
        if (index ~= 0)
            indexraw(i,k) = index;
        end
    end
end
rawData(1).franchise.player(2).id