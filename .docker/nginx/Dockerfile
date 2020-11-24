#baixar imagem nginx alpine
FROM nginx:1.15.0-alpine

#apagar o arquivo padrão de configuração do nginx
RUN rm /etc/nginx/conf.d/default.conf
#copia o arquivo que criamos para a pasta de configuração do nginx
COPY ./nginx.conf /etc/nginx/conf.d

