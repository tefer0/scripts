
#remove r
sudo apt-get remove r-base-core
sudo apt-get autoremove

#add new repo
sudo apt install dirmngr gnupg apt-transport-https ca-certificates software-properties-common

#add CRAN repo with key
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'

#versions
apt-cache showpkg r-base

#install
sudo apt-get install r-base-core=4.1.1-1.2004.0

#check version
R --version

#essential packs
sudo apt install build-essential
