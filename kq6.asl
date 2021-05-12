// Game:        King's Quest VI: Heir Today, Gone Tomorrow
// Emulator:    DOSBox ECE (any recent version, or r4230, or r4180)
// Author:      Dan Lynch

state("DOSBox", "35627008") {
    short           RoomInitial         : "DOSBox.exe", 0x00524670, 0x00023C4A;
    short           ScoreInitial        : "DOSBox.exe", 0x00524670, 0x00023C52;
    short           XPositionInitial    : "DOSBox.exe", 0x00524670, 0x00023DCC;
    short           YPositionInitial    : "DOSBox.exe", 0x00524670, 0x00023DCE;

    short           RoomRestart         : "DOSBox.exe", 0x00524670, 0x00023C6E;
    short           ScoreRestart        : "DOSBox.exe", 0x00524670, 0x00023C76;
    short           XPositionRestart    : "DOSBox.exe", 0x00524670, 0x00023DF0;
    short           YPositionRestart    : "DOSBox.exe", 0x00524670, 0x00023DF2;
}

state("DOSBox", "35631104") {
    short           RoomInitial         : "DOSBox.exe", 0x00525670, 0x00023C4A;
    short           ScoreInitial        : "DOSBox.exe", 0x00525670, 0x00023C52;
    short           XPositionInitial    : "DOSBox.exe", 0x00525670, 0x00023DCC;
    short           YPositionInitial    : "DOSBox.exe", 0x00525670, 0x00023DCE;

    short           RoomRestart         : "DOSBox.exe", 0x00525670, 0x00023C6E;
    short           ScoreRestart        : "DOSBox.exe", 0x00525670, 0x00023C76;
    short           XPositionRestart    : "DOSBox.exe", 0x00525670, 0x00023DF0;
    short           YPositionRestart    : "DOSBox.exe", 0x00525670, 0x00023DF2;
}

state("DOSBox", "36634624") {
    short           RoomInitial         : "DOSBox.exe", 0x00519670, 0x00023C4A;
    short           ScoreInitial        : "DOSBox.exe", 0x00519670, 0x00023C52;
    short           XPositionInitial    : "DOSBox.exe", 0x00519670, 0x00023DCC;
    short           YPositionInitial    : "DOSBox.exe", 0x00519670, 0x00023DCE;

    short           RoomRestart         : "DOSBox.exe", 0x00519670, 0x00023C6E;
    short           ScoreRestart        : "DOSBox.exe", 0x00519670, 0x00023C76;
    short           XPositionRestart    : "DOSBox.exe", 0x00519670, 0x00023DF0;
    short           YPositionRestart    : "DOSBox.exe", 0x00519670, 0x00023DF2;
}

state("DOSBox", "36995072") {
    short           RoomInitial         : "DOSBox.exe", 0x00571670, 0x00023C4A;
    short           ScoreInitial        : "DOSBox.exe", 0x00571670, 0x00023C52;
    short           XPositionInitial    : "DOSBox.exe", 0x00571670, 0x00023DCC;
    short           YPositionInitial    : "DOSBox.exe", 0x00571670, 0x00023DCE;

    short           RoomRestart         : "DOSBox.exe", 0x00571670, 0x00023C6E;
    short           ScoreRestart        : "DOSBox.exe", 0x00571670, 0x00023C76;
    short           XPositionRestart    : "DOSBox.exe", 0x00571670, 0x00023DF0;
    short           YPositionRestart    : "DOSBox.exe", 0x00571670, 0x00023DF2;
}

startup {
    print("KQ6AS: startup action");

    settings.Add("magic_map", true, "Magic map");
    settings.SetToolTip("magic_map", "Split when the genie cutscene begins after you buy the magic map");

    settings.Add("gnomes", false, "Gnomes");
    settings.SetToolTip("gnomes", "Split when you either fool or bypass the gnomes for the first time");

    settings.Add("cliff_base", false, "Base of cliffs");
    settings.SetToolTip("cliff_base", "Split when you arrive at the base of the cliffs for the first time after fooling or bypassing the gnomes");

    settings.Add("cliff_top", true, "Top of cliffs");
    settings.SetToolTip("cliff_top", "Split when you arrive at the top of the cliffs after solving the logic puzzles");

    settings.Add("catacombs", true, "Catacombs");
    settings.SetToolTip("catacombs", "Split when you leave the catacombs for the first time");

    settings.Add("beast", true, "Beauty & Beast");
    settings.SetToolTip("beast", "Split when the gate closes on Beauty and Beast");

    settings.Add("nightmare", false, "Nightmare");
    settings.SetToolTip("nightmare", "Split when you start riding nightmare to travel to the Realm of the Dead");

    settings.Add("samhain", false, "Samhain");
    settings.SetToolTip("samhain", "Split when you start riding nightmare to return from the Realm of the Dead");

    settings.Add("castle", false, "Castle");
    settings.SetToolTip("castle", "Split when you enter the castle either by disguise or magic door");

    settings.Add("vizier", true, "Abdul Alhazred");
    settings.SetToolTip("vizier", "Split when you land the final blow on Abdul Alhazred");

    vars.completed = new HashSet<string>();
    vars.towerPoints = 0;
}

