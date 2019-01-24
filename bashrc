# for go
export PATH="$PATH:$HOME/go/bin"

# for vscode
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# for gcloud
if [ -d /usr/local/Caskroom/google-cloud-sdk/ ]; then
	. /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc
	. /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc
fi

export HISTSIZE=50000
export HISTFILESIZE=50000
export EDITOR=vim

# git bash autocomplete
if [ -f `brew --prefix`/etc/bash_completion ]; then
	source `brew --prefix`/etc/bash_completion
fi

function shortDirs {
	echo -n "$(dirs | perl -F/ -ane 'print join( "/", map { $i++ < @F - 1 ?  substr $_,0,1 : $_ } @F)')"
}

function odenGCPProject {
	if [ -f ~/.config/gcloud/active_config ]; then
		local project=$(cat ~/.config/gcloud/active_config | xargs -I{} grep project ~/.config/gcloud/configurations/config_{} | cut -d ' ' -f 3)
		local project=$(echo $project | cut -c 6-)  # cut the "oden-" prefix
		echo -n "[$project]"
	fi
}

export PS1="\$(odenGCPProject) \$(shortDirs)\$(__git_ps1) ● "

# 256 colors in tmux
alias tmux="tmux -2"

# shortcuts for common tools
alias v="vagrant"
alias k="kubectl"
alias p="ipython"

# set up ssh-agent with my private key
if [ -z "$SSH_AUTH_SOCK" ] ; then eval `ssh-agent -s` && ssh-add; fi

# If using pyenv, it's helpful to always point the cloudsdk python to system and bypass the shimmed one
export CLOUDSDK_PYTHON=/usr/bin/python

# if installed, use pyenv python
if command -v pyenv 1>/dev/null 2>&1; then eval "$(pyenv init -)"; fi
if command -v pyenv-virtualenv 1>/dev/null 2>&1; then eval "$(pyenv virtualenv-init -)"; fi

# docker aliases
alias docker-kill-all="docker ps | tail -n +2 | cut -d ' ' -f 1 | xargs docker kill"

# oden aliases
alias qa="gcloud config set project oden-qa \
	&& gcloud container clusters get-credentials services-1 --zone us-central1-a --project oden-qa"
alias prod="gcloud config set project oden-production \
       && gcloud container clusters get-credentials services-1 --zone us-east1-d --project oden-production"
alias cg="cd $HOME/go/src/github.com/odentech/"
alias watchbuild="gcloud builds list --ongoing | head -2 | tail -1 | cut -d ' ' -f 1 | xargs -I{} gcloud builds log --stream {}"

function pulljson {
	gcloud beta pubsub subscriptions pull $@ --format="json(ackId, message.attributes, message.data.decode(\"base64\"), message.messageId, message.publishTime)" --limit 1000
}
