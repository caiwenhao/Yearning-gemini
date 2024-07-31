# 定义构建阶段
# 使用nvm或者直接使用Node.js的官方Docker镜像
FROM node:16.20.2 as build-stage

# 设置工作目录
WORKDIR /app

# 复制package.json和yarn.lock文件
COPY . .
# 安装依赖
RUN yarn install

# 构建项目
RUN yarn build

# 定义生产阶段
FROM harbor.powerbuyin.top/devops/nginx:v0.0.3 as production-stage

# 从构建阶段复制构建好的文件到nginx目录
COPY --from=build-stage /app/dist /usr/share/nginx/html

# 暴露端口
EXPOSE 8080

# 启动nginx，关闭守护进程模式
CMD ["nginx", "-g", "daemon off;"]