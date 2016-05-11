%% Initialize variables
clear,clc
allPlayers=webread( 'http://www03.myfantasyleague.com/2016/export?TYPE=players&L=&W=&JSON=1');
roster=webread('http://www60.myfantasyleague.com/2016/export?TYPE=rosters&L=76845&W=&JSON=1');
franchise=webread('http://www60.myfantasyleague.com/2016/export?TYPE=league&L=76845&W=&JSON=1');
weekTot=16;
for n=1:weekTot % Get scoring data for every week
    url='http://www59.myfantasyleague.com/2015/export?TYPE=playerScores&JSON=1&L=35465&W=';
    url=strcat(url,num2str(n));
    week(n,:)=webread(url);
end
QB=1; RB=2; WR=3; TE=1; K=1; DEF=1; FLEX=1;
regSeason=13;
%% Create better players array
for g=1:length(allPlayers.players.player)
    players(g).id=allPlayers.players.player{g,1}.id;
    players(g).info.name=allPlayers.players.player{g,1}.name;
    players(g).info.position=allPlayers.players.player{g,1}.position;
    players(g).info.team=allPlayers.players.player{g,1}.team;
end
%% Create raw roster data
teams=length(roster.rosters.franchise);
for k=1:teams % Gets players and franchise name
    for l=1:length(roster.rosters.franchise(k).player)
        rawData(k).franchise = roster.rosters.franchise(k);
        rawData(k).franchise.name = franchise.league.franchises.franchise{k,1}.name;
        rawData(k).franchise.idnum = str2double(roster.rosters.franchise(k).id);
        
    end   
end
for k=1:teams % Adds player data to rawData
    allTeams(k)=str2double(rawData(k).franchise.id);
    for l=1:length(roster.rosters.franchise(k).player)
        index = find(strcmp({rawData(k).franchise.player(l).id}, {players.id})==1);
        if (index ~= 0)
            rawData(k).franchise.player(l).position=players(index).info.position;
            rawData(k).franchise.player(l).name=players(index).info.name;
            rawData(k).franchise.player(l).team=players(index).info.team;
        end 
    end   
end
for h=1:weekTot % Adds weekly player scores to rawData structure
    for t=1:teams
        for r=1:length(rawData(t).franchise.player)
            scores = find(strcmp({rawData(t).franchise.player(r).id},...
                {week(h).playerScores.playerScore.id})==1);
            if (index ~= 0 && ~isempty(scores))
                rawData(t).franchise.player(r).score(h).week=...
                    week(h).playerScores.playerScore(scores).score;
            end 
        end
    end
end
%% Randomize Matchups
for w=1:regSeason
    % This does not play each team once, it currently randomizes each week
    % independent of each other week. This is hopefully temporary, and I
    % will be making each team play each other team 1-2 times
    schedule.week(w).matchup(6,2) = 0;
    schedule.week(w).matchup(:) = allTeams(randperm(numel(allTeams)));
end