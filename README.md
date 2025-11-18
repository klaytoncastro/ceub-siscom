# Instalação e Configuração do Ambiente de Laboratório

## 1. Introdução

Esta disciplina apresenta os fundamentos e a evolução dos Sistemas de Comunicação, e como eles viabilizam a troca de dados através de diversos meios de transmissão, utilizando sinais analógicos e/ou digitais, além dos respectivos métodos de modulação, codificação, amostragem, e técnicas empregadas para detecção/correção de erros.

Também serão discutidos os principais conceitos que definem as redes de comunicação modernas, tais como o modelo OSI, recursos, dispositivos e topologias físicas necessários para estabelecer o funcionamento das camadas, bem como a arquitetura TCP/IP e definição dos protocolos essenciais, tais como: ARP, DHCP, DNS, SMTP, POP3, IMAP e HTTP, além de fundamentos para estabelecer a segurança cibernética das redes.

A parte prática inclui laboratórios com simuladores de mercado, que oferecem experiência de modelagem e administração por meio da emulação de equipamentos reais em suas topologias típicas, capacitando os estudantes a trabalhar com os conceitos, terminologias e implementação da pilha de hardware e software necessária para prover os recursos mais utilizados em redes modernas, estabelecendo uma infraestrutura de comunicação confiável e segura.

