FROM node:12

WORKDIR /app

COPY package*.json ./

RUN npm install

copy . .

CMD ["node","start"]