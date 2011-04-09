These are my dot files.  At the time of writing this I just have some bash things and my vim settings, plugins, and some modifications I've made to them.

Using the setup of having a generic `.dotfiles` folder to house the repository and having the actual dot files be replaced with links to the contents of `.dotfiles` is actually someone else's idea.  I would give them credit here but I've forgotten who they were.

Installation
------------
To install my dot files, you need to clone the git repository into
a specific folder (`.dotfiles`) and then run the install script.

Any dot files of yours that would be over-written are saved to `.olddotfiles` and can be restored by running the uninstall script.

### Clone the git repository:
    cd ~/
    git clone git://github.com/cpdean/gpd.dotfiles.git .dotfiles
### Run the installer
    bash ~/.dotfiles/install.sh
The install script will move all the dot files that would've been
overwritten to a folder called `.olddotfiles` in your home directory.
Then it creates symbolic links to the contents of `.dotfiles` so you can update them through git commands later.
### Want to uninstall?
    bash ~/.dotfiles/uninstall.sh
This script removes the links and copies your previous dot files back into place. After you make sure your dot files have been put back properly (try a `ls -lda ~/.v*` and a `ls -lda ~/.b*`) you can delete `.dotfiles` and `.olddotfiles`.
