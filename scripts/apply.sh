#!/bin/bash
kubectl apply -f infrastructure/namespaces/
kubectl apply -R -f monitoring/
kubectl apply -R -f services/
