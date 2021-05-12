// Game:        King's Quest VI: Heir Today, Gone Tomorrow
// Emulator:    DOSBox ECE (any recent version, or r4230, or r4180)
// Author:      Dan Lynch

state("DOSBox", "35627008") {
    short Room      : "DOSBox.exe", 0x524670, 0x23C4A;
    byte Score      : "DOSBox.exe", 0x524670, 0x23C52;
    short XPosition : "DOSBox.exe", 0x524670, 0x23DCC;
    short YPosition : "DOSBox.exe", 0x524670, 0x23DCE;
}

state("DOSBox", "35631104") {
    short Room      : "DOSBox.exe", 0x525670, 0x23C4A;
    byte Score      : "DOSBox.exe", 0x525670, 0x23C52;
    short XPosition : "DOSBox.exe", 0x525670, 0x23DCC;
    short YPosition : "DOSBox.exe", 0x525670, 0x23DCE;
}

state("DOSBox", "36634624") {
    short Room      : "DOSBox.exe", 0x519670, 0x23C4A;
    byte Score      : "DOSBox.exe", 0x519670, 0x23C52;
    short XPosition : "DOSBox.exe", 0x519670, 0x23DCC;
    short YPosition : "DOSBox.exe", 0x519670, 0x23DCE;
}

state("DOSBox", "36995072") {
    short Room      : "DOSBox.exe", 0x571670, 0x23C4A;
    byte Score      : "DOSBox.exe", 0x571670, 0x23C52;
    short XPosition : "DOSBox.exe", 0x571670, 0x23DCC;
    short YPosition : "DOSBox.exe", 0x571670, 0x23DCE;
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
    vars.splitOptions = new Dictionary<string, bool>();
    vars.optionalSplits = new List<string>() {
        "magic_map",
        "gnomes",
        "cliff_base",
        "cliff_top",
        "catacombs",
        "beast",
        "nightmare",
        "samhain",
        "castle",
        "vizier"
    };

    vars.performSplitWithExtra = (Func<string, string, bool>) ((splitName, extra) => {
        if (!vars.completed.Contains(splitName)) {
            print("KQ6AS: " + splitName + " split" + (extra != null ? " (" + extra + ")" : ""));
            vars.completed.Add(splitName);
            return vars.splitOptions[splitName];
        } else {
            return false;
        }
    });

    vars.performSplit = (Func<string, bool>) ((splitName) => {
        return vars.performSplitWithExtra(splitName, null);
    });
}

init {
    print("KQ6AS: init action");
    version = modules.First().ModuleMemorySize.ToString();
}

update {
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

    foreach (string split in vars.optionalSplits) {
       vars.splitOptions[split] = settings[split];
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
