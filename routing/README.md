# Atividade Prática: Conexão de Unidades Administrativas no DF

Imagine que estamos conectando três unidades regionais do **Governo do Distrito Federal (GDF)** espalhadas em diferentes regiões. O objetivo é garantir a comunicação entre as unidades de **Taguatinga**, **Asa Norte**, e **Asa Sul**, permitindo que os dados fluam de forma eficiente e segura.

## Unidades e Sub-redes Simuladas

Cada unidade é representada por uma sub-rede diferente.
O roteador central fará o roteamento entre essas sub-redes, conectando as diferentes regiões.

- **Unidade Taguatinga**: Abrange os serviços administrativos e de atendimento ao público na região de Taguatinga.
- Sub-rede `192.168.10.0/24`
- IPs na faixa de `192.168.10.1` a `192.168.10.254`.

**Unidade Asa Norte**: Abrange os serviços de planejamento e coordenação de projetos no DF.

- Sub-rede `192.168.20.0/24`
- IPs na faixa de `192.168.20.1` a `192.168.20.254`.

**Unidade Asa Sul**: Foca nos serviços de suporte técnico e infraestrutura de TI.

- Sub-rede `192.168.30.0/24`
- IPs na faixa de `192.168.30.1` a `192.168.30.254`.

## GNS3: Adição do Roteador 

- Para adicionar o roteador à sua biblioteca de dispositivos no GNS3, crie um novo projeto e clique em `New Template`. Em `Install appliance from server`, procure por **Mikrotik CHR** e clique em `Install`.

