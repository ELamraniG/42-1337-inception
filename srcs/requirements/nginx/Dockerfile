FROM nginx:alpine

COPY conf/ /etc/nginx/conf.d/
COPY tools/ /docker-entrypoint.d/

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
