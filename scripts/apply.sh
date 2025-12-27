#!/bin/bash
kubectl apply -f infrastructure/namespaces/
kubectl apply -f monitoring/
kubectl apply -f services/