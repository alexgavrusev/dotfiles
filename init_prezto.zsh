setopt EXTENDED_GLOB
for rcfile in "${ZPREZTODIR}"/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR}/.${rcfile:t}"
done
