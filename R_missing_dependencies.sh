#!/bin/bash

#Script to install missing dependencies in any R version 
sudo apt-get update

sudo apt-get install r-base-dev

sudo apt-get install liblapack-dev libblas-dev libssl-dev libcurl4-openssl-dev libxml2-dev
