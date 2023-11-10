{config, pkgs, ...}:
{

 services.syncthing = {
    enable = true;
    user = "theloremaster";
    dataDir = "/home/theloremaster/Documentos";
    configDir = "/home/theloremaster/Documentos/.config/syncthing";
    overrideDevices = true;     # overrides any devices added or deleted through the WebUI
    overrideFolders = true;     # overrides any folders added or deleted through the WebUI
    extraOptions.gui = {
        user = "Loremaster";
        password = "CometoMeallyouwhoarewearyandburdenedandIwillgiveyourest";
    };
    devices = {
        "iPhone Invertido" = { id = "XKKPZ4J-M7E5J3J-ZEZQ23F-4VXUMQW-EHCYCKE-4GA7BG3-Q5YP7ME-QOW6QAJ"; };
    };
    folders = {
        "Obsidian Notes" = {        # Name of folder in Syncthing, also the folder ID
         path = "/home/theloremaster/Documentos/Obsidian\ Notes/";    # Which folder to add to Syncthing
         devices = [ "iPhone Invertido"];      # Which devices to share the folder with
         };
    };
 };

}