init {
    print("KQ6AS: init action");
    var firstModule = modules.First();
    if (firstModule.ModuleName.ToLower().Contains("dosbox")) {
        version = firstModule.ModuleMemorySize.ToString();
    } else {
        throw new Exception("KQ6AS: unexpected first module name: " + firstModule.ModuleName);
    }

    vars.performSplitWithExtra = (Func<string, string, bool>) ((splitName, extra) => {
        if (!vars.completed.Contains(splitName)) {
            print("KQ6AS: " + splitName + " split" + (extra != null ? " (" + extra + ")" : ""));
            vars.completed.Add(splitName);
            return settings[splitName];
        } else {
            return false;
        }
    });

    vars.performSplit = (Func<string, bool>) ((splitName) => {
        return vars.performSplitWithExtra(splitName, null);
    });
}

update {
    if (current.RoomInitial >= 0 && current.RoomInitial <= 1000
            && current.ScoreInitial >= 0 && current.ScoreInitial <= 231
            && current.XPositionInitial >= 0 && current.XPositionInitial <= 320
            && current.YPositionInitial >= 0 && current.YPositionInitial <= 320) {
        current.Room = current.RoomInitial;
        current.Score = current.ScoreInitial;
        current.XPosition = current.XPositionInitial;
        current.YPosition = current.YPositionInitial;
    } else if (current.RoomRestart >= 0 && current.RoomRestart <= 1000
            && current.ScoreRestart >= 0 && current.ScoreRestart <= 231
            && current.XPositionRestart >= 0 && current.XPositionRestart <= 320
            && current.YPositionRestart >= 0 && current.YPositionRestart <= 320) {
        current.Room = current.RoomRestart;
        current.Score = current.ScoreRestart;
        current.XPosition = current.XPositionRestart;
        current.YPosition = current.YPositionRestart;
    } else {
        return false;
    }

    if (!((IDictionary<String, object>) old).ContainsKey("Room")) {
        return false;
    }

    if (current.Room != old.Room) {
        print("KQ6AS: moved from room " + old.Room + " to room " + current.Room);
    }

    if (current.Score != old.Score) {
        int points = current.Score - old.Score;
        print("KQ6AS: earned " + points + " point" + (Math.Abs(points) == 1 ? "" : "s"));
    }

    switch ((int) current.Room) {
        case 750:
            if (current.Score > old.Score) {
                print("KQ6AS: add tower points");
                vars.towerPoints += current.Score - old.Score;
            }
            break;
        default:
            break;
    }
}

start {
    if (old.Room == 100 && current.Room == 200 && current.Score == 0) {
        print("KQ6AS: start the run");
        vars.completed.Clear();
        vars.towerPoints = 0;
        return true;
    }
}

reset {
    if (current.Room == 100) {
        print("KQ6AS: reset the run");
        vars.completed.Clear();
        vars.towerPoints = 0;
        return true;
    }
}

split {
    switch ((int) current.Room) {
        case 145:
            if (old.Room == 280) {
                return vars.performSplit("magic_map");
            }
            return false;
        case 155:
            if (old.Room == 340) {
                return vars.performSplit("nightmare");
            }
            if (old.Room == 680) {
                return vars.performSplit("samhain");
            }
            return false;
        case 300:
            if (vars.completed.Contains("gnomes")) {
                return vars.performSplit("cliff_base");
            }
            return false;
        case 340:
            if (old.Room == 320) {
                return vars.performSplit("cliff_top");
            }
            if (old.Room == 440) {
                return vars.performSplit("catacombs");
            }
            return false;
        case 450:
            if (current.Score - old.Score == 2 && current.XPosition == 231 && current.YPosition == 129) {
                return vars.performSplitWithExtra("gnomes", "fooled them");
            }
            return false;
        case 460:
            if (old.Room == 450) {
                return vars.performSplitWithExtra("gnomes", "glitched to bookworm");
            }
            return false;
        case 470:
            if (old.Room == 450) {
                return vars.performSplitWithExtra("gnomes", "glitched to swamp");
            }
            return false;
        case 540:
            if (current.Score - old.Score == 2) {
                return vars.performSplit("beast");
            }
            return false;
        case 710:
            if (old.Room == 230) {
                return vars.performSplitWithExtra("castle", "long path");
            }
            return false;
        case 730:
            if (old.Room == 220) {
                return vars.performSplitWithExtra("castle", "short path");
            }
            return false;
        case 750:
            if (current.Score - old.Score == 5 && vars.towerPoints >= 7) {
                return vars.performSplit("vizier");
            }
            return false;
        default:
            return false;
    }
}
