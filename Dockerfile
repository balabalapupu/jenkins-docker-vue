FROM node:14-alpine as build-stage

WORKDIR /app

COPY package.json .

RUN npm config set registry http://r.npm.sankuai.com/

RUN npm install

COPY . .

RUN npm run build

FROM nginx  as production-stage
# # 这里的dist文件就是打包好的文件，jenkins-docker-vue是我们上面设置的工作目录
# COPY --from=0 /jenkins-docker-vue/dist /usr/share/nginx/dev
# # default.conf就是我们项目下面的nginx配置文件，我们需要copy到nginx的相应目录
# COPY --from=0 /jenkins-docker-vue/default.conf /etc/nginx/conf.d/dev.conf



COPY --from=build-stage /app/dist /usr/share/nginx/dev
COPY --from=build-stage /app/default.conf /etc/nginx/conf.d/dev.conf


# docker build -t jenkins-docker-vue .
# docker build -t docker-nest:pm2-test -f ../Dockerfile-nest05-pm2 .