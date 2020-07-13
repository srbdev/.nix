# make and change to directory
mkcd() {
  mkdir -p $1
  cd $1
}

# mark and jump
export MARKPATH=$HOME/.marks

jump() {
  cd -P $MARKPATH/$1 2>/dev/null || echo "No such mark: $1"
}

jumpo() {
  open $MARKPATH/$1 2>/dev/null || echo "No such mark: $1"
}

mark() {
  mkdir -p $MARKPATH; ln -s $(pwd) $MARKPATH/$1
}

unmark() {
  rm -i $MARKPATH/$1
}

marks() {
  \ls -l $MARKPATH | tail -n +2 | sed 's/  / /g' | cut -d' ' -f9- | awk -F ' -> ' '{printf "%-10s -> %s\n", $1, $2}'
}

alias j='jump'
