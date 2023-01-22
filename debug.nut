class CDebugConsole {
    DebugConsole = GUIListbox();

    sW = GUI.GetScreenSize().X;
    sH = GUI.GetScreenSize().Y;

    IsEnabled = false;

    ERROR = {
        color = "[#ff0000]",
        prefix = "ERROR: "
    }

    INFO = {
        color = "[#a3ff00]",
        prefix = "INFO: "
    }

    info = {
        Count = 0,
        LastInfo = ""
    };

    err = {
        Count = 0,
        LastError = ""
    };

    function ErrorHandler(err) {
        local stackInfos = getstackinfos(2);
    
        if (stackInfos) {
            local callStacks = "";
            local level = 2;
            do {
                local message = (stackInfos.src == "Main Script" ? "script/main.nut" : stackInfos.src) + ":" + stackInfos.line + ":" + err;
                CDebugConsole.AddError(message);
                level++;
            } while((stackInfos = getstackinfos(level)));
        }
    }

    function constructor() {
        DebugConsole.Size = VectorScreen(sH * 0.75, sH * 0.16);
        DebugConsole.Pos = VectorScreen(sW * 0.21, sH * 0.75);
        DebugConsole.FontName = "Bahnschrift";
        DebugConsole.FontFlags = GUI_FFLAG_BOLD;
        DebugConsole.RemoveFlags(GUI_FLAG_BACKGROUND | GUI_FLAG_BORDER | GUI_FLAG_VISIBLE | GUI_FLAG_TABSTOP);
        DebugConsole.AddFlags(GUI_FLAG_TEXT_TAGS | GUI_FLAG_TEXT_SHADOW);
        DebugConsole.TextColour = Colour(255, 255, 255, 255);
        DebugConsole.FontSize = sH * 0.015;

        seterrorhandler(this.ErrorHandler);
    }

    function AddError(text) {
        if (CDebugConsole.err.LastError == ERROR.prefix + text) {
            if (CDebugConsole.err.Count > 0) {
                DebugConsole.RemoveItem(CDebugConsole.err.LastError + " [DUP x" + (CDebugConsole.err.Count + 1) + "]");
            }
            else {
                DebugConsole.RemoveItem(CDebugConsole.err.LastError);
            }

            DebugConsole.AddItem(ERROR.color + ERROR.prefix + text + " [DUP x" + (CDebugConsole.err.Count + 2) + "]");
            CDebugConsole.err.Count++;
        }
        else if (CDebugConsole.err.LastError != (ERROR.prefix + text)) {
            DebugConsole.AddItem(ERROR.color + ERROR.prefix + text);
            CDebugConsole.err.Count = 0;

            CDebugConsole.err.LastError = ERROR.prefix + text;
        }
    }

    function AddInfo(text) {
        if (CDebugConsole.info.LastInfo == INFO.prefix + text) {
            if (CDebugConsole.info.Count > 0) {
                DebugConsole.RemoveItem(CDebugConsole.info.LastInfo + " [DUP x" + (CDebugConsole.info.Count + 1) + "]");
            }
            else {
                DebugConsole.RemoveItem(CDebugConsole.info.LastInfo);
            }

            DebugConsole.AddItem(INFO.color + INFO.prefix + text + " [DUP x" + (CDebugConsole.info.Count + 2) + "]");
            CDebugConsole.info.Count++;
        }
        else if (CDebugConsole.info.LastInfo != (INFO.prefix + text)) {
            DebugConsole.AddItem(INFO.color + INFO.prefix + text);
            CDebugConsole.info.Count = 0;

            CDebugConsole.info.LastInfo = INFO.prefix + text;
        }
    }

    function Toggle(bool) {
        bool ? DebugConsole.AddFlags(GUI_FLAG_VISIBLE) : DebugConsole.RemoveFlags(GUI_FLAG_VISIBLE);
    }
}

CDebugConsole();