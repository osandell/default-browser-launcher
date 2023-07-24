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

on JSONtoRecord from fp
    local fp

    set JSONdata to NSData's dataWithContentsOfFile:fp

    set [x, E] to (NSJSONSerialization's JSONObjectWithData:JSONdata options:0 error:(reference))

    if E is not equal to missing value then error E

    tell x to if its isKindOfClass:NSDictionary then
        return it as record
    end if

    return x as list
end JSONtoRecord

--------------------------------------------------------------------------------

on shouldRedirectToSpecificBrowser(targetUrl, browserName)
    set home to the path to home folder
    set f to the POSIX path of home & "dev/osandell/default-browser-launcher/extension/redirections.json"
    
    set browserRedirections to JSONtoRecord from f
    
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
end shouldRedirectToSpecificBrowser

--------------------------------------------------------------------------------

on run {targetUrl}
    # Specific sites for opening in Work browser
    if shouldRedirectToSpecificBrowser(targetUrl, "Google Chrome Work") then
        tell application "Google Chrome Work" to open location targetUrl

    # Specific sites for opening in Dev browser
    else if shouldRedirectToSpecificBrowser(targetUrl, "Google Chrome Dev") then
        tell application "Google Chrome Dev" to open location targetUrl

    # We open most sites in the Work instance since that's where we have 1password and a lot of sites require us to log in
    else if targetUrl contains "http" then
        tell application "Google Chrome Work" to open location targetUrl
		
    # We open files i.e. html files etc. in the original Chrome instance since they are a lot of times also related to development
    else
        tell application "Google Chrome Dev" to open location targetUrl
    end if
end run
