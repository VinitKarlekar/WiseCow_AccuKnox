# Testing KubeArmor Policies with Wisecow

**Prerequisites:**
1. You have a Kubernetes cluster running (e.g., Kind, Minikube, EKS, etc.).
2. You have deployed Wisecow (`kubectl apply -f kubernetes/deployment.yaml`).
3. You have installed KubeArmor in your cluster. If not, you can install it using `karmor install`.

**Step 1. Apply the KubeArmor Policy**
The policy we've created prevents the Wisecow container from executing common shell tools (`bash`, `sh`, `curl`, `wget`) and blocks access to sensitive files (`/etc/passwd`).

```bash
kubectl apply -f kubernetes/kubearmor-policy.yaml
```

**Step 2. Monitor KubeArmor Alerts (Terminal 1)**
In a separate terminal, run `karmor logs` to start listening for policy violations.
```bash
karmor logs
```

**Step 3. Trigger a Violation (Terminal 2)**
Attempt to execute a blocked command inside the `wisecow` pod.

1. Get the pod name:
```bash
kubectl get pods -l app=wisecow
```
2. Try to run `bash` or `sh` inside the container:
```bash
kubectl exec -it <wisecow-pod-name> -- /bin/bash
# Replaced with your pod's actual name
```
You should receive an error like `command terminated with exit code 126` or a permission denied error.

3. Also, try reading `/etc/passwd`:
```bash
kubectl exec -it <wisecow-pod-name> -- cat /etc/passwd
```

**Step 4. Capture Screenshot**
Take a screenshot of Terminal 1 (`karmor logs` output), where you should see the `Action: Block` and `PolicyName: block-shell-exec` logged. Save this screenshot and upload it to your repository.
