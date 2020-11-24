#instalando a imagem
FROM php:7.3.6-fpm-alpine3.9
#instalando o bash e o mysql client
RUN apk add bash mysql-client
#instalando extens�o do docker php para mysql
RUN docker-php-ext-install pdo pdo_mysql
#A instala��o do pacote shadow para habilitar o comando usermod
RUN apk add --no-cache shadow

#assumir que estamos rodando o c�digo dentro do www
WORKDIR /var/www
# apagar a pasta html do servidor
RUN rm -rf /var/www/html

#instalando o composer no docker
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# RUN composer install && \
#         cp .env.example .env && \
#         php artisan key:gererate && \
#         php artisan config:cache

# copiar todos os dados de onde est� o dockerfile para a pasta destino (q tb poderia ser . pois j� estamos no www pelo WORKDIR)
#COPY . /var/www retirado para trabalhar com volume compartilhado
# Atribuir a arquivos e pastas que a propriedade � do usu�rio www-data, como foi feito um COPY antes com o root, os arquivos                  s�o dele e o www-data n�o teria permiss�o para escrever e modificar arquivos.
RUN chown -R www-data:www-data /var/www

#criar um link simb�lico da pasta public para a pasta html
#A pasta public � onde tem o index.php do laravel
RUN ln -s public html

#Atribui��o do grupo 1000 ao usu�rio www-data
RUN usermod -u 1000 www-data
#Atribui��o do usu�rio www-data como usu�rio padr�o em vez do root
USER www-data

#expose porta
EXPOSE 9000
#executando o php para rodar back
ENTRYPOINT [ "php-fpm" ]
