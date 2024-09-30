# Dockerfile
FROM ubuntu/bind9:latest

# Criar os diretórios necessários e ajustar as permissões
RUN mkdir -p /var/cache/bind /var/lib/bind && \
    chown -R bind:bind /var/cache/bind /var/lib/bind && \
    chmod -R 775 /var/cache/bind /var/lib/bind /etc/bind

# Expor a porta DNS
EXPOSE 53/tcp
EXPOSE 53/udp

# Comando para iniciar o serviço Bind
CMD ["/usr/sbin/named", "-u", "bind", "-g", "-f"]
