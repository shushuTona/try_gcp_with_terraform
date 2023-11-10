# try_gcp_with_terraform

## setup

```bash
docker build ./ -t gcp-tf
```

```bash
docker run -it --name gcp-tf-container -v ${pwd}\src:/try_gcp_with_terraform gcp-tf bash
```

```bash
docker exec -it gcp-tf-container bash
```