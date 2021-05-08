// Game:        King's Quest VI: Heir Today, Gone Tomorrow
// Emulator:    DOSBox ECE (any recent version)
// Author:      Dan Lynch

state("DOSBox") {
    short Room  : "DOSBox.exe", 0x524670, 0x23C4A;
    byte Score  : "DOSBox.exe", 0x524670, 0x23C52;
}

startup {
    settings.Add("cliff_base", false, "Base of cliffs");
    settings.SetToolTip("cliff_base", "Split when you arrive at the cliffs from the Isle of the Beast");
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
            return old.Room == 280;
        case 300:
            if (settings["cliff_base"]) {
                return old.Room == 500;
            }
            return false;
        case 340:
            return old.Room == 320 || old.Room == 440;
        case 540:
            return current.Score - old.Score == 2;
        case 750:
            return current.Score - old.Score == 5;
        default:
            return false;
    }
}
