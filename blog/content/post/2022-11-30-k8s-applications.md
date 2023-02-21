---
title: "K8s Applications"
date: 2022-11-30T12:06:02+01:00
draft: false
author: Constanze
---

# Deploying a K8s application
Here is a quick overview of how k8s applications make it from prototype to stable in our blueprints:

## When you dont know the application yet:
+ (from scratch) you might deploy manifests completely by hand
+ try out a helm chart manually in an existing caas , test if its what you want
## If you are relatively sure, we want this application on a new cluster:
+ harden the helm chart, this might require a fork into caas/helm-charts
+ write a values.standalone.yml add a ADO library,  make sure default ingress has the oauth2 annotation, security contexts, resource-requests etc
+ add it to update-k8s-apps.yml to deploy it occasionally
## Once you have a few regular users that want your application:
+ review secrets and dependencies
+ add it to deploy-iac-tuw.yml and make it part of a profile
## Once it becomes an essential application of a k8s-profile
+ write it into jinja, and put it into the ansible-k8s repo as manifest-template. Write corresponding ansible_vars profile in caas/paas/k8s/vars/config_<profile>.yml 
+ test the security, psps, service accounts, annotations, performance etc
## At some medium stage, also the secrets and OAUTH OIDC endpoints will be increasingly managed by lowerlevel terraform and sourced from keyvaults

&rarr dont forget, that you need to maintain the thing going forward, approx 1 per month, it needs upgrading and a general review by the maintainer if all things still work as designed. (edited) 

