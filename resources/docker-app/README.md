# Docker Container for Building PDF Converter Files

Includes Python3 and ConText


### Add yourself to the docker group
```bash
sudo usermod -a -G docker YOUR_USER
sudo reboot
```

### Build the Docker container
```bash
# cd ~/Projects/uW-docker
# docker build -t pdf-converter - < Dockerfile
# docker-compose build --force-rm
make baseContainer
make mainContainer
make pushPdfConverterBaseImage
make pushMainImage
```

### Show running containers
```bash
docker container ls
```

### Show all containers, running or not
```bash
docker container ls -a
```

### Run the Docker container, opening shell
```bash
docker run --name pdf-converter --rm -p 8080:80 -i -t pdf-converter bash
exit
```

### Run the Docker container in background and execute commands
```bash
docker pull unfoldingWord/pdf-converterf:latest
docker run --name pdf-converter --rm -p 8080:80 -dit --cpus=0.5 unfoldingWord/pdf-converter:latest
docker run --name pdf-converter -p 8080:80 -dit --cpus=0.5 --restart unless-stopped unfoldingWord/pdf-converter:latest

# simple commands
docker exec pdf-converter pwd

# chained or piped commands
docker exec pdf-converter sh -c "echo 'hello' > hello.txt"

# copy a file
docker cp pdf-converter:/opt/hello.txt ~/Desktop/hello.txt

# stop the container
docker stop pdf-converter
```

### Remove a container and its image
```bash
docker rm -v 840cbddced04
docker rmi pdf-converter
```

### Remove all containers and images
```bash
# Delete all containers
docker rm $(docker ps -a -q)

# Delete all images
docker rmi $(docker images -q)
```
