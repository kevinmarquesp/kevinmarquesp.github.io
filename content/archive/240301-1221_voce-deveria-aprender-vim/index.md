---
title: "Você deveria aprender VIM"
date: "2022-07-17T12:21:51-03:00"

draft: false
comments: true
math: false

author: "Kevin Marques"
tags: ["programming", "automation", "vim", "linux"]
---

> Porquê você deveria dedicar um tempo para aprender a usar o Vim


Acredito que todos os que usam Linux, ou qualquer sistema Unix-like, deveriam dedicar ao menos uma semana para aprender a usar o Vim, principalmente se você está planejando construir sua carreira na área de software. Apesar ter sido feito em 1991, esse editor de texto ainda consegue me surpreender a cada dia que passa por ele ser tão completo e **fácil** de usar.

Até quem usa o Atom, Sublime Text, VS Code --- se não me engano, até Notepad++ ---, etc., estão começando a emular o comportamento do VIM dentro desses editores com plugins feitos pela comunidade. Talvez você já tenha visto um tutorial, ou feito algum curso, que o cursor do editor dos vídeos se movimenta de uma forma estranha, bem, vou tentar apresentar esse ponto pra você que não conhece esse assunto e vou tentar trazer algumas dicas pra quem já usa o Vim.


## O que o Vim têm de tão especial

Vou assumir que você ao menos tem alguma ideia do contexto histórico de como o Vim foi criado, então vou pular para a explicação do porque ele é um editor de texto lendário.

1. Ele é um editor que é feito para desenvolver, então ele têm várias features que se assemelham com os editores de texto que você talvez esteja acostumado a usar.
2. A ideia de navegar pelo seu texto no **normal mode** e começar a inserir coisas no **insert mode** é fenomenal, alguns dizem que no insert mode você está mergulhando no arquivo que você está editando e no normal mode você está na superfície, tendo uma visão geral de cada elemento do texto.
3. Usar `hjkl` ao invés das setinhas do teclado são mais ergonômicas, além do que, você não vai mais depender do mouse para navegar pelo documento, você pode voltar com `{` e`}` no modo normal se quiser pular pedaços grandes de texto.
4. E o principal, ele é customizável...

Desvantagens? Bem, a curva de aprendizado realmente é grande, e você vai começar sendo super lento com os vários comandos e atalhos que o Vim possuí, mas aprender qualquer coisa é assim mesmo. Você começa devagar pra depois ficar rápida, eventualmente você vai ser um daqueles que pensa "cara, por quê isso não têm *[insira alguma feature do Vim aqui]*?".

Isso leva tempo, e realmente só depende de você pesquisar e ler a [*vim documentation*](https://vimhelp.org/) --- você pode também rodar o comando `:help` dentro do Vim ---, mas o esforço vale muito a pena.


### Customizações!

Não estou brincando, acho que o Vim e o Neovim (que é uma versão melhor do Vim, mas escrito em Lua e não em Vimscript) são os pedaços de software mais customizáveis que já vi. Sempre que você abre o Vim ele procura carregar um arquivo de configuração dentro da sua `/home`, e é dentro dele que você pode mudar o comportamento de **tudo** do editor. Para começar a editar, você precisar fazer duas coisas: Abrir o arquivo `~/.vimrc` --- ou `~/.config/nvim/init.lua` se você usa o Neovim ---, e uma aba no seu navegador com o Google. Depois disso é só se divertir usando o **seu** editor.

Isso também é outra coisa interessante, cada configuração de Vim no planeta é único, pois cada um tem suas necessidades e preferências diferentes com as teclas que quer usar para editar. E eu quero trazer um pouco da minha configuração do Vim.


## Meu workflow com o Vim

Eu sei... Eu sei.. Plugins. Mas isso não conta, com plugins qualquer editor consegue satisfazer qualquer um, então só vou compartilhar as minhas customizações do Vim e não do Neovim (que é o que estou usando para programar, por sinal, está cheio de plugins).


### Configurações gerais

```vim
" Remove os ~ do final dos arquivos
set fcs=eob:\
" Usa syntaxe dos arquivos de wiki do vim para arquivos .txt
au BufWinEnter *.txt set ft=help
" Minha tecla leader para rodar alguns mappings customizados
let mapleader="\<space>"

" Setup inicial para algumas features funcionarem sem plugins
set nocompatible
filetype plugin on
syntax enable
```


### Meu setup sem plugins

#### *Fuzzy file search*

Essa variável, `paht`, guarda o caminho das pastas que o Vim pode abrir, adicionando `**` à ela, podemos usar o `:find` para procurar todos os arquivos em todos os diretórios e subdiretórios da pasta que o Vim foi aberto. Detalhe: Eu removi as pastas que se chamem *node_modules* por eu trabalhar muito com JavaScript.

```vim
set path+=**
set path-=**/node_modules/**

set wildmenu
nnoremap <leader>FF :find ./**/
```


#### *Autocomplete suggestion*

Essa feature já é embutida no Vim por padrão, use `<c-n>` no insert mode para ativá-la. Mas eu adicionei algumas keys para ela se ativar sozinha com alguns caracteres, note que se eu digitar `/` ele abre uma janela com todos os arquivos que ele encontrar nesse path.

```vim
" O <c-p> volta o cursor para a linha que estou editando
inoremap / /<c-x><c-f><c-p>
inoremap . .<c-n><c-p>
```


#### *Tag jumping*

Essa é a feature mais poderosa que eu conheço do Vim, em resumo, você pode simular a função de *jump to definition* apertando `^]` em cima de uma implementação de uma função. Por exemplo, se eu estiver com o cursor em cima de `foo()`, ele vai direto pra linha (e arquivo) onde `foo()` foi definido --- por exemplo `func foo() string {`. E você pode voltar na stack com `<c-t>`

Mas pra isso, o Vim lê um arquivo chamado `tags` na raiz do projeto que você abriu, e para gerar esse arquivo você precisa da ferramenta `ctags`, eu implementei isso no meu Vim para eu não precisar ficar trocando entre editor, terminal, editor, terminal...

```vim
command! MakeTags !ctags -R --exclude=.git --exclude=node_modules --exclude=test .
```


## Recomendações de sources

Muito obrigado por ler o meu artigo, espero ter ajudado. Mas antes de acabar, eu quero listar alguns links que me ajudaram muito.

+ [https://vimhelp.org/](https://vimhelp.org/)
+ [https://www.youtube.com/playlist?list=PLhoH5vyxr6Qq41NFL4GvhFp-WLd5xzIzZ](https://www.youtube.com/playlist?list=PLhoH5vyxr6Qq41NFL4GvhFp-WLd5xzIzZ)
+ [https://www.youtube.com/watch?v=XA2WjJbmmoM&ab_channel=thoughtbot](https://www.youtube.com/watch?v=XA2WjJbmmoM&ab_channel=thoughtbot)

E, claro, meus *dotfiles* do Neovim e o do Vim:

+ Neovim: [https://gitlab.com/m10769/nvim](https://gitlab.com/m10769/nvim)
+ Vimrc: [https://gitlab.com/m10769/nvim/-/blob/main/.vimrc](https://gitlab.com/m10769/nvim/-/blob/main/.vimrc)