Para realizar a preparação do ambiente no laboratório do **CEUB**, vá para a **[Seção 3](#3-configuração-alternativa-de-infraestrutura)**.
Para realizar a preparação do ambiente para prática **em casa**, prossiga apenas para a **[Seção 2](#2-preparando-se-para-as-práticas-em-laboratório)**.

### Cronograma de Atividades Práticas

Este cronograma define as entregas práticas correspondentes às pastas do repositório, com uma atividade por laboratório.  
A sequência foi organizada para evoluir de fundamentos de infraestrutura até serviços de aplicação.


| # | Desafio | Prazo |
|:--|:--|:--:|
| [01](./) | Preparar ambiente virtual, importar OVA, configurar NAT e acesso SSH. | 11/11/2025 |
| [02](./sniffing/) | Capturar e analisar tráfego com Wireshark/tcpdump. | 11/11/2025 |
| [03](./gns3/) | Construir topologia e validar conectividade entre nós. | 11/11/2025 |
| [04](./dhcp/) | Configurar servidor DHCP e validar concessão de IP automática. | 11/11/2025 |


<!--


| [03 – Routing](./routing/)                     | Implementar roteamento estático e dinâmico; validar com `traceroute`.   | 29/08/2025  |
| [04 – VLAN](./vlan/)                           | Segmentar rede com VLANs e comprovar isolamento entre sub-redes.        | 05/09/2025  |
| [06 – DNS](./dns/)                             | Implementar servidor DNS e testar resolução com `dig` e `nslookup`.     | 19/09/2025  |
| [07 – Mail](./mail/)                           | Implantar serviço de correio (SMTP/POP3/IMAP) e testar envio/recepção.  | 26/09/2025  |
| [08 – WWW](./www/)                             | Publicar servidor web Apache/Nginx e validar acesso via navegador.      | 03/10/2025  |
| [10 – IMG](./img/)                             | Consolidar evidências gráficas, diagramas e registros de rede.          | 17/10/2025  |
| [11 – CA](./ca/)                               | Criar autoridade certificadora e aplicar certificados SSL/TLS.          | 24/10/2025  |
| [12 – Entrega Final](./)                       | Revisão e entrega consolidada de todos os laboratórios.                 | 31/10/2025  |


-->

### Orientações Gerais

- Cada pasta contém **1 laboratório prático** com instruções no `README.md`.
- As entregas devem incluir **prints de tela, arquivos de configuração e breve relatório técnico**.
- O repositório deve permanecer organizado e versionado com commits identificáveis (`lab1_vm`, `lab2_gns3`, etc.).
- O atraso em uma atividade não impede a continuação das próximas, mas afeta a nota de regularidade.

---

## 2. Preparando-se para as Práticas em Laboratório

O Docker é uma plataforma de virtualização leve que permite empacotar aplicações e todas as suas dependências (bibliotecas, configurações e código) em ambientes isolados, chamados containers. Esses containers são altamente portáveis e podem ser executados em qualquer sistema operacional compatível. Essa solução é amplamente adotada no mercado para criar ambientes replicáveis e consistentes, eliminando a necessidade de configurar e instalar manualmente cada aplicação em diferentes máquinas.

Nos sistemas Microsoft Windows, recomenda-se a utilização do WSL (Windows Subsystem for Linux) para a instalação do Docker. O WSL é um recurso nativo do Windows que permite a execução de distribuições Linux sem a necessidade de emulação ou virtualização completa, como o Microsoft Hyper-V ou Oracle VirtualBox. Projetado para facilitar o desenvolvimento de software no Windows, o WSL oferece uma integração simplificada entre os dois sistemas operacionais, tornando o uso do Docker mais eficiente e acessível.

O uso do Docker, em conjunto com o WSL, é essencial para nossos laboratórios, pois garante a replicabilidade do ambiente de desenvolvimento, independentemente do sistema operacional usado por cada estudante.

**Nota**: Usuários de sistemas baseados em Linux ou MacOS não precisam utilizar o WSL, pois esses sistemas já possuem suporte nativo ao Docker. Para executar containers, basta instalar o Docker diretamente, sem a necessidade de qualquer subsistema ou ferramenta adicional.

### Passo 1: Verificação dos Requisitos

Certifique-se de que você está utilizando o sistema operacional Windows 10 ou uma versão superior, e que o recurso de virtualização de hardware está habilitado. 

### Passo 2: Ativação do WSL
Abra o aplicativo **PowerShell ISE**, como administrador, e execute os comandos abaixo:

```bash
# Ativa o subsistema Windows para Linux
dism /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Ativa a plataforma de máquina virtual necessária para o WSL 2
dism /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Instala o WSL
wsl --install

# Define a versão 2 do WSL como padrão
wsl --set-default-version 2
```

**Nota:** Caso tenha encontrado algum erro ou qualquer dificuldade, você pode verificar na BIOS/UEFI de seu dispositivo se o recurso de virtualização está ativado (`VT-x` para processadores Intel, como `Core i3`, `i5`, `i7`, etv; e `AMD-V` para processadores `Ryzen 5`, `Ryzen 7`, etc). Se não conseguir avançar, entre em contato com o professor para obter orientação sobre a instalação.

### Passo 3: Escolha de uma Distribuição

- Caso ainda não utilize WSL com uma distribuição Linux embarcada, instale uma distribuição pelo aplicativo **Microsoft Store** ou via **linha de comando (CLI)**. Recomenda-se instalar o **Ubuntu 24.04**.

- Caso prefira realizar a instalação de forma rápida via CLI, execute o comando abaixo diretamente no **PowerShell ISE**, execute o comando abaixo: 

<!--
wsl -l -o
-->

```bash
# Instala o Ubuntu 24.04
wsl --install -d Ubuntu-24.04

# Define o Ubuntu 24.04 como distribuição padrão ao executar o comando wsl. 
wsl --setdefault Ubuntu-24.04
```

- Finalizada a instalação, reinicie o seu computador. 

### Passo 4: Configuração Inicial

- Inicie o aplicativo WSL e configure o usuário e a senha da distribuição. Depois disso você terá acesso a um kernel e a um terminal Linux. Você pode invocar o Powershell ou Terminal Windows e acionar o comando `wsl` para ter acesso ao ambiente. 
- Além do acesso via CLI, você também pode navegar via nas pastas e arquivos do ambiente Linux através do Windows Explorer (ícone do pinguim), diretamente na pasta da sua distribuição.
- Caso prefira uma interface gráfica (GUI), considere o uso do [Visual Studio Code (VS Code)](https://code.visualstudio.com/), que permite estabelecer uma sessão de terminal com seu ambiente WSL. Esta alternativa pode ser mais intuitiva e amigável para edição de arquivos, unificando sua experiência de desenvolvimento e administração. Procure o professor caso tenha dúvidas na utilização dessa ferramenta.

### Passo 5: Instalação do Docker

- O Docker Desktop for Windows fornece uma interface gráfica e integra o Docker ao sistema, facilitando a execução e o gerenciamento de containers diretamente no Windows.
- Baixe e instale o [Docker Desktop for Windows](https://docs.docker.com/desktop/install/windows-install/#:~:text=Docker%20Desktop%20for%20Windows%20%2D%20x86_64). Após a instalação, o Windows pode solicitar que você faça o logout e o login novamente para aplicar as alterações. 

### Passo 6: Utilização do Ambiente

- Ao longo do curso, você será guiado pelo Professor nas atividades práticas que envolverá o conteúdo das subpastas deste repositório.
- Para começar, inicie o Docker Desktop e, depois disso, o aplicativo WSL ou, se preferir, o terminal Linux diretamente a partir do VS Code. 

## 3. Configuração Alternativa de Infraestrutura

No caso dos usuários de Windows, que preferem evitar VMs devido a limitações de recursos, especialmente quando o dispositivo possui menos de 6GB de RAM, a infraestrutura depende Windows Subsystem for Linux (WSL) que apresentamos acima geralmente é a alternativa mais interessante. No entanto, é importante lembrar que o WSL, embora eficiente, não oferece todas as vantagens de um sistema Linux completo e apresenta algumas nuances entre suas versões (WSL e WSL 2). Se você quiser se especializar em infraestrutura mais semelhante à operação de datacenters, sugerimos a instalação de um sistema baseado em Linux em seu equipamento, ainda que em *dual-boot*.

No entanto, visando uma experiência mais uniforme, disponibilizamos como alternativa pronta para uso imediato, uma máquina virtual (VM) pré-configurada. Embora o Docker possa ser executado diretamente em diversos sistemas operacionais, essa padronização por vezes é necessária para viabilizar o processo de suporte, visando oferecer soluções mais ágeis e consistentes diante de eventuais desafios técnicos.  

<!-->No entanto, valorizamos a autonomia de cada estudante, especialmente quando se trata da prática em seus computadores pessoais. Se você já está familiarizado com o Docker e deseja executá-lo nativamente em seu sistema operacional, este repositório está preparado para essa alternativa. Além disso, para os usuários de hardware recente da Apple, como o M2, essa opção é particularmente relevante, devido a possíveis incompatibilidades com versões do VirtualBox originalmente desenvolvidas para ambientes x86_64. 

essa abordagem assegura que todos iniciem o curso com o mesmo ambiente e configurações.
-->

### 3.1. Sobre o Oracle Virtual Box e a imagem OVA

Caso opte pela VM alternativa, utilizaremos o Oracle VirtualBox, um software de virtualização de código aberto que permite executar vários sistemas operacionais em uma única máquina física. Com ele, é possível criar e gerenciar máquinas virtuais, cada uma com seu sistema operacional, aplicativos e arquivos em um ambiente isolado. Ele é compatível com diversos sistemas, como Windows, Linux e MacOS.

Para tal, utilizaremo uma imagem OVA (Open Virtual Appliance), um formato de arquivo para máquinas virtuais, contendo toda a configuração e discos virtuais necessários. Ele simplifica a portabilidade e implantação de ambientes virtualizados, permitindo importações fáceis em plataformas como o VirtualBox. Utilizando um arquivo OVA, é possível distribuir ambientes pré-configurados, assegurando que os usuários tenham um ambiente consistente, independentemente da localização de execução.

A imagem OVA fornecida já vem equipada com ferramentas como `docker`, `docker-compose`, `git` e `ssh`, otimizando a configuração dos ambientes de laboratório.

### Como Usar:
1. Baixe a imagem OVA através deste [link](https://1drv.ms/f/s!As9_hcVH7a82gpovWfhahtGkRSmriA?e=vFJ2u3).
2. Caso não esteja instalado, baixe o VirtualBox através deste [link](https://www.oracle.com/br/virtualization/technologies/vm/downloads/virtualbox-downloads.html).
3. Escolha a versão correspondente ao seu sistema operacional e siga as instruções de instalação.
4. Execute o VirtualBox e clique em **Arquivo** > **Importar Appliance**.
5. Selecione o arquivo OVA baixado e siga as instruções na tela.
6. Após a importação, dimensione os recursos de memória compatíveis com o laboratório ou computador pessoal. A imagem vem pré-configurada com 512MB de RAM, o que é inicialmente suficiente para prosseguir com nossos laboratórios. 
7. Em configurações da VM, pode ser necessário alterar a porta USB para suporte à versão 1.1 ao invés da 2.0.
8. Configure a placa de rede em modo [NAT](https://www.simplified.guide/virtualbox/port-forwarding#:~:text=Right%20click%20on%20the%20virtual%20machine%20and%20click,of%20the%20window.%20Click%20on%20Port%20Forwarding%20button).
9. Inicie a máquina virtual (VM). 

### Credenciais para acesso à VM:

- **Usuário:** labihc
- **Senha:** L@b1hc

### Acesso Seguro via Troca de Chaves (SSH) 

No seu VS Code configure assim o SSH Remote: 

```bash
# Read more about SSH config files: https://linux.die.net/man/5/ssh_config
Host labihc
    HostName localhost
    Port 2222
    User labihc
    IdentityFile C:/Users/<seu_usuario>/.ssh/id_rsa
    IdentitiesOnly yes
```

No terminal do Windows, realize os seguintes passos: 

```powershell
# Windows
# ssh-keygen -t rsa
# scp -P 2222 .\.ssh\id_rsa.pub labihc@localhost:/tmp
# ssh -p 2222 labihc@localhost
```

No terminal do Linux, realize os seguintes passos: 

```bash
# Linux
#mkdir -p ~/.ssh
#cat /tmp/id_rsa.pub >> ~/.ssh/authorized_keys
#chmod 600 ~/.ssh/authorized_keys
#chmod 700 ~/.ssh
```

Volte ap terminal Windows e teste a conexão: 

```powershell
ssh -i C:\Users\<seu_usuario>\.ssh\id_rsa -p 2222 labihc@localhost
```

### 3.2. Compreendendo o modo NAT

NAT (_Network Address Translation_) é a implementação de um recurso para tradução de endereços de rede. No contexto do VirtualBox, ao configurar uma VM para usar NAT, você está permitindo que essa VM se comunique com redes externas, incluindo a Internet, usando o mesmo endereço IP (_Internet Protocol_) do host. Assim, a máquina _host_ (seu _desktop_ de laboratório ou _notebook_ pessoal) age como um _gateway_ e a VM parece estar atrás de uma rede privada.

Além de fornecer acesso à Internet, o recurso de NAT do VirtualBox também permite o redirecionamento de portas. Isso significa que você pode encaminhar o tráfego de uma porta específica no _host_ para uma porta na VM. Isso é bastante útil quando você deseja acessar serviços hospedados na VM, que poderão ser alcançados diretamente do _host_ ou a partir de outras máquinas na mesma rede, a exemplo das aplicações web e interfaces de gerenciamento com as quais iremos trabalhar no laboratório. 

### Como configurar o Redirecionamento de Portas:

1. **Abra o VirtualBox** e selecione a máquina virtual que você deseja configurar.
2. Clique em **Configurações** (ou _Settings_).
3. Na janela de configurações, vá para **Rede**.
4. Sob a aba **Adaptador 1** e certifique-se de que está configurado para **Conectado a: NAT**.
5. Clique em **Avançado** para expandir as opções.
6. Clique em **Redirecionamento de Portas**.
7. Na janela de redirecionamento de portas, você pode adicionar algumas regras para encaminhar portas da sua máquina host para a sua máquina virtual.

### Exemplo de Tabela de Configuração de Portas:

|    Nome da Regra     | Protocolo | Endereço IP do Host | Porta do Host | Endereço IP da VM | Porta da VM |
|----------------------|-----------|---------------------|---------------|-------------------|-------------|
| Acesso SSH           |    TCP    |      127.0.0.1      |      2222     |     10.0.2.15     |      22     |
| Acesso GNS3          |    TCP    |      127.0.0.1      |      3080     |     10.0.2.15     |    3080     |

- **Nota**: Ao configurar o redirecionamento de portas, evite utilizar as portas 0-1023 (exceto 80 e 443, para aplicações web), pois elas são reservadas. A porta 2222 é comumente usada para SSH devido à sua semelhança com a porta padrão 22 e por estar acima da faixa de portas reservadas, reduzindo a possibilidade de conflitos. Sempre certifique-se de que a porta escolhida **não esteja em uso**. Ferramentas nativas do sistema operacional, como `netstat`, podem ajudar na verificação.

### Dicas: Edição de Arquivos

- O `vim` é uma ferramenta baseada em terminal para editar arquivos em sistemas operacionais como Linux e MacOS, que possui inúmeros comandos e atalhos para otimizar sua produtividade. Se não estiver acostumado a administrar sistemas baseados em terminal e perceber que algo deu errado na edição, lembre-se que pode sair do Vim pressionando `Esc` e digitando `:q!` para retornar à CLI (*Command-Line Interface*) sem salvar as mudanças. À medida que se familiariza, você descobrirá o potencial da ferramenta e sentirá mais segurança na sua operação.

- O SSH (_Secure Shell_), que se traduz como "cápsula segura", é um protocolo que viabiliza uma comunicação segura (criptografada) entre um computador cliente e um servidor remoto. Para gerenciar nossa VM instanciada no VirtualBox (ambiente servidor), é altamente recomendado o uso de conexões SSH ao invés da console física.

- Você também pode usar o [Visual Studio Code (VS Code)](https://code.visualstudio.com/) com a extensão [SSH Remote](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh) é uma opção popular e confiável, que permite estabelecer uma sessão [SSH](https://code.visualstudio.com/docs/remote/ssh) diretamente, tornando a edição de arquivos mais intuitiva e unificando sua experiência de administração, seja no ambiente operando com VM ou com WSL. 

## 4. Comandos Básicos

A interface em linha de comando (CLI – Command-Line Interface) permite executar instruções diretamente no sistema, invocando ferramentas com opções e argumentos.
Para quem está em sua primeira experiência com terminal Linux, o glossário abaixo apresenta comandos essenciais e alguns adicionais recomendados. 

| **Comando**  | **Descrição**                                                             | **Exemplo**                                               |
|--------------|---------------------------------------------------------------------------|-----------------------------------------------------------|
| `whoami`     | Exibe o nome do usuário atual                                             | `whoami`                                                  |
| `pwd`        | Mostra o caminho completo do diretório atual                              | `pwd`                                                     |
| `history`    | Lista o histórico de comandos executados                                  | `history`                                                 |
| `cd`         | Navega entre diretórios                                                   | `cd /home` (acessa um caminho) ; `cd ..` (volta um nível) |
| `ls`         | Lista arquivos e diretórios (use `-la` para ver detalhes e ocultos)       | `ls -la`                                                  |
| `mkdir`      | Cria um novo diretório                                                    | `mkdir nova_pasta`                                        |
| `cp`         | Copia arquivos ou diretórios                                              | `cp arquivo.txt /caminho/destino/`                        |
| `mv`         | Move ou renomeia arquivos e diretórios                                    | `mv arquivo.txt /caminho/destino/`                        |
| `rm`         | Remove arquivos ou diretórios (**atenção: exclusão definitiva**)          | `rm arquivo.txt`                                          |
| `cat`        | Exibe o conteúdo de um arquivo                                            | `cat arquivo.txt`                                         |
| `grep`       | Pesquisa padrões em arquivos                                              | `grep "termo" arquivo.txt`                                |
| `vim`        | Editor de texto no terminal                                               | `vim arquivo.txt`                                         |
| `chmod`      | Altera permissões de arquivos (ex.: leitura/escrita/execução)             | `chmod 755 arquivo.txt`                                   |
| `chown`      | Modifica o proprietário e grupo de um arquivo ou diretório                | `chown usuario:grupo arquivo.txt`                         |
| `ps`         | Lista processos em execução                                               | `ps aux`                                                  |
| `ping`       | Testa a conectividade com um host                                         | `ping google.com`                                         |
| `wget`       | Baixa conteúdo da web                                                     | `wget http://exemplo.com/arquivo.zip`                     |
| `curl`       | Faz requisições HTTP/HTTPS (ótimo para testar códigos 1xx, 3xx, 4xx, 5xx) | `curl -i http://httpbin.org/status/301`                   |
| `top`        | Monitora em tempo real CPU, memória e processos                           | `top`                                                     |
| `df -h`      | Mostra uso de espaço em disco em formato legível                          | `df -h`                                                   |
| `du -sh`     | Exibe tamanho total de uma pasta                                          | `du -sh /var/log`                                         |
| `tail -f`    | Acompanha em tempo real o final de um arquivo (ex.: logs)                 | `tail -f /var/log/syslog`                                 |
| `ss -tulpn`  | Lista conexões de rede e portas em uso (substitui `netstat`)              | `ss -tulpn`                                               |
| `ip a`       | Mostra interfaces e endereços de rede                                     | `ip a`                                                    |
| `traceroute` | Rastreia o caminho até um host na rede                                    | `traceroute google.com`                                   |
| `uptime`     | Exibe tempo de funcionamento e carga do sistema                           | `uptime`                                                  |

<!--
| `htop`       | Versão interativa do `top` (se instalada)                                 | `htop`                                                    |
-->

**Orientações de uso**: 

- Cuidado com o comando `rm`: não há **lixeira**. A exclusão é definitiva.
- Use a tecla `Tab` para autocompletar nomes de arquivos/pastas e reduzir erros de digitação.
- Para ajuda rápida, adicione `--help` ao comando. Ex: `ls --help` ou consulte `man <comando>`.

## 5. Conclusão

Pronto! Agora seu ambiente está preparado para nossos laboratórios. A partir daqui, siga as instruções do professor para completar os exercícios práticos. Se surgir qualquer dúvida, consulte os materiais de apoio indicados no Sala On-Line e neste repositório ou entre em contato via whatsapp ou e-mail [klayton.castro@ceub.edu.br](klayton.castro@ceub.edu.br).
