class CfgPatches
{
    class fox_uncon_spectator
    {
        name = "Ace Unconscious Spectator";
        author = "Foxymilyan";
        url = "";

        requiredVersion = 2.14;
   

        requiredAddons[] =
        {
            "cba_main",
            "ace_main",
            "ace_medical",
            "ace_spectator"
        };

    units[] = {};
    weapons[] = {};
    
    };
};

class CfgFunctions
{
    class FXUCS
    {
        class uncon_spectator
        {
            file = "\f\fox\addons\spectator\functions";

            class init
            {
                postInit = 1;
            };

            class openSpectator {};
            class closeSpectator {};
        };
    };
};
