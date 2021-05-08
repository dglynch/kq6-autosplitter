// Game:        King's Quest VI: Heir Today, Gone Tomorrow
// Emulator:    DOSBox ECE (any recent version)
// Author:      Dan Lynch

state("DOSBox") {
    short Room  : "DOSBox.exe", 0x524670, 0x23C4A;
    byte Score  : "DOSBox.exe", 0x524670, 0x23C52;
}

startup {
    settings.Add("cliff_base", false, "Split at base of cliffs");
}

start {
    return old.Room == 100 && current.Room == 200;
}

reset {
    return current.Room == 100;
}

split {
    if (current.Room == 145) {
        return old.Room == 280;
    } else if (current.Room == 300 && settings["cliff_base"]) {
        return old.Room == 500;
    } else if (current.Room == 340) {
        return old.Room == 320 || old.Room == 440;
    } else if (current.Room == 540) {
        return current.Score - old.Score == 2;
    } else if (current.Room == 750) {
        return current.Score - old.Score == 5;
    }
}
