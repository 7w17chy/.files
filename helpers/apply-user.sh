#!/bin/bash
nix build .#homeManagerConfigurations.mnn.activationPackage
./result/activate
