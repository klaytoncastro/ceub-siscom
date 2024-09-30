#!/bin/bash

# Definir diretórios e arquivos no host
BIND_DIR="./bind"
ZONES_DIR="$BIND_DIR/zones"
CACHE_DIR="./bind/cache"
LIB_DIR="./bind/lib"
NAMED_CONF="$BIND_DIR/named.conf"
DB_EXEMPLO="$ZONES_DIR/db.exemplo.com"
DB_REVERSE="$ZONES_DIR/db.192.168.0"

# Criar diretórios no host
echo "Criando diretórios necessários no host..."
mkdir -p "$BIND_DIR"
mkdir -p "$ZONES_DIR"
mkdir -p "$CACHE_DIR"
mkdir -p "$LIB_DIR"

# Ajustar permissões para que o usuário "bind" no container tenha acesso
echo "Ajustando permissões dos diretórios para o usuário 'bind'..."
sudo chown -R 100:100 "$BIND_DIR"
sudo chown -R 100:100 "$CACHE_DIR"
sudo chown -R 100:100 "$LIB_DIR"
sudo chmod -R 775 "$BIND_DIR" "$CACHE_DIR" "$LIB_DIR"

# Criar e configurar o named.conf
if [ ! -f "$NAMED_CONF" ]; then
    echo "Criando o arquivo named.conf..."
    cat <<EOL > $NAMED_CONF
options {
    directory "/var/cache/bind";
    allow-query { any; };
    recursion no;
    dnssec-validation auto;
    listen-on port 8053 { any; };
};

zone "exemplo.com" {
    type master;
    file "/etc/bind/zones/db.exemplo.com";
};

zone "0.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.192.168.0";
};
EOL
else
    echo "Arquivo $NAMED_CONF já existe."
fi

# Criar e configurar o arquivo de zona direta
if [ ! -f "$DB_EXEMPLO" ]; then
    echo "Criando o arquivo de zona db.exemplo.com..."
    cat <<EOL > $DB_EXEMPLO
\$TTL 86400
@   IN  SOA ns1.exemplo.com. admin.exemplo.com. (
        2024093001  ; Serial
        3600        ; Refresh
        1800        ; Retry
        1209600     ; Expire
        86400 )     ; Minimum TTL

@   IN  NS  ns1.exemplo.com.
@   IN  A   192.168.0.2
www IN  A   192.168.0.3
ns1 IN  A   192.168.0.2
EOL
else
    echo "Arquivo $DB_EXEMPLO já existe."
fi

# Criar e configurar o arquivo de zona reversa
if [ ! -f "$DB_REVERSE" ]; then
    echo "Criando o arquivo de zona reversa db.192.168.0..."
    cat <<EOL > $DB_REVERSE
\$TTL 86400
@   IN  SOA ns1.exemplo.com. admin.exemplo.com. (
        2024093001  ; Serial
        3600        ; Refresh
        1800        ; Retry
        1209600     ; Expire
        86400 )     ; Minimum TTL

@   IN  NS  ns1.exemplo.com.
2   IN  PTR ns1.exemplo.com.
EOL
else
    echo "Arquivo $DB_REVERSE já existe."
fi

echo "Diretórios e arquivos de configuração criados e permissões ajustadas."
echo "Agora você pode executar o 'docker-compose build' e 'docker-compose up -d'."
