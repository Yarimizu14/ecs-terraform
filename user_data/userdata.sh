#!/bin/bash

echo ECS_CLUSTER=simple-cluster >> /etc/ecs/ecs.config
echo ECS_ENGINE_AUTH_TYPE=docker >> /etc/ecs/ecs.config
echo ECS_ENGINE_AUTH_DATA='{"https://quay.io":{"username":"<user>","password":"<password>","email":"."}}' >> /etc/ecs/ecs.config
