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
}

init {
    print("KQ6AS: init action");
    version = modules.First().ModuleMemorySize.ToString();
}

update {
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
                if (!vars.completed.Contains("magic_map")) {
                    print("KQ6AS: map split");
                    vars.completed.Add("magic_map");
                    return settings["magic_map"];
                }
            }
            return false;
        case 155:
            if (old.Room == 340) {
                if (!vars.completed.Contains("nightmare")) {
                    print("KQ6AS: nightmare split");
                    vars.completed.Add("nightmare");
                    return settings["nightmare"];
                }
            }
            if (old.Room == 680) {
                if (!vars.completed.Contains("samhain")) {
                    print("KQ6AS: samhain split");
                    vars.completed.Add("samhain");
                    return settings["samhain"];
                }
            }
            return false;
        case 300:
            if (vars.completed.Contains("gnomes")) {
                if (!vars.completed.Contains("cliff_base")) {
                    print("KQ6AS: cliff base split");
                    vars.completed.Add("cliff_base");
                    return settings["cliff_base"];
                }
            }
            return false;
        case 340:
            if (old.Room == 320) {
                if (!vars.completed.Contains("cliff_top")) {
                    print("KQ6AS: cliff top split");
                    vars.completed.Add("cliff_top");
                    return settings["cliff_top"];
                }
            }
            if (old.Room == 440) {
                if (!vars.completed.Contains("catacombs")) {
                    print("KQ6AS: catacombs split");
                    vars.completed.Add("catacombs");
                    return settings["catacombs"];
                }
            }
            return false;
        case 450:
            if (current.Score - old.Score == 2 && current.XPosition == 231 && current.YPosition == 129) {
                 if (!vars.completed.Contains("gnomes")) {
                    print("KQ6AS: gnomes split (fooled them)");
                    vars.completed.Add("gnomes");
                    return settings["gnomes"];
                }
            }
            return false;
        case 460:
            if (old.Room == 450) {
                if (!vars.completed.Contains("gnomes")) {
                    print("KQ6AS: gnomes split (glitched to bookworm)");
                    vars.completed.Add("gnomes");
                    return settings["gnomes"];
                }
            }
            return false;
        case 470:
            if (old.Room == 450) {
                if (!vars.completed.Contains("gnomes")) {
                    print("KQ6AS: gnomes split (glitched to swamp)");
                    vars.completed.Add("gnomes");
                    return settings["gnomes"];
                }
            }
            return false;
        case 540:
            if (current.Score - old.Score == 2) {
                 if (!vars.completed.Contains("beast")) {
                    print("KQ6AS: beast split");
                    vars.completed.Add("beast");
                    return settings["beast"];
                }
            }
            return false;
        case 710:
            if (old.Room == 230) {
                if (!vars.completed.Contains("castle")) {
                    print("KQ6AS: castle split (long path)");
                    vars.completed.Add("castle");
                    return settings["castle"];
                }
            }
            return false;
        case 730:
            if (old.Room == 220) {
                if (!vars.completed.Contains("castle")) {
                    print("KQ6AS: castle split (short path)");
                    vars.completed.Add("castle");
                    return settings["castle"];
                }
            }
            return false;
        case 750:
            if (current.Score - old.Score == 5 && vars.towerPoints >= 7) {
                if (!vars.completed.Contains("vizier")) {
                    print("KQ6AS: vizier split");
                    vars.completed.Add("vizier");
                    return settings["vizier"];
                }
            }
            return false;
        default:
            return false;
    }
}
