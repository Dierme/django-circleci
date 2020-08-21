Django application stub in Docker
=========================

Simple Django _Hello-world_ in Docker using Gunicorn as a prod server and Nginx as a reverse-proxy and
for serving static files.

To run the application run
```
$ docker-compose up --build
```

To run the tests locally in docker run ``./run_tests_in_docker.sh``  
CircleCI is configured. To run the circleci tests locally you need to install circleci CLI and run
```
$ circleci local execute -c app/.circleci/config.yml
```

### Acknowledgements
The base application was build following [this tutorial](https://testdriven.io/blog/dockerizing-django-with-postgres-gunicorn-and-nginx/)