- Verifique qual versão está disponível no simulador (ex.: `7.11.2` ou `7.14.3`). Dependendo da versão disponível, você precisará fornecer a imagem virtual correta do equipamento, que pode ser baixada neste [link](https://drive.google.com/drive/folders/1d7FwTLtnRSnjJ5k-YRZlORNlY3c1ygQZ?usp=sharing). Escolha o arquivo correspondente à versão desejada: `chr-7.11.2.img.zip` ou `chr-7.14.3.img.zip`.

- Após baixar, descompacte o arquivo na pasta desejada usando a Interface Gráfica do seu Sistema Operacional (Windows, macOS, Linux) ou via Linha de Comando:
  
  ```bash
  unzip chr-7.11.2.img.zip
  ```
- Pronto, agora você tem na biblioteca do simulador um roteador capaz de executar várias funções avançadas na rede. 

## Configuração da Topologia 

No caso de um único roteador com três interfaces conectadas às sub-redes, você pode simplesmente configurar rotas estáticas para direcionar o tráfego entre as sub-redes. 

- Configuração Básica (Sem Roteamento Dinâmico): Com interfaces já configuradas para cada sub-rede, o roteador automaticamente conhece as rotas para as sub-redes diretamente conectadas, então não há necessidade de configurar rotas adicionais.

### Criação do Projeto

Abra o GNS3 e crie um novo projeto com o nome, por exemplo, "GDF". Adicione os dispositivos necessários: 

- 3 Switches Ethernet: Um para cada local (Taguatinga, Asa Norte, Asa Sul).
- 1 Router (MikroTik CHR): Para ser o roteador central e gerenciar o tráfego entre as sub-redes.
- 6 VPCS (Virtual PC Simulator): Utilize 2 VPCS para cada local, simulando computadores ou dispositivos conectados.

### Conexão dos Switches ao Router 

Estabeleça os links para conectar todos os dispositivos.

- Conecte cada switch Ethernet ao Router:
- Conecte o switch de Taguatinga à Interface Ether1 do Router.
- Conecte o switch de Asa Norte à Interface Ether2 do Router.
- Conecte o switch de Asa Sul à Interface Ether3 do Router.

### Configuração das Interfaces no Router

Acesse o terminal do Router: 

- Configure os IPs para cada interface conectada às sub-redes:

<!--

### Configure o R1

```bash
/ip address add address=192.168.0.1/24 interface=ether7  # Rede de PCs
/ip address add address=172.16.0.1/30 interface=ether1   # Interconexão com R2
/routing ospf instance add name=default router-id=1.1.1.1
/routing ospf area add name=backbone area-id=0.0.0.0 instance=default
/routing ospf interface-template add interfaces=ether1 area=backbone
```

### Ativação da instância OSPF 

```bash
#No R1 e R2, execute:
/routing ospf instance disable [find name=default]
/routing ospf instance enable [find name=default]
```

### Configure o R1 como DHCP Server

```bash
# Adicionar um pool de endereços IP para o DHCP
/ip pool add name=dhcp_pool_R1 ranges=192.168.0.100-192.168.0.200

# Configurar o servidor DHCP na interface ether7
/ip dhcp-server add interface=ether7 address-pool=dhcp_pool_R1 lease-time=1h name=dhcp_server_R1

# Adicionar o gateway e as opções do DHCP
/ip dhcp-server network add address=192.168.0.0/24 gateway=192.168.0.1
```

### Configure o OSPF no R2

```bash
/ip address add address=10.0.0.1/24 interface=ether7    # Rede de PCs
/ip address add address=172.16.0.2/30 interface=ether1  # Interconexão com R1
/routing ospf instance add name=default router-id=2.2.2.2
/routing ospf area add name=backbone area-id=0.0.0.0 instance=default
/routing ospf interface-template add interfaces=ether1 area=backbone
```

### Ativação da instância OSPF 

```bash
#No R1 e R2, execute:
/routing ospf instance disable [find name=default]
/routing ospf instance enable [find name=default]
```

### Configure o R2 como DHCP Server

```bash
# Adicionar um pool de endereços IP para o DHCP
/ip pool add name=dhcp_pool_R2 ranges=10.0.0.100-10.0.0.200

# Configurar o servidor DHCP na interface ether7
/ip dhcp-server add interface=ether7 address-pool=dhcp_pool_R2 lease-time=1h name=dhcp_server_R2

# Adicionar o gateway e as opções do DHCP
/ip dhcp-server network add address=10.0.0.0/24 gateway=10.0.0.1
```

#/interface ethernet
#set [ find default-name=ether1 ] name=ether1-taguatinga
#set [ find default-name=ether2 ] name=ether2-asa_norte
#set [ find default-name=ether3 ] name=ether3-asa_sul
#/ip address
#add address=192.168.10.1/24 interface=ether1 
#add address=192.168.20.1/24 interface=ether2 
#add address=192.168.30.1/24 interface=ether3 

-->


```bash
# Rede de Taguatinga
/ip address add address=192.168.10.1/24 interface=ether1 comment="GW Taguatinga" 

# Rede da Asa Norte
/ip address add address=192.168.20.1/24 interface=ether2 comment="GW Asa Norte"  

# Rede da Asa Sul
/ip address add address=192.168.30.1/24 interface=ether3 comment="GW Asa Sul"    
```

Agora conecte os VPCS ao switch correspondente de cada local:

```bash
#Taguatinga (sub-rede 192.168.10.0/24):
ip 192.168.10.10 255.255.255.0 192.168.10.1

#Asa Norte (sub-rede 192.168.20.0/24):
ip 192.168.20.10 255.255.255.0 192.168.20.1

#Asa Sul (sub-rede 192.168.30.0/24):
ip 192.168.30.10 255.255.255.0 192.168.30.1
```

### Testes 

- Realize o `ping` a partir de um dispositivo, para seu par na rede e para outros 2 em cada subrede. 

- Verifique a tabela `arp` no roteador. 

`/ip arp print`

### Resumo

Pronto. Configuramos um cenário usando um MikroTik CHR que atua como o roteador central para três sub-redes, conectando Taguatinga, Asa Norte, e Asa Sul. O roteador gerencia as interfaces de rede, possibilitando a comunicação entre dispositivos nas três regiões simuladas. A tabela ARP pode ser visualizada para verificar os dispositivos conectados.As sub-redes podem ser posteriormente configuradas com DHCP e a conectividade testada diretamente pelo roteador.
