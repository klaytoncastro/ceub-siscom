# Fundamentos Práticos de Redes: Packet Sniffing e Análise de Tráfego

A captura e análise de pacotes (packet sniffing) é uma das competências essenciais em redes, segurança, engenharia de software e infraestrutura. Por meio de ferramentas como Wireshark, tcpdump e o DevTools do navegador, é possível observar a pilha TCP/IP em funcionamento, diagnosticar falhas, validar implementações e compreender o comportamento real dos protocolos — nos fazendo ir além da teoria das camadas OSI e alcançar a prática de mercado. 

## 1. Visão Geral

A prática de captura e análise de pacotes não é apenas um exercício didático: trata-se de um procedimento consolidado na engenharia de redes, adotado de forma sistemática em ambientes profissionais de diferentes portes. O fundamento é invariável: compreender o comportamento efetivo da pilha TCP/IP a partir da observação do tráfego real, e não apenas de modelos conceituais.

Em contextos corporativos — desde pequenas infraestruturas até arquiteturas distribuídas de grande escala — a inspeção em nível de pacote é utilizada para diagnóstico, verificação de conformidade, auditoria de segurança e depuração de aplicações. Ferramentas como Wireshark, tcpdump e tshark são padrões de mercado por permitirem:

- correlacionar eventos de aplicação com fenômenos de rede (delays, retransmissões, políticas de NAT, comportamento de proxies);
- examinar negociações de protocolo (ARP, DHCP, DNS, TCP handshake, ICMP);
- identificar anomalias estruturais (checksums incorretos, janelas TCP incompatíveis, PMTU inadequado, colisões de endereço, ARP poisoning);
- reconstruir fluxos e validar a aderência aos padrões previstos (RFCs).

Para isso, o laboratório dispõe de dois contêineres operando como uma abstração fiel dos cenários reais observados em microserviços, ambientes virtualizados e plataformas de computação em nuvem.: 

- client (Alpine + ferramentas de rede)
- web (NGINX na porta 80)

Mesmo essa topologia elementar contém todos os elementos fundamentais que surgem em sistemas maiores: resolução ARP, estabelecimento de conexões TCP, transporte de requisições HTTP e encerramento de sessão. 

## 2. Ferramenta de Desenvolvedor do Browser

As **Developer Tools** acessadas por meio da tecla `F12` nos navegadores modernos (Chrome, Firefox, Edge) constituem um conjunto de instrumentos voltados à análise de aplicações web. O painel `Network` é o foco neste contexto: ele registra cada requisição HTTP/HTTPS enviada pelo navegador, permitindo observar:

- método HTTP, URL, status e tamanho do payload;
- tempo de conexão, handshake TLS, latência e transferência;
- headers de requisição e resposta;
- ordem cronológica das chamadas (waterfall);
- caching, redirecionamentos e erros.

Trata-se de uma inspeção em nível de aplicação (camada 7). O usuário não observa pacotes, mas sim requisições já reconstituídas. É essencial para depuração de APIs e front-ends, porém não permite investigar ARP, ICMP, janelas TCP, retransmissões ou erros de camada 2/3/4.

## 3. Packet Sniffing e ferramentas de captura e análise de tráfego

Packet sniffing é o processo de capturar, registrar e inspecionar pacotes de dados que trafegam por uma interface de rede, antes que eles sejam interpretados pelas camadas superiores do sistema operacional ou das aplicações. Um sniffer opera observando o fluxo bruto de quadros, datagramas e segmentos — permitindo analisar protocolos, identificar falhas, diagnosticar problemas de comunicação, auditar segurança e compreender o comportamento real da pilha TCP/IP. 

- Atua em nível de enlace e rede (camadas 2 e 3) e pode também registrar dados de transporte e aplicação (camadas 4 a 7).
- Permite observar endereços MAC, endereços IP, portas TCP/UDP, flags, checksums, payloads e eventos como retransmissões, resets e handshakes.
- É realizado por ferramentas como `tcpdump`, Wireshark, `tshark`, entre outras.
- Gera arquivos no formato `.pcap`, padrão universal para análise posterior.

Em suma, o processo de packet sniffing transforma o tráfego de rede em evidência observável, permitindo ver exatamente o que está acontecendo em tempo real entre cliente, servidor e infraestrutura intermediária. Para isso, o `tcpdump` é uma ferramenta de linha de comando (CLI) amplamente adotada em sistemas Unix-like para captura direta de pacotes da interface de rede. Opera em nível de enlace e transporte, antes da interpretação pelos protocolos de aplicação. O `tcpdump` não possui interface gráfica: o foco é registro sistemático e automação.

