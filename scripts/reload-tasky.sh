#/bin/bash
cd ~/git/wiztest
git pull
cd ~/wiz
kubectl apply -f deployment-tasky.yml
kubectl rollout restart deployment -n tasky tasky-app 
