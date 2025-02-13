#/bin/bash
cd ~/git/wiztest
git pull
cd ~/wiz
kubectl apply -f deployment-tasky.yml
kubectl get pods -n tasky -o wide