É imprescindível em ambientes de monitoramento de dispositivos de rede e pipelines de observabilidade. e apresenta as seguintes características:

- leve, adequada a servidores de produção;
- permite filtros BPF (por exemplo, tcp port 80, icmp, arp);
- gera arquivos `.pcap`, padrão de mercado para análise posterior, em ferramentas como o Wireshark (`tshark`) e serviços on-line especializados como o [apackets.com](apackets.com);

Por exemplo, com uma captura TCP Dump, podemos observar como ocorre o handshake de três passos que vimos na implementação do modelo TCP/IP, antes de qualquer troca de dados usando HTTP, visto que o TCP (camada 4) é a base do HTTP (camada 7): 

- **SYN** – o cliente solicita a abertura da conexão.
- **SYN/ACK** – o servidor confirma recebimento e sinaliza abertura.
- **ACK** – o cliente confirma e a sessão é estabelecida.

Em ferramentas como Wireshark, podemos usar filtros como `tcp.flags.syn==1` e `tcp.flags.ack==1` para visualizar o processo de comunicação que garante confiabilidade e sincronização de números de sequência, equivalente à camada de transporte (Camada 4 do modelo OSI).

>Capture o tráfego conforme as instruções do Professor e observer na prática o processo de handshaking, com os 3 pacotes iniciais: **SYN → SYN/ACK → ACK**  estabelecendo a sessão confiável.

## 4. Requisição e Resposta HTTP

Em uma comunicação via HTTP, após o processo de TCP handshake, o cliente envia: 

```bash
GET / HTTP/1.1
Host: web
```

O servidor responde:

```bash
HTTP/1.1 200 OK
Content-Type: text/html
```

Cada requisição/response forma um `tcp.stream` íntegro. Podemos usar o filtro `http` no Wireshark. 


## 5. Controle de Fluxo e Encerramento

- **PSH/ACK** — empurra dados ao aplicativo;
- **ACK** — confirma recebimento confiável;
- **FIN/ACK** — encerramento ordenado;
- **RST** — reset inesperado, comum em falhas e timeouts.

Este processo é observável via filtros:

`tcp.flags.fin==1`
`tcp.flags.rst==1`
`tcp.analysis.retransmission`

## 6. Protocolos Elementares

Além do fluxo TCP/HTTP, sempre existirá atuação dos protocolos elementares. Esses pacotes não entregam dados da aplicação, mas são essenciais para o funcionamento da rede: 

- **ARP** — mapeamento IP → MAC. Filtro: `arp`.
- **ICMP Router Solicitation / Advertisement** — descoberta de roteadores. Filtro: `icmp`.

Como vimos em teoria, as camadas inferiores da pilha realizam validações contínuas:

- Ethernet → CRC.
- IP → checksum do cabeçalho.
- TCP → checksum dos dados.
- No Wireshark: podemos observar o campo **Checksum** nos cabeçalhos (headers).
- Filtros úteis: `tcp.checksum_bad == 1` e `ip.checksum_bad == 1`

## 7. Filtros de Uso Recorrente no Wireshark

| Finalidade                     | Filtro                                   |
|-------------------------------|-------------------------------------------|
| Apenas pacotes TCP            | `tcp`                                     |
| Apenas tráfego HTTP           | `http`                                    |
| Resoluções ARP                | `arp`                                     |
| Seguir uma conexão específica | `tcp.stream eq 0`                         |
| Ver apenas SYN (início)       | `tcp.flags.syn == 1 && tcp.flags.ack == 0`|
| Retransmissões                | `tcp.analysis.retransmission`             |

## 8. Laboratório

Neste laboratório utilizaremos um conjunto de ferramentas complementares para inspecionar e analisar o tráfego de rede. O Wireshark, instalado no ambiente doméstico do estudante, oferece a interface de análise mais completa, com decodificação avançada de protocolos e inspeção detalhada dos pacotes capturados. No contexto do laboratório do CEUB, empregaremos a alternativa online apackets.com, que permite abrir arquivos .pcap diretamente no navegador, sem necessidade de instalação local, preservando a mesma lógica de interpretação utilizada no Wireshark.

