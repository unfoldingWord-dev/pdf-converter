# Created: 2019-05-27 RJH

# NOTE: The following environment variables are expected to be set for testing:
#	AWS_ACCESS_KEY_ID
#	AWS_SECRET_ACCESS_KEY
checkEnvVariables:
	@ if [ -z "${AWS_ACCESS_KEY_ID}" ]; then \
		echo "Need to set AWS_ACCESS_KEY_ID"; \
		exit 1; \
	fi
	@ if [ -z "${AWS_SECRET_ACCESS_KEY}" ]; then \
		echo "Need to set AWS_SECRET_ACCESS_KEY"; \
		exit 1; \
	fi
	@ if [ -z "${REDIS_URL}" ]; then \
		echo "Need to set REDIS_URL"; \
		exit 1; \
	fi

# Add/Remove --no-cache as required

baseStretchImage:
	docker build --no-cache --tag unfoldingword/stretch-base:latest resources/docker-slim-python3.8-base/

pushStretchBaseImage:
	docker push unfoldingword/stretch-base:latest

runStretchBase:
	docker run --name stretch-base --detach --interactive --tty --cpus=1.0 --restart unless-stopped unfoldingword/stretch-base:latest

basePDFConverterImage:
	docker build --no-cache --tag unfoldingword/pdf-converter-base:latest resources/docker-base/

runPDFConverterBase:
	docker run --name pdf-base --detach --interactive --tty --cpus=1.0 --restart unless-stopped unfoldingword/pdf-converter-base:latest

pushPDFConverterBaseImage:
	docker push unfoldingword/pdf-converter-base:latest

mainImageDebug:
	# Builds from local files
	docker build --file resources/docker-app/Dockerfile-debug --tag unfoldingword/pdf-converter:debug .

mainImageDev:
	# Builds from GitHub develop branch (so any changes must have been pushed)
	docker build --file resources/docker-app/Dockerfile-developBranch --tag unfoldingword/pdf-converter:develop resources/docker-app/

mainImage:
	# Builds from GitHub master branch (so any changes must have been merged)
	docker build --file resources/docker-app/Dockerfile-masterBranch --tag unfoldingword/pdf-converter:master resources/docker-app/

pushMainDevImage:
	docker push unfoldingword/pdf-converter:develop

pushMainImage:
	docker push unfoldingword/pdf-converter:master

run: checkEnvVariables
	docker run --env AWS_ACCESS_KEY_ID --env AWS_SECRET_ACCESS_KEY --env REDIS_URL --name pdf-converter --publish 8123:80 --detach --interactive --tty --cpus=1.0 --restart unless-stopped unfoldingword/pdf-converter:master

runDev: checkEnvVariables
	docker run --env AWS_ACCESS_KEY_ID --env AWS_SECRET_ACCESS_KEY --env REDIS_URL --env QUEUE_PREFIX="dev-" --name pdf-converter --rm --publish 8123:80 --detach --interactive --tty --cpus=1.0 --restart unless-stopped unfoldingword/pdf-converter:develop
	# Then browse to http://localhost:8123/test
	#	or http://localhost:8123/?lang_code=en
	#	then http://localhost:8123/output/en/obs-en-v5.pdf

runDevDebug: checkEnvVariables
	# After this, inside the container, run these commands to start the application:
	#	cd /
	#	./start_RqApp.sh
	# or
	#	./test_en.sh
	#
	# logs will be in /app/pdf-converter/output/ (log.err and log.out)
	docker run --env AWS_ACCESS_KEY_ID --env AWS_SECRET_ACCESS_KEY --env REDIS_URL --env QUEUE_PREFIX="dev-" --env DEBUG_MODE=On --name pdf-converter --rm --publish 8123:80 --interactive --tty --cpus=0.5 unfoldingword/pdf-converter:develop bash

runDebug: checkEnvVariables
	# After this, inside the container, run these commands to start the application:
	#	cd /
	#	./start_RqApp.sh
	# or
	#	./test_en.sh
	#
	# logs will be in /app/pdf-converter/output/ (log.err and log.out)
	# Also look in /tmp/pdf-converter/en-xxxx/make_pdf/en.log and en.tex
	docker run --env AWS_ACCESS_KEY_ID --env AWS_SECRET_ACCESS_KEY --env REDIS_URL --env QUEUE_PREFIX="dev-" --env DEBUG_MODE=On --name pdf-converter --rm --publish 8123:80 --interactive --tty unfoldingword/pdf-conveter:debug bash

connectDebug:
	# This will open another terminal view of the pdf-converter container (one of the two above)
	#	that doesn't have all of the nginx logs scrolling past
	#
	# tail -f /tmp/last_output_msgs.txt
	#	is convenient to watch (once that file exists)
	# logs will be in /app/pdf-converter/output/ (log.out and maybe log.err)
	# Also look in /tmp/pdf-converter/en-xxxx/make_pdf/en.log and en.tex
	docker exec -it `docker inspect --format="{{.Id}}" pdf-converter` bash
