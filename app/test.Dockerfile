# pull official base image
FROM python:3.8.3-alpine

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install psycopg2 dependencies
RUN apk update \
    && apk add postgresql-dev gcc python3-dev musl-dev

# install dependencies
RUN pip install --upgrade pip
COPY ./requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


# create directory for the app user
RUN mkdir -p /home/app

# create the app user
RUN addgroup -S app && adduser -S app -G app

# create the appropriate directories
ENV HOME=/home/app
ENV APP_HOME=/home/app/web
WORKDIR $APP_HOME

# Create a folder for compiling static files
RUN mkdir -p /var/www/static
RUN chown app:app /var/www/static

# install dependencies
#RUN apk update && apk add libpq
#RUN pip install --no-cache /wheels/*

# copy entrypoint.sh
COPY ./test_entrypoint.sh .

# copy project
COPY . $APP_HOME

# chown all the files to the app user
RUN chown -R app:app $APP_HOME

# change to the app user
USER app

# run entrypoint.sh
ENTRYPOINT ["/home/app/web/test_entrypoint.sh"]
