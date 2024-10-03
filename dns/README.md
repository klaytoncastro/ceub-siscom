# Serviço de Resolução de Nomes (DNS)

## Visão Geral

### O que é DNS?

O **DNS (Domain Name System)** é o sistema responsável por traduzir nomes de domínio amigáveis para endereços IP, que identificam dispositivos e serviços na internet. Simplificando, o DNS age como uma antiga "lista telefônica" para a internet, convertendo nomes de domínio como `www.exemplo.com` em endereços IP como `192.168.0.1`, para que o navegador possa se conectar ao servidor correto.

### O que é o BIND?

O **BIND (Berkeley Internet Name Domain)** é um dos servidores DNS mais utilizados no mundo. Ele permite configurar e gerenciar domínios e subdomínios, realizar resoluções de nomes para endereços IP e pode ser executado em diversos sistemas operacionais. No ambiente que estamos montando, utilizamos o **BIND9**, uma versão robusta e atualizada do BIND.

## Configurando o Ambiente

### Requisitos

- Docker e Docker Compose instalados.
- Ambiente Linux (ou WSL com Docker habilitado).
  
### Estrutura do Projeto

Prepare o ambiente para rodar o projeto: 

```bash
cd /opt/ceub-siscom
git pull https://github.com/klaytoncastro/ceub-siscom
cd dns
chmod +x setup.sh
./setup.sh
docker compose up -d --build
```

### Entendendo a configuração

O arquivo `bind/named.conf` que estamos utilizando no BIND9 é essencial para configurar o comportamento do servidor DNS. Vamos detalhar a configuração usada no seu ambiente e explicar as funcionalidades específicas que foram implementadas:

```bash

options {
    directory "/var/cache/bind";
    allow-query { any; };
    recursion yes;
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
```

**Bloco** `options { ... }`:

- `directory "/var/cache/bind";`: Especifica onde os arquivos de cache do BIND serão armazenados.
- `allow-query { any; };`: Permite que qualquer host faça consultas DNS a este servidor. No caso de ambientes mais restritos, você poderia limitar isso a IPs específicos ou sub-redes.
- `recursion yes;`: O BIND pode ser configurado para responder de forma autoritativa (para zonas sobre as quais tem autoridade) ou de forma recursiva (consultando outros servidores DNS para resolver consultas fora de sua zona). No nosso ambiente, ativamos a recursão. Isso significa que o servidor responderá tanto as consultas para domínios pelos quais ele é autoritativo, quanto as consultas recursivas, ou seja, encaminhando as requisições para outros servidores e armazenando seus resultados em cache. 
- `listen-on port 8053 { any; };`: Define que o BIND escutará na porta 8053 em todas as interfaces de rede disponíveis.
- `zone "exemplo.com" { ... }`: Define a zona de autoridade para o domínio exemplo.com, que é tratada como uma "zona master" (principal).
- `file "/etc/bind/zones/db.exemplo.com";`: Especifica o arquivo de zona onde as informações sobre os domínios e subdomínios estão armazenadas, como mapeamento de nomes de domínio para endereços IP.
- `zone "0.168.192.in-addr.arpa" { ... }`: Define a zona de resolução reversa para o bloco de endereços IP 192.168.0.x. Isso significa que quando você faz uma consulta reversa (PTR) para um IP neste intervalo, o BIND tentará traduzir o IP para um nome de domínio.
- `file "/etc/bind/zones/db.192.168.0";`: Especifica o arquivo de zona para a resolução reversa desses IPs.

**Blocos** `zone " ... " {}`: Zonas são os blocos que contêm as informações de resolução de nomes. O BIND usa essas zonas para responder de maneira autoritativa a consultas DNS. 

- `zone "exemplo.com"`: Esta linha define a zona para o domínio exemplo.com. No nosso caso, este servidor BIND atua como master (servidor principal), o que significa que ele possui a autoridade total sobre esta zona.

- `file "/etc/bind/zones/db.exemplo.com";`: Aponta para o arquivo de zona, que contém os mapeamentos entre nomes de domínio e endereços IP. No arquivo `db.exemplo.com`, é possível configurar subdomínios e novos registros, como veremos a seguir.

**Exemplo de um arquivo de zona com subdomínios(`db.exemplo.com`)**: 

```bash
$TTL    604800
@       IN      SOA     exemplo.com. root.exemplo.com. (
                        2024093001         ; Serial
                        604800             ; Refresh
                        86400              ; Retry
                        2419200            ; Expire
                        604800 )           ; Negative Cache TTL
;
@       IN      NS      ns1.exemplo.com.
ns1     IN      A       192.168.0.1
@       IN      A       192.168.0.2
www     IN      A       192.168.0.3
mail    IN      A       192.168.0.4
```

- `@` representa o domínio raiz (`exemplo.com`), que está associado ao endereço IP `192.168.0.2`.
- `www` e `mail` são subdomínios de `exemplo.com`, apontando respectivamente para `192.168.0.3` e `192.168.0.4`.

### TTL (Time to Live) em Zonas e Registros DNS

TTL (Time to Live) é um valor que indica por quanto tempo uma resposta de DNS pode ser armazenada em cache por servidores e clientes antes de ser considerada obsoleta. Esse valor é definido em segundos e pode ser configurado tanto no arquivo de zona quanto em registros individuais.

