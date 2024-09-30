# Serviço de Resolucao de Nomes (DNS)

## Visão Geral

### O que é DNS?

O **DNS (Domain Name System)** é o sistema responsável por traduzir nomes de domínio amigáveis para endereços IP, que identificam dispositivos e serviços na internet. Simplificando, o DNS age como uma "lista telefônica" para a internet, convertendo nomes de domínio como `www.exemplo.com` em endereços IP como `192.168.0.1`, para que o navegador possa se conectar ao servidor correto.

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
docker compose up -d --build
```

### Testando a configuracao

```bash
docker ps
docker compose logs
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' bind9
```

Agora que o ambiente está funcionando, você pode testar a resolução de DNS utilizando o comando dig. Altere o IP do localhost (`127.0.0.1`) pelo IP que obteve no comando acima (`docker inspect`):

```bash
dig @127.0.0.1 -p 8053 exemplo.com
```

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

### Conclusao

Este setup permite que você configure e teste um servidor DNS utilizando o BIND9 dentro de um contêiner Docker. Ao seguir os passos, você aprenderá a gerenciar registros de domínio, adicionar subdomínios e monitorar o comportamento do servidor DNS. Este é o primeiro passo para entender como serviços de DNS funcionam, além de prepará-lo para configurar aplicativos que usarão este ambiente como base.

Nossos próximos passos incluirão a configuração de aplicativos que utilizarão este ambiente DNS. Continue praticando a adição de novos registros e subdomínios para dominar o BIND9 e o sistema de resolução de nomes.