Complementarmente, recorreremos ao painel Network das DevTools (F12) dos navegadores modernos, útil para inspecionar requisições HTTP e medir tempos de resposta na camada de aplicação. Para capturas realizadas diretamente dentro dos contêineres, utilizaremos o tcpdump, ferramenta de linha de comando amplamente adotada em ambientes Unix-like, responsável por produzir os arquivos .pcap analisados posteriormente.

Em seu computador pessoal, você pode utilizar o [Wireshark](https://drive.google.com/drive/folders/1d7FwTLtnRSnjJ5k-YRZlORNlY3c1ygQZ?usp=sharing). 

### Roteiro

O objetivo é gerar tráfego real entre dois hosts, capturar o fluxo e analisá-lo detalhadamente. Para isso, vamos subir um servidor web (HTTP) com o software nginx e um sistema Linux (Alpine) para simular a comunicação utilizando a pilha de protocolos TCP/IP e gerar tráfego web cliente e servidor. Para isso, execute os comandos indicados abaixo:

```bash
# Passo 1 — Subir o ambiente com os contêineres: 
cd /opt/ceub-siscom/sniffing
docker-compose up -d
```

Com isso, o ambiente em contêiner cria:

- client → ferramenta de rede para gerar tráfego
- web → servidor HTTP simples (nginx)

```bash
# Passo 2 - Abra um segundo terminal e deixe-o em segundo plano. Realize o comando e não interrompa a captura: 
docker exec -it client tcpdump -i eth0 -w /pcaps/http_client_web.pcap
```

```bash
# Passo 3 — No primeiro terminal, vamos testar a conectividade entre o cliente e o servidor: 
docker exec -it client ping -c 2 web
```

```bash
# Passo 4 — Gerar tráfego com requisição HTTP
docker exec -it client curl -I http://web
```

Agora gere tráfego de erro, apontando para uma URL não existente: 

```bash
# Passo 5 - Adicione um end-point não existente no servidor
docker exec -it client curl http://web/users
```

Você também pode utilizar uma instrução `for` para repetir os comandos e gerar tráfego. Por exemplo: 

```bash
# Para tráfego de sucesso - Código HTTP 200 OK
for ((i=1; i<=20; i++)); do
  docker exec -it client curl http://web
done
```

```bash
# Para tráfego de erro - Código HTTP 404 Not Found
for ((i=1; i<=20; i++)); do
  docker exec -it client curl http://web/users
done
```

Ao fim do processo você observará:

- ICMP Echo Request
- Echo Reply
- Tempo de ida e volta
- Resolução ARP prévia
- Códigos 200 e 404 na comunicação HTTP

Cada uma dessas etapas pode ser vista no arquivo gerado `pcap`: 

- Baixe o arquivo `/pcaps/http_client_web.pcap` a partir do seu VS Code e tragar para a máquina local; 
- Abra o arquivo no Wireshark ou use o serviço on-line [apackets.com](apackets.com) caso esteja sem a ferramenta instalada localmente.

### Entrega

No Sala On Line (moodle), envie o arquivo .pcap da sua captura e quatro prints: 

1. **ARP** – captura do pacote de resolução de endereço.
2. **Handshake TCP** – sequência SYN → SYN/ACK → ACK no mesmo fluxo.
3. **GET / 200 OK** – requisição HTTP bem-sucedida.
4. **GET / 404 Not Found** – requisição a um recurso inexistente.

<!--wireshark ./pcaps/http_client_web.pcap
docker network inspect $(docker-compose ps -q web | xargs docker inspect --format '{{range .NetworkSettings.Networks}}{{.NetworkID}}{{end}}') \
  | grep -o '"Name": "br-[^"]*' | head -1
# pegue o nome br-XXXX

sudo tcpdump -i br-XXXX -w ./pcaps/bridge.pcap

Filtro Wireshark: tcp.stream eq 0 para seguir a primeira conexão; http para ver HTTP; tcp.flags.syn==1 && tcp.flags.ack==0 para SYN.

Retransmissões desligando o web e refazendo curl para ver RST/timeouts.
-->

## 9. Conclusão

A análise desse tráfego viabiliza a visualização concreta da pilha de protocolos TCP/IP, permitindo ao estudante transitar da representação teórica para a interpretação prática dos mecanismos internos, exatamente como ocorre no mercado de trabalho.
