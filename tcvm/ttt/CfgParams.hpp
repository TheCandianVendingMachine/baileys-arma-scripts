class tcvm_ttt_ParamDebugMode {
    title = "Debug Mode";   
    values[] = {0, 1};
    texts[] = {"False", "True"};
    default = 0;
};
class tcvm_ttt_ParamTimeLimit {
    title = "Time Limit";   
    values[] = {5, 8, 10, 15, 20, 25, 30};
    default = 8;
};
class tcvm_ttt_ParamTraitorCount {
    title = "Traitor Count";   
    values[] = {10, 9, 8, 7, 6, 5, 4, 3, 2};
    texts[] = {"1 in 10", "1 in 9", "1 in 8", "1 in 7", "1 in 6", "1 in 5", "1 in 4", "1 in 3", "1 in 2"};
    default = 4;
};
class tcvm_ttt_ParamTraitorStartingMoney {
    title = "Traitor Starting Money";
    values[] = {0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100};
    default = 30;
};
class tcvm_ttt_ParamDetectiveCount {
    title = "Detective Count";   
    values[] = {10, 9, 8, 7, 6, 5, 4, 3, 2};
    texts[] = {"1 in 10", "1 in 9", "1 in 8", "1 in 7", "1 in 6", "1 in 5", "1 in 4", "1 in 3", "1 in 2"};
    default = 8;
};
class tcvm_ttt_ParamDetectiveStartingMoney {
    title = "Detective Starting Money";
    values[] = {0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100};
    default = 30;
};
class tcvm_ttt_ParamGunSpawnCount {
    title = "Amount of Guns that spawn initially";
    values[] = {25, 50, 100, 150, 200};
    default = 100;
};
class tcvm_ttt_ParamEnableDetectives {
    title = "Enable Detectives";
    values[] = {0, 1};
    texts[] = {"No", "Yes"};
    default = 1;
};
class tcvm_ttt_ParamDnaDecayTime {
    title = "DNA Decay Time";
    values[] = {30, 60, 120, 180, 240, 300};
    texts[] = {"0:30", "1:00", "2:00", "3:00", "4:00", "5:00"};
    default = 120;
};