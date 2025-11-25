# Simulação de Redes com GNS3

## Introdução

O **GNS3 (Graphical Network Simulator 3)** é uma solução robusta para simulação de redes, cujo objetivo inicial era oferecer uma interface gráfica amigável para a configuração de redes simuladas. O foco estava inicialmente na emulação de roteadores Cisco, utilizando o **IOS (Internetwork Operating System)**. Contudo, evoluiu rapidamente para suportar uma ampla gama de dispositivos e fabricantes, sendo mantido por uma comunidade ativa de desenvolvedores e entusiastas de redes ao redor do mundo, que contribuem com atualizações regulares, tutoriais, fóruns de discussão e projetos colaborativos.

O GNS3 permite a simulação de dispositivos de rede, tair como: **roteadores, switches, firewalls e PCs**, possibilitando a configuração e o teste de um ambiente de rede de forma realista, oferecendo a oportunidade praticar os conceitos relacionados às redes de computadores, sem a necessidade de atuar diretamente no hardware especializado. Além disso, utilizando ambientes baseados em contêineres, podemos simular uma ampla gama de serviços e protocolos essenciais de rede, como **Mail eXchanger (MX: SMTP, POP3, IMAP)** , **DNS (Domain Name System)**, **DHCP (Dynamic Host Configuration Protocol)**, dentre outros, viabilizando a criação de ambientes complexos e funcionais.

## Objetivo

Este repositório fornece as bases para a configuração e uso do **GNS3** em simulações de rede. Utilizaremos o GNS3 para criar redes simuladas, **configurar protocolos de roteamento** e **testar topologias de rede**, e compreender o funcionamento e as interações entre dispositivos. Além disso, exploraremos a configuração de **serviços essenciais de rede**, aprofundando o entendimento sobre como os sistemas de comunicação modernos se mantêm e se configuram automaticamente. Ao final do curso, você será capaz de:

- Simular e configurar **roteadores**, **switches** e **serviços de rede** como **SMTP**, **IMAP**, **DNS** e **DHCP** de forma virtual.
- Compreender e aplicar protocolos de roteamento como **OSPF**, **RIP**, **EIGRP** e **BGP**.
- Criar e testar **topologias de rede** em um ambiente virtual seguro.
- Configurar e testar **servidores DHCP** para fornecer automaticamente configurações de rede aos dispositivos.
- Implementar e testar **servidores DNS** para resolução de nomes e gerenciamento de domínios.
- Explorar a interação entre **camadas de rede**, serviços e dispositivos em redes complexas.
- Solucionar problemas de conectividade e desempenho de redes.

## Aplicações do GNS3

O GNS3 pode ser utilizado para uma ampla gama de simulações e experimentos de redes, incluindo:

- **Configuração de dispositivos de rede**: Simular roteadores, switches, firewalls e até mesmo computadores para testar cenários reais de rede.
- **Protocolos de Roteamento**: Testar e configurar diversos protocolos de roteamento (OSPF, RIP, EIGRP, BGP).
- **Segurança de Rede**: Simular cenários de segurança, como firewalls e controle de acesso.
- **Monitoramento e Solução de Problemas**: Monitorar o tráfego de rede e identificar gargalos ou problemas de configuração.
- **Serviços de Rede**: Simular e testar a implementação de **DNS**, **DHCP**, **FTP**, **HTTP** e outros serviços de rede.
- **Automatização e Infraestrutura**: Explorar como redes modernas automatizam a configuração de dispositivos com **DHCP**, e como serviços como **DNS** são essenciais para a comunicação em redes complexas.

## Requisitos

- Docker instalado (para rodar o servidor GNS3 e outras aplicações, como SMTP, IMAP, DNS, DHCP, Web Server, DBMS, etc).
- Familiaridade com **conceitos de redes de computadores**, como **roteamento**, **switching**, **serviços de rede** e **protocolos de rede**.

## Laboratório

Suba o simulador GNS3: 

```bash
cd /opt/ceub-siscom/gns3
docker-compose up -d
```

Acesse a aplicação no seu navegador em: `http:\\localhost:3080` e logue com: 

```bash
Usuário: admin
Senha: admin
```

**Obs**: Se estiver usando a VM, certifique-se de liberar o NAT para a porta `3080`.

Crie um projeto e configure uma topologia básica para testar os VPCs, atribuindo IPs estáticos e um Switch Ethernet para conectividade entre eles. 

```bash
#Configuração do PC1: 
ip 192.168.1.2 mask 255.255.255.0

#Configuração do PC2:
ip 192.168.1.3 mask 255.255.255.0
```

A partir do PC1, pingue o PC2 e vice-versa: 

```bash
#A partir do PC1
ping 192.168.1.3

#A partir do PC2
ping 192.168.1.2
```

Tire print da topologia e dos pings realizados e envie no Sala On Line. 
