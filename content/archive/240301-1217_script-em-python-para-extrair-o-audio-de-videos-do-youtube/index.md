---
title: "Script em Python para extrair o áudio de vídeos do YouTube"
date: "2022-06-22T12:17:29-03:00"

draft: false
comments: true
math: false

author: "Kevin Marques"
tags: ["programming", "learning", "python", "automation"]
---

> Escrevi um script para extrair o áudio de vídeos do YouTube para eu baixar músicas usando o Termux roando um único arquivo.

Recentemente criei um script, usando a ferramenta [`yt-dlp`](https://github.com/yt-dlp/yt-dlp) -- para Linux --, para baixar o áudio de vídeos do YouTube e organizá-los em pastas específicas no meu celular/computador. Apesar do projeto ser simples (é só um arquivo de umas 30 linhas), aprendi algumas coisas interessantes e tive ideias que não acho que seria legal não deixar elas registradas em algum canto.

Vou me atentar em registrar o que eu fiz, como eu fiz e porquê eu fiz. Além disso, tem algumas coisas que preciso estudar mais pra frente e coisas que não tem muito haver com código em si que quero abordar.


## Porquê eu não uso um aplicativo aleatório de conversão

Sites de conversão não me permitem ter a liberdade que eu teria se usasse algum aplicativo para celular que fizesse o mesmo serviço. Normalmente o navegador salva esses arquivos na pasta `/emulated/0/Downloads/`, o que deixa o processo de baixar o áudio dos vídeos bem mais trabalhoso, visto que eu teria que mover manualmente os arquivos para as pastas onde guardo minhas músicas, o trabalho seria muito maior se eu quisesse baixar uma playlist inteira, e maior ainda para organizar.

Conheço poucos, mas com certeza há aplicativos que consigam fazer tudo o que eu preciso, mas ainda acho que não seja uma boa solução para o meu contexto. Não me entenda mal, eu entendo que não há necessidade de reinventar a roda, mas achei que seria uma boa oportunidade de aprender algo novo nessa questão. Outro motivo de eu não usar usar aplicativos para Andorid: Eles não seguem a *Unix philosophy*[^1], o que não é algo ruim (longe disso), mas só quer dizer que les fazem o que eu preciso e mais um pouco, e esse "mais um pouco" acaba ocupando um espaço desnecessário no meu armazenamento.

[^1]: A *Unix philosophy* é uma filosofia para desenvolver software que muitas aplicações para ambientes *Unix-like* (tipo *Linux*, *MacOS*, *BSD*, etc). Ela pode ser resumida em poucas palavras: "Faça só uma coisa, e faça bem feita".


### Vantagens de se saber programar

Outra razão de eu ter feito essa ferramenta: eu sei. Lógicamente, eu não fiz o `yt-dlp`, apenas o usei para baixar as músicas e extrair para MP3 e escrevi o script para salvar onde eu quero. Estive estudando sobre como rodar comandos em Shell por programas em Python e uso Linux -- significa que sei Shell porque sempre estou usando o terminal --, acabei conhecendo o `yt-dlp` e aprendi a extrair o áudio em MP3 com ele. Juntando uma linguagem simples como Python e essa ferramenta que é executada por linha de comando, criei esse facilitador para mim que gosta de escutar música offline.

O interessante foi que essa ideia surgiu quando pensei: "Putz, acho que dava pra automatizar esse processo". Programar é uma skill que me ajuda muito a ser "preguiçoso", no sentido de gastar tempo e esforço para criar alguma coisa que repita um processo várias vezes para mim.


## Como eu criei essa ferramenta

Eu escolhi o Python pela facilidade, realmente foi um programa que comecei a escrever segundos depois que pensei na solução para o meu problema. Não só isso, como os sitemas Android e Arch Linux (distribuição Linux que estou usando) são *Unix-like*, o Python já vem pré-instalado -- e se não vier, um siples comando resolve em 5 segundos. Escolhi Python também por me permitir usar essa função de executar comandos do sistema nativamente, o que me permitiu escrever tudo em um único arquivo, aí eu só precisei me preocupar com a lógica e como eu iria estruturar tudo.

Como você deve imaginar, esse aplicativo não têm interface gráfica, você executa ele por linha de comando.


### Organização desses arquivos e como eu rodo o código

Uma vez com o script criado, precisei passar ele para o meu celular e organizar tudo. Eu estou usando o *Termux* para emular o terminal no Android, é com esse aplicativo que configuro o meu ambiente pessoal de estudos (ou de desenvolvimento numa emergência) e anotações.

A pasta `~/scripts/bin/` está no `$PATH` do meu android, é lá onde guardo arquivos com permissão de execução. Faço isso por que não preciso me preocupar com a extensão do arquivo ou algo assim e fica mais fácil quando escrevo algo realmente útil para o meu celular. Salvei o arquivo como `yt`, ou seja, `~/scripts/bin/yt`, então só preciso o dar o comando `yt` e ele começa a rodar.

No entanto, eu programei para a pasta de origem ser o diretório atual, mas dá para editar isso passando o novo local do *output* nos argumentos do comando -- acredito que faça sentido, já que a URL também vai ser passada como um argumento, e será mais fácil de mudar o comportamento disso se necessário. Eu sempre guardo minhas músicas em `/emulated/0/Musics/`, então configurei meu `~/.bashrc` do seguinte modo:

```bash
alias yt="yt --dir /emulated/0/Musics"
alias ytP="yt --playlist --dir /emulated/0/Musics"
```

O comando para baixar todos os vídeos de uma playlist salva os vídeos em uma pasta separada. Com isso tudo, fica bem mais fácil o trabalho de criar meus álbuns e organizar o que quero ouvir sem depender do 4G que falha toda hora.

E como esse programa foi feita por mim, para resolver um problema meu, não têm necessidade de ele ser incrível, afinal é só um projeto pessoal afinal de contas. Um único arquivinho já basta, não têm porquê colocar ele em algum repositório de pacotes grande -- tipo o do `pip` ou da AUR -- e usar o `yt-dlp` como dependência principal, o script só têm 70 linhas.


## Contras da minha solução...

É muito lento, apesar de não ser um problema pra mim, ainda é meio chato. O `yt-dlp` precisa baixar o vídeo em `WEBM` pra depois converter para MP3. Além disso, a tela do meu celular precisa estar ligada para fazer o download -- o restante ele roda em background, e consegue converter para MP3 com a tela desligada sem problemas --, e também acredito que o tamanho dos arquivos sejam muito grandes. Não entendo muito como essas coisas são formatadas, mas alguns áudios conseguem serm só alguns MB mais leve, o que me incomoda.

Apesar disso tudo, estou satisfeito com o resultado. O tempo entre eu copiar um link de um vídeo/playlist e eu ter as músicas na pasta que eu quero pronto para o VLC (midia player que uso no meu Android) tocar, ficou mais curto, mesmo com a demora no download e na conversão. Sem falar que consegui, ao menos:

+ Clean code com Python
+ Exercitei a minha skill pra solucionar problemas
+ Me divertir por um tempo
+ Me atualizar com Python, que já fazia um tempo que sequer encostava

Vou continuar usando isso e desse jeito até eu achar a solução para esses problemas.


### Ainda preciso resolver depois

+ [ ] Encontrar um formato de compressão de áudio mais leve que MP3
+ [ ] Ler melhor a documentação do `yt-dlp`
+ [ ] Escrever um script para limpar o nome dos arquivos<sup>2</sup>
+ [ ] Treinar com esse projeto usando outras linguagens


## *Python code documentation*

Tentei organizar o código seguindo os *paterns* de *clean code* que os *PyThOnIsTaS* costumam usar, então acredito que esteja *self documentaded* o sulficiente. Essa é a segunda versão do código, a primeira eu tentave renomear o nome dos arquivos salvos e usava OOP, o que não dá muito certo com Python num projeto pequeno, nessa versão eu foquei em deixar o código legível e menos bloat.

E só por que sim, resolvi chamar o arquivo de `better_yt-dlp.py`. Se for usar esse pequeno programa, salve-o com um nome menos complicado, e numa pasta que esteja no *path* do seu sistema operacional. A extensão do arquivo não é necessária.

```python
#!/usr/bin/env python3

from os import mkdir, system
from sys import argv


#  DESC: Função para escrever mensagens em AZUL

def __blue(msg: str) -> str:
    return f'\033[31m{msg}\033[m'


#  DESC: Função para escrever mensagens em VERMELHO

def __red(msg: str) -> str:
    return f'\033[34m{msg}\033[m'


#  INFO: Interrompe o programa e devolve a mensagem de erro

def error_callback(error: Exception()) -> None:
    print(__red('😓 Argumentos inválidos... :/'))
    raise error


#  INFO: Seleciona as informações relevantes dos argumentos e joga num dicionário

def process_arguments() -> dict():
    default_opts: dict() = { 'playlist': '', 'dir': '.', 'video': None }
    args: list(str) = argv[1:]

    for key, value in enumerate(args):
        if value in ['--playlist', '-p']:
            default_opts['playlist'] = '--no-flat-playlist'

        elif value in ['--dir', '-d']:
            try:
                default_opts['dir'] = args[key + 1]

            except Exception as error:
                error_callback(error)

        elif 'http://' in value or 'https://' in value:
            default_opts['video'] = value

    if not default_opts['video']:
        error_callback(Exception(__blue('O vídeo não foi especificado nos argumentos')))

    return default_opts


#  DESC: Bloco principal do script

def main() -> None:
    opts: dict() = process_arguments()

    if opts['playlist']:
        playlist_name: str = input(__blue('Qual é o nome da playlist? 😎 '))
        opts['dir'] = f'{opts["dir"]}/{playlist_name}'

        try:
            mkdir(opts['dir'])

        except Exception as error:
            error_callback(error)

    system(f'cd {opts["dir"]}; yt-dlp {opts["playlist"]} -x --audio-format mp3 {opts["video"]}')


if __name__ == '__main__':
    main()

```


### *Usage*

O ideal é você definir algum tipo de atalho para esses comandos, para evitar de precisar escrever isso tudo sempre que for baixar alguma música -- o objetivo é ser rápido nesse sentido, afinal. E acredito que você sempre vá querer baixar as músicas sempre na mesma pasta, para manter organizado.

```yml
desc: Programinha simples para baixar música do YouTube.
command: ./better_yt-dlp.py [--dir OUTPUT_PATH] [--playlist] VIDEO_URL

arguments:
    --playlist|-p: Salva todos os vídeos de uma playlist, mas pergunta o nome de uma nova pasta para salvá-las
    --dir|-d OUTPUT_PATH: Pasta para salvar as músicas/playlists, o valor padrão é o diretório atual
    VIDEO_URL: URL do(s) vídeo(s), é melhor passar entre aspas para evitar erros com o shell...

examples:
    - ./better_yt-dlp.py 'https://youtube.com/SomeURL/'
    - ./better_yt-dlp.py --playlist 'https://youtube.com/SomePlaylistURL/'
    - ./better_yt-dlp.py -p --dir ~/Musics  'https://youtube.com/SomePlaylistURL/'

```