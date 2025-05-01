# panimg-docker
[![CI](https://github.com/siemdejong/panimg-docker/actions/workflows/ci.yml/badge.svg)](https://github.com/siemdejong/panimg-docker/actions/workflows/ci.yml)

Provides an unofficial Docker image with [`panimg`](https://github.com/DIAGNijmegen/rse-panimg).
Images are generated monthly.

## Example usage

### From the terminal

```sh
docker run \
    -v /path/to/files/:/path/to/files/ \
    -v /where/files/will/go/:/where/files/will/go/ \
    ghcr.io/siemdejong/panimg-docker \
    convert /path/to/files/ /where/files/will/go/
```

or interactively

```sh
docker run -it --entrypoint /bin/bash ghcr.io/siemdejong/panimg-docker
```

### SLURM with Pyxis: sbatch
```sh
#!/bin/bash
#SBATCH --job=panimg
#SBATCH --ntasks=1
#SBATCH --container-image="ghcr.io#siemdejong/panimg-docker"
#SBATCH --container-mounts=/path/to/files/:/path/to/files/,/where/files/will/go/:/where/files/will/go/
panimg convert /path/to/files/:/path/to/files/ /where/files/will/go/:/where/files/will/go/
```

### SLURM with Pyxis: srun
```
srun \
    --container-image ghcr.io#siemdejong/panimg-docker \
    --no-container-entrypoint \
    --container-mounts=/path/to/files/:/path/to/files/:/path/to/files/:/path/to/files/,/where/files/will/go/:/where/files/will/go/ \
    panimg convert /path/to/files/ /where/files/will/go/
```

## Build image
The image can be build with
```sh
git clone https://github.com/siemdejong/panimg-docker
docker build . \
    --build-arg python_version=... \
    --build-arg panimg_version=...
```