- TTL da Zona: Quando definido no início de um arquivo de zona (ex: $TTL 604800), esse valor atua como o padrão para todos os registros da zona, a menos que um TTL diferente seja explicitamente configurado para um registro individual. Um valor típico de TTL para a zona pode variar de 1 hora (3600 segundos) até 7 dias (604800 segundos), dependendo de quanto tempo você deseja que as respostas DNS sejam armazenadas em cache.

- TTL de um Registro: Cada registro DNS pode ter seu próprio TTL, que sobrepõe o valor padrão da zona, permitindo flexibilidade. Por exemplo, registros com mudanças frequentes, como entradas de balanceamento de carga, podem ter TTLs curtos para permitir uma atualização rápida (ex: 60 segundos), enquanto registros estáticos podem ter TTLs longos.

- Valores de TTL mais altos reduzem a carga nos servidores DNS, mas podem atrasar a propagação de alterações. Por outro lado, TTLs mais curtos tornam a propagação mais rápida, mas aumentam a carga de consulta nos servidores.


<!-- 

### Principais Tipos de Registros DNS

Registro A (Address Record):

Mapeia um nome de domínio para um endereço IPv4 (32 bits).
Exemplo:
css
Copiar código
www.exemplo.com. IN A 192.168.0.1
Isso significa que www.exemplo.com resolve para o endereço IP 192.168.0.1.
Registro AAAA (IPv6 Address Record):

Similar ao registro A, mas para endereços IPv6 (128 bits).
Exemplo:
yaml
Copiar código
www.exemplo.com. IN AAAA 2001:0db8:85a3:0000:0000:8a2e:0370:7334
Neste caso, www.exemplo.com resolve para o endereço IP IPv6.
Registro NS (Name Server Record):

Especifica quais servidores DNS têm autoridade para uma zona de domínio. Este tipo de registro informa quais servidores são responsáveis por responder às consultas DNS de um domínio específico.
Exemplo:
Copiar código
exemplo.com. IN NS ns1.exemplo.com.
Isso indica que ns1.exemplo.com é o servidor DNS autoritativo para o domínio exemplo.com.
Registro MX (Mail Exchange Record):

Define os servidores de e-mail responsáveis por receber e-mails para o domínio. Esses registros também incluem uma prioridade para o roteamento de e-mails.
Exemplo:
Copiar código
exemplo.com. IN MX 10 mail.exemplo.com.
Isso significa que mail.exemplo.com é o servidor de e-mail preferencial para o domínio exemplo.com, com prioridade 10. Se houver vários servidores MX, o de menor valor numérico é tentado primeiro.
Registro PTR (Pointer Record):

Usado para resolução reversa, ou seja, traduzir um endereço IP para um nome de domínio. É o inverso do registro A ou AAAA. Registros PTR são comumente usados em verificações de segurança e logs de rede.
Exemplo:
Copiar código
1.0.168.192.in-addr.arpa. IN PTR www.exemplo.com.
Isso significa que o IP 192.168.0.1 resolve para www.exemplo.com.
Registro CNAME (Canonical Name Record):

Aponta um domínio para outro nome de domínio, servindo como um alias. Usado para resolver vários nomes de domínio para o mesmo endereço IP sem precisar duplicar registros A/AAAA.
Exemplo:
objectivec
Copiar código
blog.exemplo.com. IN CNAME www.exemplo.com.
Isso significa que blog.exemplo.com é um alias para www.exemplo.com.

-->

### Testando a configuração

```bash
docker ps
docker compose logs
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' bind9
```

Agora que o ambiente está funcionando, você pode testar a resolução de DNS utilizando o comando `dig`. Lembre-se de alterar o IP do localhost (`127.0.0.1`) pelo IP que obteve no comando acima (`docker inspect`):

Teste da resolução de nomes autoritativa: 
```bash
dig @127.0.0.1 -p 8053 exemplo.com
```

Teste da resolução de nomes recursiva: 
```bash
dig @127.0.0.1 -p 8053 www.globo.com
```

Lembre que uma consulta DNS pode ser respondida de forma **autoritativa**, ou seja, diretamente pelo servidor que tem autoridade delegada sobre a zona (no nosso caso, `exemplo.com`) ou pode ser respondida de forma **recursiva**, quando o servidor DNS aceita consultas e as encaminha, guardando a resolução de nomes em seu cache para as próximas consultas. 

### Tarefa

Use o comando dig para verificar a resolução de www.exemplo.com e 192.168.0.2 (reverso):

```bash
dig @127.0.0.1 -p 8053 www.exemplo.com
dig @127.0.0.1 -p 8053 -x 192.168.0.2
```

Adicione mais entradas na zona exemplo.com, como subdomínios adicionais, e teste sua resolução. 

```bash
vim db.exemplo.com 
```

Atualize o número de série da zona e recarregue a configuração no BIND.

```bash
docker exec -it bind9 rndc reload
```

Monitore os logs do contêiner enquanto realiza consultas DNS para entender como o BIND9 responde às requisições.

```bash
docker logs -f bind9
```

### Conclusão

Este projeto permite que você configure e teste um servidor DNS utilizando o BIND9 dentro de um contêiner Docker. Ao seguir as instruções acima, você aprendeu a gerenciar registros de domínio, adicionar subdomínios e monitorar o comportamento do servidor DNS. Este é o primeiro passo para entender como serviços de DNS funcionam, além de prepará-lo para configurar aplicativos que usarão este ambiente como base. Nossos próximos passos incluirão a configuração de aplicativos que utilizarão este mesmo ambiente DNS. Continue praticando a adição de novos registros e subdomínios para dominar o BIND9 e o sistema de resolução de nomes. 
