export CLICOLOR='true'
export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home
export XAMPP_HOME=/Applications/xampp
export PATH=$PATH:~/bin:/usr/local/bin:$JAVA_HOME/bin:/usr/local/git/bin/git-tools:~/code/code_swarm/bin
export SVN_EDITOR=vim
test -r /sw/bin/init.sh && . /sw/bin/init.sh

# MacPorts Installer addition on 2011-02-11_at_16:07:43: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:/opt/local/lib/postgresql91/bin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

WORKON_HOME=~/python
source /opt/local/bin/virtualenvwrapper.sh-2.6

alias vi="vim"
alias vim=/Applications/MacPorts/MacVim.app/Contents/MacOS/Vim
alias ..="cd .."
alias br="git br"
alias pwd="pwd && git branch 2> /dev/null"
alias st="git st"
alias add="git add"
alias pull="git pull --rebase"
alias push="git push"
alias stash="git stash"
alias tree="git log --graph --oneline"
#alias mysql="mysql -u root -pr00t"
alias testkuma="python manage.py test actioncounters contentflagging demos devmo landing search wiki"
alias testmdn="python manage.py test actioncounters contentflagging dekicompat demos devmo landing users"
