# Sniffing: Captura e Análise de Pacotes com Wireshark

---

## 1. Introdução

As aplicações modernas dependem, de forma quase absoluta, de serviços distribuídos que operam sobre redes de comunicação: sistemas web, APIs, aplicações em nuvem e a interação constante entre usuários e provedores via Internet. A base tecnológica que sustenta esse ecossistema é o conjunto de protocolos TCP/IP, consolidado como padrão global desde as redes corporativas, institucionais e acadêmicas até chegar às residências e dispositivos pessoais.

Essa predominância se estende a diferentes domínios de rede, desde datacenters e redes corporativas locais até MANs (redes metropolitanas) e WANs (redes nacionais e globais) modernas, inclusive em tendências de mercado por meio de Software Defined Networks (SDN), nas quais o controle da rede é abstraído em camadas de software, promovendo maior flexibilidade, automação e integração com datacenters modernos. Em todos esses cenários, o TCP/IP permanece como a arquitetura fundamental, sobre a qual a maioria dos sistemas atuais opera.

Nesse contexto, ferramentas como o Wireshark atuam como um “microscópio de rede”, permitindo analisar em detalhe os pacotes que materializam a comunicação digital. O processo de captura (sniffing) e análise de tráfego oferece suporte não apenas para diagnóstico e auditoria, mas também para ensino e pesquisa em redes e segurança.

---

## 2. Visão Geral do Wireshark

O Wireshark é um analisador de pacotes de rede gratuito e de código aberto, amplamente utilizado em ambientes acadêmicos e profissionais. Ele permite capturar, inspecionar e interpretar o tráfego de rede em tempo real, oferecendo uma visão detalhada sobre os protocolos que compõem a comunicação digital. Por sua granularidade, tornou-se uma ferramenta indispensável para administradores de redes, engenheiros de segurança, desenvolvedores e pesquisadores.

### Para que serve o Wireshark?

O Wireshark pode ser aplicado em diversos cenários:

- Análise de Tráfego de Rede: captura pacotes em tempo real, exibindo cabeçalhos e dados, o que permite compreender fluxos de comunicação em diferentes camadas do modelo OSI/TCP-IP.
- Diagnóstico de Problemas: auxilia na identificação de latência, retransmissões, perdas de pacotes e falhas de configuração.
- Segurança de Rede: possibilita detectar tráfego anômalo, tentativas de intrusão, ataques e comportamentos suspeitos que podem indicar comprometimento.
- Desenvolvimento e Teste de Protocolos: facilita a depuração e validação de implementações de protocolos de rede em sistemas distribuídos.
- Educação e Pesquisa: fornece exemplos práticos de funcionamento de protocolos, tornando visível o que normalmente é abstrato em sala de aula.

### O que é possível fazer com o Wireshark?
Com o Wireshark é possível capturar e analisar pacotes em nível de detalhe. Entre as informações mais relevantes, destacam-se:

- Endereços IP de origem e destino.
- Portas de origem e destino utilizadas na comunicação.
- Protocolos envolvidos em cada camada da pilha TCP/IP.
- Tamanho dos pacotes e sequência temporal da transmissão.
- Checksums, flags e campos de controle de cada protocolo.

Esses dados permitem correlacionar teoria e prática, desde a confiabilidade oferecida pelo TCP até o funcionamento de protocolos de aplicação como HTTP.

**Nota**: a captura de pacotes requer privilégios administrativos e deve ser usada de forma ética e legal. Em ambientes corporativos, é comum que esse tipo de análise só seja permitido mediante autorização expressa.

### Análise do Processo de TCP Handshaking
- 3 pacotes iniciais: **SYN → SYN/ACK → ACK**.
- Estabelece sessão confiável.
- Relacionar com **Camada 4 (Transporte)** do OSI.

---

### Análise de Requisição e Resposta HTTP Request/Reply
- Cliente: **GET / HTTP/1.1**.
- Servidor: **HTTP/1.1 200 OK** + HTML.
- Exemplo de **Camada 7 (Aplicação)**.

![Exemplo de captura no Wireshark](/img/wireshark.png)

