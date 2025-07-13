
cd $(dirname $0)

grep "$(pwd)" $HOME/.bashrc >/dev/null 2>&1 || {
    echo "Adding $(pwd) to $HOME/.bashrc"
cat >> $HOME/.bashrc <<-EOF
[ -f $(pwd)/.bashrc ] && source $(pwd)/.bashrc
EOF
}

cat > $HOME/.bash_profile <<-EOF
if [ -f $HOME/.bashrc ]; then
   source $HOME/.bashrc
fi
EOF