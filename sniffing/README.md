# Sniffing: Captura e Análise de Pacotes com Wireshark

---

## 1. Introdução
- Vimos a teoria e os Modelos de Referência OSI e TCP/IP, além dos mecanismos para detecção e correção de erros. 
- Nesse cenário, podemos entender a ferramenta **Wireshark**: “microscópio da rede”. Por meio do processo de captura de pacotes (sniffing), podemos realizar o diagnóstico, segurança, auditoria e aprendizado.

---

## 2. TCP Handshake 
- 3 pacotes iniciais: **SYN → SYN/ACK → ACK**.
- Estabelece sessão confiável.
- Relacionar com **Camada 4 (Transporte)** do OSI.

---

## 3. Requisição e Resposta HTTP
- Cliente: **GET / HTTP/1.1**.
- Servidor: **HTTP/1.1 200 OK** + HTML.
- Exemplo de **Camada 7 (Aplicação)**.

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