A figura acima mostra uma captura real (`example.pcap`) em que se observam:

- O handshake TCP (SYN → SYN/ACK → ACK) nas linhas 1–3.
- A requisição HTTP GET feita pelo cliente (linha 4).
- A resposta HTTP 200 OK enviada pelo servidor (linha 8).
- O encerramento da conexão com os pacotes FIN/ACK (linhas 9–11).

Essa visualização evidencia como os conceitos de transporte (camada 4) e aplicação (camada 7) podem ser correlacionados diretamente a eventos observáveis na rede.

---

## 4. Controle de Fluxo e Encerramento
- **PSH, ACK** → envio de dados.
- **FIN, ACK** → encerramento ordenado.
- ACK confirma cada segmento (confiabilidade).

---

## 5. Protocolos Auxiliares
- **ARP**: resolução de endereços.
- **ICMPv6 Router Solicitation**: descoberta de roteador.
- Tráfego de suporte essencial.

---

## 6. Detecção e Correção de Erros
- Ethernet → CRC.
- IP → checksum do cabeçalho.
- TCP → checksum dos dados.
- No Wireshark: campo **Checksum** nos cabeçalhos.

---

## 7. Aplicação de Filtros no Wireshark
- `tcp` → apenas pacotes TCP.  
- `http` → apenas tráfego HTTP.  
- `arp` → ARP.  
- `tcp.stream eq 0` → seguir conversa completa.

---
# 8. Ferramentas

[Baixe Aqui o Wireshark](https://drive.google.com/drive/folders/1d7FwTLtnRSnjJ5k-YRZlORNlY3c1ygQZ?usp=sharing)

# 9. Laboratório

```bash
cd /opt/ceub-siscom/sniffing
docker compose up -d --build

docker exec -it client ping -c 2 web
docker exec -it client curl -I http://web

# Terminal A
docker exec -it client tcpdump -i eth0 -w /pcaps/http_client_web.pcap

# Terminal B
docker exec -it client curl http://web
```

<!--wireshark ./pcaps/http_client_web.pcap
docker network inspect $(docker compose ps -q web | xargs docker inspect --format '{{range .NetworkSettings.Networks}}{{.NetworkID}}{{end}}') \
  | grep -o '"Name": "br-[^"]*' | head -1
# pegue o nome br-XXXX

sudo tcpdump -i br-XXXX -w ./pcaps/bridge.pcap

Filtro Wireshark: tcp.stream eq 0 para seguir a primeira conexão; http para ver HTTP; tcp.flags.syn==1 && tcp.flags.ack==0 para SYN.

Retransmissões desligando o web e refazendo curl para ver RST/timeouts.
-->

## 10. Conclusão

- O Wireshark permite observar de forma empírica os conceitos discutidos nos modelos de referência OSI e TCP/IP.
- A análise de pacotes evidencia mecanismos de confiabilidade (handshake, ACKs, retransmissões), de detecção e correção de erros (checksums, CRC) e de controle de fluxo (janela deslizante, FIN/ACK).
- Os filtros aplicados na ferramenta possibilitam isolar protocolos e compreender sua atuação em cada camada.

O processo de captura e inspeção de tráfego constitui um recurso fundamental tanto para o diagnóstico e auditoria de redes, quanto para a compreensão dos fundamentos da comunicação de dados moderna.

Ao mesmo tempo, é justamente nesse nível de análise — onde pacotes revelam confiabilidade, erros, fluxos e protocolos — que se constrói a base para áreas mais avançadas. Entre elas, a cibersegurança se destaca: detecção de ataques, identificação de tráfego anômalo e monitoramento de ameaças dependem da mesma habilidade de interpretar o que circula na rede.

Dessa forma, aprender a usar ferramentas como o Wireshark não significa apenas exercitar conceitos de redes, mas também abrir caminho para práticas consistentes em segurança da informação, lembrando que não há cibersegurança sólida sem conhecimento profundo de redes.

Assim, a análise de pacotes não é apenas um exercício acadêmico, mas uma competência essencial e prática para profissionais de redes e de segurança da informação na era digital.