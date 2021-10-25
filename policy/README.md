# Policy

This outlines how to apply different types of [policies](https://docs.vmware.com/en/VMware-Tanzu-Mission-Control/services/tanzumc-concepts/GUID-847414C9-EF54-44E5-BA62-C4895160CE1D.html) to _workspaces_ and _clustergroups_ using the `tmc` CLI and YAML files.

> Note: these policy templates make use of [ytt](https://carvel.dev/ytt/) so they are reusable and extensible.

## Preparation

Start by creating a `values.yaml` where we are configuring the data values that are referenced in the policy templates.

```
cat > values.yml <<EOF
#@data/values
---
workspace_name: {workspace-name}
clustergroup_name: {clustergroup_name}
EOF
```
> Replace `{workspace-name}` and `{clustergroup-name}` above with valid _workspace_ and _clustergroup_ names respectively.

## Security Policy

This example shows how to create a baseline security policy on a cluster group. It is also set to turn off PSPs and set audit mode


```bash
ytt -f baseline-security.yml -f values.yml --output-files /tmp
tmc clustergroup security-policy create -f /tmp/baseline-security.yml
```

## IAM Policy

This example shows how to create an IAM policy on a cluster group. It will create 3 role bindings for _edit_, _admin_, and _view_ and map them to some groups.


```bash
tmc clustergroup iam update-policy -f ./iam.yml {clustergroup-name}
```
> Replace `{clustergroup-name}` above with valid _clustergroup_ name.

## Quota

This example shows how to create a quota policy on a cluster group. In this example it will implement a policy that restricts service type _loadbalancer_ to _10_ per cluster.

```bash
ytt -f quota.yml -f values.yml --output-files /tmp
tmc clustergroup namespace-quota-policy create limit-lbs -f /tmp/quota.yml --cluster-group-name {clustergroup-name}
```
> Replace `{clustergroup-name}` above with valid _clustergroup_ name.  There is some unnecessary duplication of effort in that we specify a command line parameter value and config file value for clustergroup name.  This is a known defect and will be fixed in a future release.


## Image Registry

This example shows how to create a policy at the workspace level for an image registry. This example sets up a policy to block the _latest_ tag on namespaces that have a label of `block-latest: true`

```bash
ytt -f image-registry.yml -f values.yml --output-files /tmp
tmc workspace image-policy create  -f /tmp/image-registry.yml
```

## Custom Policy

This example shows how to create a custom policy template as well as a custom policy that implements that template on the clustergroup. In this example we will create a policy template that restricts usage of storage classes to an allowed list.

### Step 1: Create the custom policy template

```bash
tmc policy templates create -f ./custom-policy-template.yml
```

### Step 2: Create a policy on the clustergroup using the new template

```
ytt -f custom-policy.yml -f values.yml --output-files /tmp
tmc clustergroup custom-policy create -f /tmp/custom-policy.yml
```