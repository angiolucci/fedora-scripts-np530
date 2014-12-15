if [ $(id -u) -eq 0 ];
then
  PS1="\\[$(tput setaf 1)\\][\\u@\\h:\\w]\\$\\[$(tput sgr0)\\] "
else
  PS1="[\\u@\\h:\\w]\\$ "
fi
