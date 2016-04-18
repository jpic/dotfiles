# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH
if [ -e /home/jpic/.nix-profile/etc/profile.d/nix.sh ]; then . /home/jpic/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
