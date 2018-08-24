# local customizations
if [ -e $HOME/.localsetup ]
	. $HOME/.localsetup
end

# Set up virtualfish
eval (python3 -m virtualfish compat_aliases auto_activation)

