# Policy

this outlines how to apply different types of [policies](https://docs.vmware.com/en/VMware-Tanzu-Mission-Control/services/tanzumc-concepts/GUID-847414C9-EF54-44E5-BA62-C4895160CE1D.html) to workspaces and clustergroups using the TMC cli and yaml files.


## Security Policy

this example shows how to create a baseline security policy on a cluster group. It is also set to turn of PSPs and set in audit mode


```bash
#update the file and replace  <clustergroupname> with your cluster group name
tmc clustergroup security-policy create -f ./baseline-security.yaml
```

## IAM Policy

this example shows how to create an IAM policy on a cluster group. it will create 3 role bindings for edit,admin, and view and map them to some groups. 


```bash
#replace  <clustergroupname> with your cluster group name
tmc clustergroup iam update-policy -f ./iam.yaml <clustergroupname>
```

## Quota

this example shows how to create a quota policy on a cluster group. In this example it will implement a policy that restricts service type loadbalancer to 10 per cluster.

```bash
#replace  <clustergroupname> with your cluster group name as well as replace it in the file, this is a duplicate use of clustername and name and a bug has been filed 
tmc clustergroup namespace-quota-policy create limit-lbs -f ./quota.yaml --cluster-group-name <clustergroupname>
```

## Image Registry
this example shows how to create a policy at the workspace level for an image registry. this example sets up a policy to block the latest tag on namespaces that have a label of `block-latest: true`

```bash
#update the file and replace  <workspacename> with your workspace name
tmc workspace image-policy create  -f ./image-registry.yaml
```