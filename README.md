Random Folder Play - VLC Extension
----------------------------------

A note from the wetware :

This script and this readme were created in 2 hours, as a quick experience for AI assisted coding. While the script itself is not a breackthrough, I am storing a version here for later improvements and references (and also to support any return of experience I may write about this)

Description
-----------

**Random Folder Play** is a VLC extension script that creates a playlist from the directory of the currently selected item in the VLC UI. Once the playlist is created, the script switches to the playlist view and plays a random item from the playlist. The script is designed to enhance the user experience by automating the process of creating and playing a playlist from a selected folder.

Features
--------

*   Automatically creates a playlist from the directory of the selected item.
*   Switches to the playlist view after creating the playlist.
*   Plays a random item from the newly created playlist.
*   Deactivates itself after completing the actions or if no valid selection is found.

Installation
------------

Windows
-------

1.  Download the `random_folder_play.lua` script.
2.  Copy the script to the VLC extensions directory:```
    %APPDATA%\vlc\lua\extensions\
    ```
    
3.  Restart VLC Media Player.

macOS
-----

1.  Download the `random_folder_play.lua` script.
2.  Copy the script to the VLC extensions directory:```
    /Users/<username>/Library/Application Support/org.videolan.vlc/lua/extensions/
    ```
    
3.  Restart VLC Media Player.

Linux
-----

1.  Download the `random_folder_play.lua` script.
2.  Copy the script to the VLC extensions directory:```
    ~/.local/share/vlc/lua/extensions/
    ```
    
3.  Restart VLC Media Player.

Usage
-----

1.  Open VLC Media Player.
2.  Navigate to the folder containing the media files you want to create a playlist from.
3.  Select any item in the folder.
4.  Go to the `View` menu and select `Random Folder Play`.
5.  The script will create a playlist from the selected item's directory, switch to the playlist view, and play a random item from the playlist.
6.  The script will automatically deactivate itself after completing these actions.

Example
-------

1.  Open VLC and navigate to `C:\Users\YourUsername\Music`.
2.  Select any music file in the folder.
3.  Go to `View` > `Random Folder Play`.
4.  VLC will switch to the playlist view and start playing a random song from the `Music` folder.

How the Script Was Written
--------------------------

The **Random Folder Play** script was developed to enhance the user experience by automating playlist creation and playback in VLC. Here is a brief overview of the development process:

1.  **Initial Setup**: The script was structured to conform to VLC's Lua extension requirements, including defining the `descriptor` function and necessary callback functions like `activate`, `deactivate`, and `trigger`.
2.  **Item Selection**: The script includes logic to identify the currently selected item in the VLC UI, whether it is from the playlist, media library, or browser.
3.  **Directory Handling**: The script converts URI-style paths to Windows-style paths and uses the `dir` command to list files in the selected directory.
4.  **Playlist Creation**: The script creates a playlist from the files found in the selected directory and adds them to VLC's playlist.
5.  **Playback and View Switching**: After creating the playlist, the script switches to the playlist view and plays a random item from the playlist.
6.  **Automatic Deactivation**: The script deactivates itself after completing the actions or if no valid selection is found.

Contributing
------------

Contributions are welcome! If you encounter any issues or have suggestions for improvements, please open an issue or submit a pull request.
