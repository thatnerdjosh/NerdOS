# NerdOS

## Important Notes

* **USE AT YOUR OWN RISK** - There is no guarantee of safety with these scripts 
* This is a work in progress based on LFS 11.3
* It is not recommended to use these scripts outside of a VM or container

## Building

### Docker

For simplicity, there is a Dockerfile in this repository which allows you to build NerdOS in an isolated environment. While this should be safer than building on your host OS, it is still suggested to proceed with caution.

Build Image:

```bash
docker build . -t nerdos
```

Run container and build all stages:

```bash
docker run --privileged -ti --rm nerdos bash
make
```