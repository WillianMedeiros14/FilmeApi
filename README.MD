docker-compose build
docker-compose up --abort-on-container-exit --exit-code-from migrations migrations
docker-compose up api
