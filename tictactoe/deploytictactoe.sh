#!/bin/bash

# Create deployment of tictactoe
kubectl create deploy tictactoe --image=nginx

# Expose deployment of tictactoe
kubectl expose deployment tictactoe --type=NodePort --port=80 --name tictactoe
