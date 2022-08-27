#! /bin/bash

sudo quicksilverd config indent true
sudo quicksilverd config keyring-backend test
sudo quicksilverd config trust-node true
sudo quicksilverd keys add validator --keyring-backend test