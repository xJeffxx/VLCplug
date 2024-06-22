-- VLC Lua extension script to create a playlist from the current selection or its folder

function descriptor()
    return {
        title = "Random Folder Play",
        version = "4.1",
        author = "AI Assistant",
        url = "http://example.com",
        shortdesc = "Create playlist from current selection",
        description = "Creates a playlist from the directory of the currently selected item in VLC UI",
        capabilities = {"input-listener"}
    }
end

-- Prefix for log outputs
local log_prefix = "[Random Folder Play] "

-- Function to log messages
function log(message)
    vlc.msg.info(log_prefix .. message)
end

-- Function to get the directory of a file path
function get_directory(file_path)
    return string.match(file_path, "(.*[/\\])")
end

-- Function to check if a path is likely a directory
function is_likely_directory(path)
    return string.match(path, "[/\\]$") ~= nil
end

-- Function to convert URI to Windows-style path
function uri_to_path(uri)
    local path = string.gsub(uri, "^file:///", "")
    path = string.gsub(path, "/", "\\")
    return path
end

-- Function to create a playlist from a directory
function create_playlist_from_directory(directory)
    local playlist = {}
    local windows_directory = uri_to_path(directory)
    local command = 'dir "' .. windows_directory .. '" /b /a-d'
    log("Executing command: " .. command)
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()

    log("Command result: " .. result)

    for file in string.gmatch(result, "[^\r\n]+") do
        local file_path = windows_directory .. "\\" .. file
        log("Found file: " .. file_path)
        table.insert(playlist, { path = "file:///" .. file_path })
    end

    return playlist
end

-- Function to get the currently selected item in VLC UI
function get_selected_item()
    -- Try to get the current input item
    local input = vlc.object.input()
    if input then
        local item = vlc.input.item()
        if item then
            log("Found current input item")
            return item
        end
    end

    -- Try to get the selected item from the playlist
    local playlist = vlc.playlist.get("playlist")
    if playlist then
        for _, item in ipairs(playlist) do
            if item.flags.selected then
                log("Found selected item in playlist")
                return item
            end
        end
    end

    -- Try to get the selected item from the media library
    if vlc.ml then
        local ml = vlc.ml.get()
        if ml then
            local media = ml:get_media()
            if media then
                log("Found selected item in media library")
                return media
            end
        end
    end

    -- Try to get the selected item from the browser
    if vlc.browser then
        local browser = vlc.browser()
        if browser then
            local selected = browser:get_selection()
            if selected and #selected > 0 then
                log("Found selected item in browser")
                return selected[1]
            end
        end
    end

    log("No selected item found")
    return nil
end

-- Function to safely get URI from item
function get_item_uri(item)
    if type(item.uri) == "function" then
        return item:uri()
    elseif type(item.uri) == "string" then
        return item.uri
    elseif type(item.path) == "string" then
        return item.path
    else
        return nil
    end
end

-- Function to switch to playlist view
function switch_to_playlist_view()
    vlc.osd.message("Switching to playlist view")
    vlc.playlist.show()
end

-- Function to play a random item from the playlist
function play_random_item()
    local playlist = vlc.playlist.get("playlist")
    if playlist and #playlist > 0 then
        local random_index = math.random(1, #playlist)
        vlc.playlist.goto(random_index)
        vlc.playlist.play()
        log("Playing random item: " .. playlist[random_index].path)
    else
        log("Playlist is empty, cannot play random item")
    end
end

-- Main function to create and play the playlist
function create_and_play_playlist()
    log("Script started")

    -- Get the currently selected item in VLC UI
    local item = get_selected_item()
    if not item then
        log("No item selected in VLC UI")
        return false
    end

    local uri = get_item_uri(item)
    if not uri then
        log("No URI found for the selected item")
        return false
    end

    log("Selected URI: " .. uri)

    -- Convert URI to file path
    local file_path = vlc.strings.decode_uri(uri)
    log("Decoded file path: " .. file_path)

    -- Check if the selection is likely a file or a directory
    local directory
    if is_likely_directory(file_path) then
        directory = file_path
    else
        directory = get_directory(file_path)
    end

    if not directory then
        log("Failed to determine directory")
        return false
    end

    log("Directory: " .. directory)

    -- Create a playlist from the directory
    local playlist = create_playlist_from_directory(directory)
    if #playlist == 0 then
        log("No media files found in the directory")
        return false
    end

    -- Clear the current playlist and add the new items
    vlc.playlist.clear()
    for _, item in ipairs(playlist) do
        vlc.playlist.enqueue({ { path = item.path } })
        log("Added to playlist: " .. item.path)
    end

    -- Switch to playlist view
    switch_to_playlist_view()

    -- Play a random item from the playlist
    play_random_item()

    log("Script finished successfully")
    return true
end

-- Function to activate the extension
function activate()
    local success = create_and_play_playlist()
    if not success then
        log("Script execution failed, deactivating")
    end
    deactivate()
end

-- Function called when the extension is deactivated
function deactivate()
    vlc.deactivate()
end

-- Function called on every input change
function input_changed()
end

-- Function called when the extension is clicked in the menu
function trigger()
    activate()
end

-- Function called when metadata changes (required by VLC)
function meta_changed()
end

-- Function to create the dialog (required by VLC)
function menu()
    return {"Random Folder Play"}
end

-- Function called when an item in the menu is selected (required by VLC)
function close()
end