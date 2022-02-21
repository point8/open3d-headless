# Headless Open3D
Pre-compiled [Open3D](https://github.com/isl-org/Open3D) for headless execution.

The python packages can be found in the releases section.

## Docker
The Dockerfile is intended to provide an environment with all the required dependencies for compiling Open3D.

## Compiling open3d headless

1. Install open3d's compilation dependencies as defined [here](http://www.open3d.org/docs/0.12.0/tutorial/visualization/headless_rendering.html)
    Or you can open a shell in this docker container with things already pre-installed:
    > `docker run --rm -it hydrocat/open3d-headless:latest`
2. Generate Makefiles with `cmake`
    In the container you can `cmake $(cat cmake-flags.txt) ..`

    Currently, the flags being used disable a bunch of things, but the main ones are:

    ```
    -DENABLE_HEADLESS_RENDERING=ON -DBUILD_WEBRTC=OFF -DBUILD_GUI=OFF
    ```
3. Build the python package with `make python-package`
    This will take a while.

    * You can specify make's `-j` flag for more parallel tasks
4. Use the library.
    * Under normal compilations options, the python library should be in `build/lib/open3d`
    * If you executed this inside a container, you shold copy this folder out from the container.
    * You should be able to install it with poetry or put the folder somwehere the current python environment can find.

### Compiling for another python version

You can try changing the version inside the Dockerfile and rebuilding everything

or

You can run the compilation docker container and change the pyenv before compilation. For example:

```bash
pyenv install 3.10.1
pyenv global 3.10.11
eval "$(pyenv init --path)"

#To make sure that the correct version is being used, you can run
python --version
#   Python 3.10.11
```

and then cmake and build

```bash
cd /open3d/build
cmake $(cat cmake-flags.txt) ..
make -j5 python-package
```
