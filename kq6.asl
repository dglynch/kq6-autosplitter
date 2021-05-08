// Game:        King's Quest VI: Heir Today, Gone Tomorrow
// Emulator:    DOSBox ECE (any recent version)
// Author:      Dan Lynch

state("DOSBox") {
    short Room  : "DOSBox.exe", 0x524670, 0x23C4A;
    byte Score  : "DOSBox.exe", 0x524670, 0x23C52;
}

startup {
    settings.Add("magic_map", true, "Magic map");
    settings.SetToolTip("magic_map", "Split when the genie cutscene begins after you buy the magic map");

    settings.Add("cliff_base", false, "Base of cliffs");
    settings.SetToolTip("cliff_base", "Split when you arrive at the cliffs from the Isle of the Beast");

    settings.Add("cliff_top", true, "Top of cliffs");
    settings.SetToolTip("cliff_top", "Split when you arrive at the top of the cliffs after solving the logic puzzles");

    settings.Add("catacombs", true, "Catacombs");
    settings.SetToolTip("catacombs", "Split when you leave the catacombs");

    settings.Add("beast", true, "Beauty & Beast");
    settings.SetToolTip("beast", "Split when the gate closes on Beauty and Beast");

    settings.Add("vizier", true, "Abdul Alhazred");
    settings.SetToolTip("vizier", "Split when you land the final blow on Abdul Alhazred");
}

start {
    return old.Room == 100 && current.Room == 200;
}

reset {
    return current.Room == 100;
}

split {
    switch ((int) current.Room) {
        case 145:
            return settings["magic_map"] && old.Room == 280;
        case 300:
            return settings["cliff_base"] && old.Room == 500;
        case 340:
            if (old.Room == 320) {
                return settings["cliff_top"];
            }
            if (old.Room == 440) {
                return settings["catacombs"];
            }
            return false;
        case 540:
            return settings["beast"] && current.Score - old.Score == 2;
        case 750:
            return settings["vizier"] && current.Score - old.Score == 5;
        default:
            return false;
    }
}
