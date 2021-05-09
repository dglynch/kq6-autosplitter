// Game:        King's Quest VI: Heir Today, Gone Tomorrow
// Emulator:    DOSBox ECE (any recent version, or r4230)
// Author:      Dan Lynch

state("DOSBox", "35627008") {
    short Room  : "DOSBox.exe", 0x524670, 0x23C4A;
    byte Score  : "DOSBox.exe", 0x524670, 0x23C52;
}

state("DOSBox", "36634624") {
    short Room  : "DOSBox.exe", 0x519670, 0x23C4A;
    byte Score  : "DOSBox.exe", 0x519670, 0x23C52;
}

startup {
    settings.Add("magic_map", true, "Magic map");
    settings.SetToolTip("magic_map", "Split when the genie cutscene begins after you buy the magic map");

    settings.Add("cliff_base", false, "Base of cliffs");
    settings.SetToolTip("cliff_base", "Split when you arrive at the base of the cliffs for the first time");

    settings.Add("cliff_top", true, "Top of cliffs");
    settings.SetToolTip("cliff_top", "Split when you arrive at the top of the cliffs after solving the logic puzzles");

    settings.Add("catacombs", true, "Catacombs");
    settings.SetToolTip("catacombs", "Split when you leave the catacombs for the first time");

    settings.Add("beast", true, "Beauty & Beast");
    settings.SetToolTip("beast", "Split when the gate closes on Beauty and Beast");

    settings.Add("vizier", true, "Abdul Alhazred");
    settings.SetToolTip("vizier", "Split when you land the final blow on Abdul Alhazred");

    vars.completed = new HashSet<string>();
}

init {
    version = modules.First().ModuleMemorySize.ToString();
}

start {
    if (old.Room == 100 && current.Room == 200 && current.Score == 0) {
        vars.completed.Clear();
        return true;
    }
}

reset {
    if (current.Room == 100) {
        vars.completed.Clear();
        return true;
    }
}

split {
    switch ((int) current.Room) {
        case 145:
            if (old.Room == 280) {
                if (!vars.completed.Contains("magic_map")) {
                    vars.completed.Add("magic_map");
                    return settings["magic_map"];
                }
            }
            return false;
        case 300:
            if (!vars.completed.Contains("cliff_base")) {
                vars.completed.Add("cliff_base");
                return settings["cliff_base"];
            }
            return false;
        case 340:
            if (old.Room == 320) {
                if (!vars.completed.Contains("cliff_top")) {
                    vars.completed.Add("cliff_top");
                    return settings["cliff_top"];
                }
            }
            if (old.Room == 440) {
                if (!vars.completed.Contains("catacombs")) {
                    vars.completed.Add("catacombs");
                    return settings["catacombs"];
                }
            }
            return false;
        case 540:
            if (current.Score - old.Score == 2) {
                 if (!vars.completed.Contains("beast")) {
                    vars.completed.Add("beast");
                    return settings["beast"];
                }
            }
            return false;
        case 750:
            if (current.Score - old.Score == 5) {
                if (!vars.completed.Contains("vizier")) {
                    vars.completed.Add("vizier");
                    return settings["vizier"];
                }
            }
            return false;
        default:
            return false;
    }
}
