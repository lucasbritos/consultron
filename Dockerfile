FROM node:10
# Create app directory
WORKDIR /usr/src/app/

COPY ./ ./

WORKDIR /usr/src/app/client

RUN npm install

RUN npm run build-only

RUN cp -r dist ../server/dist

WORKDIR /usr/src/app/server

RUN rm -rf ../client

RUN npm install

EXPOSE ${SERVER_APP_PORT}

CMD [ "npm", "start" ]
