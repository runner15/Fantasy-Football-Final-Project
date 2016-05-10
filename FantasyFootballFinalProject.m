%% Initialize variables
clear,clc
allPlayers=webread( 'http://www03.myfantasyleague.com/2016/export?TYPE=players&L=&W=&JSON=1');
roster=webread('http://www60.myfantasyleague.com/2016/export?TYPE=rosters&L=76845&W=&JSON=1');
franchise=webread('http://www60.myfantasyleague.com/2016/export?TYPE=league&L=76845&W=&JSON=1');
for n=1:17 % Get scoring data for every week
    url='http://www59.myfantasyleague.com/2015/export?TYPE=playerScores&JSON=1&L=35465&W=';
    url=strcat(url,num2str(n));
    week(n,:)=webread(url);
end
%% Create better players array
for g=1:length(allPlayers.players.player)
    players(g).id=allPlayers.players.player{g,1}.id;
    players(g).info.name=allPlayers.players.player{g,1}.name;
    players(g).info.position=allPlayers.players.player{g,1}.position;
    players(g).info.team=allPlayers.players.player{g,1}.team;
end
%% Create raw roster data
for k=1:length(roster.rosters.franchise)
    for l=1:length(roster.rosters.franchise(k).player)
        rawData(k).franchise = roster.rosters.franchise(k);
        rawData(k).franchise.name = franchise.league.franchises.franchise{k,1}.name;
    end   
end
for k=1:length(roster.rosters.franchise)
    for l=1:length(roster.rosters.franchise(k).player)
        index = find(strcmp({rawData(k).franchise.player(l).id}, {players.id})==1);
        if (index ~= 0)
            rawData(k).franchise.player(l).position=players(index).info.position;
            rawData(k).franchise.player(l).name=players(index).info.name;
            rawData(k).franchise.player(l).team=players(index).info.team;
        end 
    end   
end