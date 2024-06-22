use framework "Foundation"
use scripting additions
--------------------------------------------------------------------------------
property ca : a reference to current application
property NSData : a reference to ca's NSData
property NSDictionary : a reference to ca's NSDictionary
property NSJSONSerialization : a reference to ca's NSJSONSerialization
property NSString : a reference to ca's NSString
property NSUTF8StringEncoding : a reference to 4
--------------------------------------------------------------------------------
on JSONtoRecord(fp)
    local fp
    
    set JSONdata to NSData's dataWithContentsOfFile:fp
    
    set [x, E] to (NSJSONSerialization's Â
        JSONObjectWithData:JSONdata Â
            options:0 Â
            |error|:(reference))
    
    if E ­ missing value then error E
    
    tell x to if its isKindOfClass:NSDictionary then Â
        return it as record
    
    x as list
end JSONtoRecord

--------------------------------------------------------------------------------

on shouldRedirectToSpecificBrowser(targetUrl, browserName)
    try
        set home to the path to home folder
        set f to the POSIX path of home & "dev/osandell/default-browser-launcher/extension/redirections.json"
        set browserRedirections to JSONtoRecord(f)
        
        repeat with i from 1 to (count of browserRedirections)
            if (browser of item i of browserRedirections is browserName) then

                set chromeWhitelist to urlsWhitelist of item i of browserRedirections
                
                repeat with j from 1 to (count of chromeWhitelist)
                    if (targetUrl contains (item j of chromeWhitelist as string)) then
                        return true
                    end if
                end repeat
            end if
        end repeat
        return false
    on error errMsg number errNum
        display dialog "Error in shouldRedirectToSpecificBrowser: " & errMsg
        error errMsg number errNum
    end try
end shouldRedirectToSpecificBrowser

--------------------------------------------------------------------------------

on run {targetUrl}
    try
        # Specific sites for opening in Work browser
        if shouldRedirectToSpecificBrowser(targetUrl, "FF Work") then
            tell application "FF Work" to open location targetUrl
            tell application "FF Work" to activate
            
        # Specific sites for opening in Dev browser
        else if shouldRedirectToSpecificBrowser(targetUrl, "Google Chrome") then
            tell application "Google Chrome" to open location targetUrl
            tell application "Google Chrome" to activate

        # Specific sites for opening in YouTube browser
        else if shouldRedirectToSpecificBrowser(targetUrl, "FF YouTube") then
            tell application "FF YouTube" to open location targetUrl
            tell application "FF YouTube" to activate

        # We open most sites in the Work instance since that's where we have 1password and a lot of sites require us to log in
        else if targetUrl contains "http" then
            tell application "FF Work" to open location targetUrl
            tell application "FF Work" to activate
        
        # We open files i.e. html files etc. in the original Chrome instance since they are a lot of times also related to development
        else
            tell application "Google Chrome" to open location targetUrl
            tell application "Google Chrome" to activate
        end if
    on error errMsg number errNum
        display dialog "Error in run handler: " & errMsg
        error errMsg number errNum
    end try
end run
