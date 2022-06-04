cd ~/Downloads
wget http://old-releases.ubuntu.com/ubuntu/pool/universe/n/ncbi-vdb/libncbi-vdb2_2.9.3+dfsg-2_amd64.deb
wget http://old-releases.ubuntu.com/ubuntu/pool/universe/n/ncbi-vdb/libncbi-wvdb2_2.9.3+dfsg-2_amd64.deb
wget http://old-releases.ubuntu.com/ubuntu/pool/universe/s/sra-sdk/sra-toolkit_2.9.3+dfsg-1build2_amd64.deb

sudo apt-get install ./libncbi-vdb2_2.9.3+dfsg-2_amd64.deb
sudo apt-get install ./libncbi-wvdb2_2.9.3+dfsg-2_amd64.deb

cat <<EOF | sudo tee /etc/apt/preferences.d/pin-sra-libs
Package: libncbi-vdb2
Pin: version 2.9.3+dfsg-2
Pin-Priority: 1337

Package: libncbi-wvdb2
Pin: version 2.9.3+dfsg-2
Pin-Priority: 1337
EOF

sudo apt-get install ./sra-toolkit_2.9.3+dfsg-1build2_amd64.deb
