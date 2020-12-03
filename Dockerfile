#instalando a imagem
FROM php:7.3.6-fpm-alpine3.9
#instalando o bash, openssl e o mysql client
RUN apk add --no-cache openssl bash mysql-client
#instalando extensão do docker php para mysql
RUN docker-php-ext-install pdo pdo_mysql
#A instalação do pacote shadow para habilitar o comando usermod
RUN apk add --no-cache shadow


#instalação do dockerrize para que ele consiga gerenciar dependência de serviços
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

#assumir que estamos rodando o código dentro do www
WORKDIR /var/www
# apagar a pasta html do servidor
RUN rm -rf /var/www/html

#instalando o composer no docker
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# RUN composer install && \
#         cp .env.example .env && \
#         php artisan key:gererate && \
#         php artisan config:cache

# copiar todos os dados de onde está o dockerfile para a pasta destino (q tb poderia ser . pois já estamos no www pelo WORKDIR)
#COPY . /var/www retirado para trabalhar com volume compartilhado
# Atribuir a arquivos e pastas que a propriedade é do usuário www-data, como foi feito um COPY antes com o root, os arquivos                  são dele e o www-data não teria permissão para escrever e modificar arquivos.
RUN chown -R www-data:www-data /var/www

#criar um link simbólico da pasta public para a pasta html
#A pasta public é onde tem o index.php do laravel
RUN ln -s public html

#Atribuição do grupo 1000 ao usuário www-data
RUN usermod -u 1000 www-data
#Atribuição do usuário www-data como usuário padrão em vez do root
USER www-data

#expose porta
EXPOSE 9000
#executando o php para rodar back
ENTRYPOINT [ "php-fpm" ]
