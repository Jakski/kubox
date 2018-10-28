# Kubox

Kubernetes development pod.

## Usage

```
$ helm install --name my-release https://someurl/kubox
```

## Configuration

| Parameter              | Description                             | Default           |
| ---------              | -----------                             | -------           |
| `kubox.authorizedKeys` | Authorized keys for OpenSSH(*REQUIRED*) | Not set           |
| `kubox.password`       | Password for developer user             | Random            |
| `kubox.keyDir`         | Directory for OpenSSH server keys       | `/srv/ssh`        |
| `kubox.homeDir`        | Developer home directory                | `/home/developer` |
| `kubox.security`       | Security context for container          | `{}`              |
| `kubox.homeSize`       | Size limit for developer home directory | `5Gi`             |
| `image.repository`     | Image name                              | `kubox`           |
| `image.tag`            | Image tag                               | `base`            |
| `nameOverride`         | Override resource name prefix           | `""`              |
| `fullnameOverride`     | Override full resource names            | `""`              |
| `service.type`         | k8s service type                        | `ClusterIP`       |
| `service.port`         | k8s service port                        | `22`              |
| `args`                 | Arguments for container                 | `[]`              |
| `env`                  | Environment variables for container     | `[]`              |
| `resources`            | Resource constraints for container      | `{}`              |
| `nodeSelector`         | Node selector for pod                   | `{}`              |
| `tolerations`          | Tolerations for pod                     | `[]`              |
| `affinity`             | Scheduling constraints for pod          | `{}`              |

## Using root account

You must set `kubox.password` variable and use it with `sudo`:

```
$ sudo su -
```

## Simulating network outages inside pod

You can use `iptables` inside pod to temporarily cut connectivity between
certain IP addresses. In order to use `iptables` you will have to add
`NET_ADMIN` capability to your pod:

```
$ helm install --name my-release https://someurl/kubox \
       --set security.capabilities.add[0]=NET_ADMIN
```

To block outgoing connections to port TCP 443 address 1.1.1.1, you would need to
set rule inside container:

```
$ apk update
$ apk add iptables
$ iptables -A OUTPUT -p tcp -d 1.1.1.1 --dport 443 -j REJECT
```

You can inspect filtering rules with:

```
$ iptables -nvL
```

> **Note**: Adding new capabilities to containers might be disabled by cluster
> security policies. You can read more about it here:
> https://kubernetes.io/docs/concepts/policy/pod-security-policy/#capabilities
