# Cluster

This folder creates a kube cluster, installs ArgoCD and configures ArgoCD to install other apps listed here: https://github.com/francisco-com-au/platform-ops.git

# How do I use it?
Run `./main.sh`. It will:
- figure out what branch you are on (main or develop)
- create a local cluster using K3D (k3s in docker which works great for forwarding traffic)
- install ArgoCD
- configure ArgoCD to install apps in develop or main depending on the branch you are on

# Intended use
The intended design is for you to have 2 clusters:
- dev: used to develop the platform itself
- prod: used to host actual applications

You will have 2 clusters (could be cloud hosted, you could use your laptop or multiple latpops)
To spin up these clusters simply clone this repo, checkout the `develop` branch and run `./main.sh`. Repeat again for the branch `main`.
