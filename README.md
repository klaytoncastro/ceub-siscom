# Instalação e Configuração do Ambiente de Laboratório

## 1. Introdução

Esta disciplina apresenta os fundamentos e a evolução dos Sistemas de Comunicação, e como eles viabilizam a troca de dados através de diversos meios de transmissão, utilizando sinais analógicos e/ou digitais, além dos respectivos métodos de modulação, codificação, amostragem, e técnicas empregadas para detecção/correção de erros.

Também serão discutidos os principais conceitos que definem as redes de comunicação modernas, tais como o modelo OSI, recursos, dispositivos e topologias físicas necessários para estabelecer o funcionamento das camadas, bem como a arquitetura TCP/IP e definição dos protocolos essenciais, tais como: ARP, DHCP, DNS, SMTP, POP3, IMAP e HTTP, além de fundamentos para estabelecer a segurança cibernética das redes.

A parte prática inclui laboratórios com simuladores de mercado, que oferecem experiência de modelagem e administração por meio da emulação de equipamentos reais em suas topologias típicas, capacitando os estudantes a trabalhar com os conceitos, terminologias e implementação da pilha de hardware e software necessária para prover os recursos mais utilizados em redes modernas, estabelecendo uma infraestrutura de comunicação confiável e segura.

Para realizar a preparação do ambiente no laboratório do **CEUB**, vá para a **[Seção 3](#3-configuração-alternativa-de-infraestrutura)**.
Para realizar a preparação do ambiente para prática **em casa**, prossiga apenas para a **[Seção 2](#2-preprando-se-para-as-práticas-em-laboratório)**.

## 2. Preprando-se para as Práticas em Laboratório

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

### Sobre o Oracle Virtual Box e a imagem OVA

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

## 4. Comandos Básicos

Para quem está em sua primeira experiência com terminal Linux, segue um glossário com os comandos básicos:

| Comando | Descrição                                               | Exemplo                                                |
|---------|---------------------------------------------------------|--------------------------------------------------------|
| `whoami`| Exibe o nome do usuário atual                           | `whoami`                                               |
| `pwd`   | Mostra o diretório atual                                | `pwd`                                                  |
| `history`| Exibe o histórico de comandos                          | `history`                                              |
| `cd`    | Navega entre diretórios                                 | `cd /home` (acessa um caminho); cd .. (volta um nível) |
| `ls`    | Lista arquivos e diretórios                             | `ls -la`                                               |
| `mkdir` | Cria um novo diretório                                  | `mkdir nova_pasta`                                     |
| `cp`    | Copia arquivos ou diretórios                            | `cp arquivo.txt /caminho/destino/`                     |
| `mv`    | Move ou renomeia arquivos e diretórios                  | `mv arquivo.txt /caminho/destino/`                     |
| `rm`    | Remove arquivos ou diretórios                           | `rm arquivo.txt`                                       |
| `cat`   | Exibe o conteúdo de um arquivo                          | `cat arquivo.txt`                                      |
| `grep`  | Pesquisa por padrões em arquivos                        | `grep "termo" arquivo.txt`                             |
| `vim`   | Editor de texto no terminal                             | `vim arquivo.txt`                                      |
| `chmod` | Altera permissões de arquivos                           | `chmod 755 arquivo.txt`                                |
| `chown` | Modifica o proprietário de um arquivo ou diretório      | `chown usuario:grupo arquivo.txt`                      |
| `ps`    | Lista processos em execução                             | `ps aux`                                               |
| `ping`  | Testa a conectividade com um host                       | `ping google.com`                                      |
| `wget`  | Baixa conteúdo da web                                   | `wget http://exemplo.com/arquivo.zip`                  |

**Orientações de uso**: 

- Cuidado com o comando `rm`: não há **lixeira**. A exclusão é definitiva.
- Use a tecla `Tab` para autocompletar nomes de arquivos/pastas e reduzir erros de digitação.
- Para ajuda rápida, adicione `--help` ao comando. Ex: `ls --help` ou consulte `man <comando>`.

## 5. Conclusão

Pronto! Agora seu ambiente está preparado para nossos laboratórios. A partir daqui, siga as instruções do professor para completar os exercícios práticos. Se surgir qualquer dúvida, consulte os materiais de apoio indicados no Sala On-Line e neste repositório ou entre em contato via whatsapp ou e-mail [klayton.castro@ceub.edu.br](klayton.castro@ceub.edu.br).
