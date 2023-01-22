dofile("debug.nut");

CDebugConsole.Toggle(true);
CDebugConsole.AddInfo("Test!");

local t = Script.GetTicks();

function Script::ScriptProcess() {
    if (Script.GetTicks() > t + 15000) {
        t = Script.GetTicks();
        0/0 // generate the error
    }
}