FROM public.ecr.aws/docker/library/node:16-slim

RUN mkdir -p /opt/app
COPY package.json package-lock.json /opt/app/
COPY src/index.js /opt/app/src/

WORKDIR /opt/app
RUN npm install --silent --production

ENTRYPOINT ["node", "src/index.js"]