---
title: "Common Lisp | Primeiras Impressões"
date: "2024-06-25T10:43:07-03:00"

draft: false
comments: true
math: true
toc: true

author: "Kevin Marques"
tags: ["programming", "learning", "lisp", "common_lisp", "first_impressions"]
---

Eu estava assistindo [Lain](https://en.wikipedia.org/wiki/Serial_Experiments_Lain) e em um dos episódios piscou um código em Lisp, não sei se era Common Lisp ou Schema, mas achei legal a referência. Lembrei que o Uncle Bob comentou que a linguagem primária dele agora é Clojure, então decidi dar uma chance pro Lisp.

Não pretendo me tornar eficiente na linguagem nem nada, quero só estudar e aprender o básico sem compromisso nenhum; acabou que foi uma experiência super divertida. Daí, enquanto estava estudando e *codando*, decidi que seria uma boa ideia documentar as aventuras e tropeços que passei no processo. O artigo de hoje é só isso, um pequeno diário de alguém que não sabia nada de Lisp, Common Lisp mais especificamente, e em 3 dias já estava confortável com a linguagem. Acho que Common Lisp foi a linguagem mais simples que vi até agora.

## Correndo Antes De Andar

Não sei explicar, mas quando fiquei vontade de aprender Lisp, pensei que seria uma boa ideia tentar fazer algum tipo de exercício simples pra praticar, ai depois eu penso em me aprofundar mais na linguagem com algum projeto mais interessante e maior. Eu poderia tirar um exercício do Leetcode, ou de alguma outra plataforma, mas eu queria uma coisa mais interativa. Foi então que lembrei dos exercícios de Python que o Gustavo Guanabara propôs no seu curso de Python no canal Curso em Vídeo – pra ser específico, eu peguei o último desafio, o de número 115, do último módulo ([a aula 23 do curso](https://youtu.be/xz2B3bfNjEk)).

O desafio era bem simples: *"Crie um pequeno sistema **modularizado** que permita cadastrar pessoas pelo o seu **nome** e **idade** em um arquivo de texto simples. O sistema só vai ter 2 opções: cadastrar uma nova pessoa e **listar** todas as pessoas cadastradas"*. Mudei algumas coisinhas, como fazer esse "sistema" mostrar sempre a lista de pessoas se tiver ao menos uma e usar um banco de dados SQLite3 no lugar de um arquivo de texto, também quero aprender um pouco com costumam lidar comesse tipo de coisa na linguagem.

Enfim, o projeto foi um sucesso, em apenas 3 dias – passando vergonha no Github e no Discord com perguntas bestas – consegui terminá-lo, exatamente do jeito que queria. Eu sei que o certo era eu ler as documentações e ir me acostumando com calma, mas eu estava meio ansioso com a ideia de aprender uma linguagem importante historicamente e eu queria ver o quão simples e intuitiva ela é. O código fonte do projeto final pode ser encontrado [aqui](https://github.com/kevinmarquesp/lisp-person-register).

## Scheme, Common Lisp Ou Clojure?

Quando fui pesquisar "com aprender Lisp" me deparei com esse pequeno problema. Parece que Lisp não é, exatamente, uma linguagem em si, e sim uma espécie de dialeto que uma família de linguagens usa, como Scheme, Common Lisp (a que eu escolhi pra estudar) e Clojure. O que me surpreendeu um pouco, porque eu sempre achei que Clojure e Scheme fosse linguagens inspiradas em Lisp – assim como Java é inspirado em C –, não que elas fossem um sabor de Lisp.

Mas é, por isso que dizem que Lisp é uma das linguagens mais antigas que permanece super ativa até hoje. E não é só porque Clojure ficou popular não, Common Lisp é uma linguagem super madura e têm um ecosistema bem completo. Mesmo usado em sistemas mais legados – também porque todo mundo vai acabar escolhendo um Python, Java ou Elixir, por ser mais fácil de contratar programador –, nas documentações eu vi que têm um manual de boas práticas pra criar páginas web dinâmicas com HTMX, e HTMX é uma ferramenta super recente; acho que saiu ano retrasado, coisa assim.

## O Que Significa Os Parenteses

Isso é engraçado até, é a primeira coisa que chama atenção na linguagem. Basicamente, em Lisp, usa-se a exata mesma sintaxe pra tudo: você cria uma lista com parenteses, os elementos dela são separados por espaços, o primeiro símbolo será o **nome da instrução** e o restante os **parâmetros**. E quando digo tudo, é tudo mesmo.

Por exemplo, se você quiser imprimir uma coisa na tela, você pode usar a função `print` e passar o argumento `"Hello"` pra ela, quando você der enter no REPL[^repl], o interpretador vai procurar pelo primeiro elemento da lista que você passou, o símbolo `print`, e ver se ele está associado com alguma função, daí ele vai passar o restante da lista, no caso só o `"Hello"`, como argumento da função.

[^repl]: Esse acrônimo significa "Leia, Executa, Mostra e Repita" (do inglês *Read, Evaluate, Print then Loop*). Um REPL é um programa que abre uma espécie de *shell* interativo no qual você pode escrever comandos e o interpretador vai executando um de cada vez. Sabe o quando você digita `node` ou `python3` no terminal e ele abre um shell interativo? Então, é isso.

```lisp
(print "Hello")
; "Hello"
```

E tudo funciona desse mesmo jeito. Quer definir uma função? Use a função `defun`, o primeiro argumento deve ser o nome da função, depois uma lista de símbolos pra ela usar de parâmetro, daí uma string explicando o que ela faz e, por fim, todos os outros argumentos serão o corpo da função, executando-os um por vez.

```lisp
(defun say-something (message)
	"Essa função vai mostrar uma  mensagem na tela."
	(print "Executando...")
	(print message))

(say-something "Hello world!")
; "Executando..."
; "Hello world!"
```

> Pois é,  isso é um detalhe da linguagem. Já que são poucos os caracteres que ela usa pra compor a sintaxe, o nome das funções/macros/variáveis/etc. podem ter esses caracteres estranhos, e até começar com números (só não podem *ser* um número, porque números são um tipo primitivo da linguagem). Eu, particularmente, gosto de nomear minhas funções em *kebab case*.

Até mesmo os operadores são assim, eles são funções que se chamam `+`, `-`, `*`, `/`, etc. Por exemplo, se você quiser calcular $1 + 2 \times 3$ você precisa fazer assim: `(+ 1 (* 2 3))` – note que a ordem de precedência não é automática, o próprio programador têm que escrever as funções desse jeito. Faz sentido quando você pensa na AST[^ast], mas ainda acho meio chato não ter a conveniência de escrever uma operação do jeito que eu leio ela.

[^ast]: *Abstract Syntax Tree*. É o jeito que os compiladores/interpretadores entendem o código que escrevemos, não quero entrar muito em detalhes – também porque não passei muito tempo estudando sobre compiladores.

Mas se tudo é uma lista, então como que define uma lista de fato? Adivinha.

```lisp
(list 1 2 3)
; (1 2 3)

'(1 2 3) ;; Mas têm um syntax sugar pra isso, relaxa...
; (1 2 3)
```



## Tocando Um Projeto Do Zero

O desenvolvimento em Lisp não é tão diferente do que seria em Elixir. Parece que o ideal é você ter o seu projeto aberto num editor de texto e, em outra janela, ter algum tipo de REPL[^repl], daí você vai alterando o código e executando suas funções individuais na outra janela. Imagino que essa seja a forma clássica de se trabalhar com Common Lisp e Clojure – acho que é viável de se trabalhar assim até com os shells de Python e Ruby –, mas, além disso, têm inúmeros compiladores, interpretadores e até *transpilers* pra outras linguagens pros vários sabores de Lisp.

Enfim, o *shell* que escolhi foi o primeiro que achei, ele se chama **SBCL** (*Steel Bank Common Lisp*), o nome do pacote que baixei com o Pacman – também ta disponível nos repositórios padrão do APT – se chama `sbcl`. O problema é que o prompt dele é meio esquisito, as setas do teclado não movem o cursor, eles inserem uns caracteres estranhos – é o mesmo problema do comando `read` de Shell Script, que lê literalmente o que foi enviado pelo teclado, até caracteres que não são letras, números ou símbolos. Por causa disso, a [documentação](https://lispcookbook.github.io/cl-cookbook/getting-started.html) que estava lendo recomenda baixar também o `rlwrap` pra concertar esse comportamento.

Então agora é só abrir o tal REPL com `rlwrap sbcl` e começar a digitar. Imagino que tenha comandos pra importar um módulo, ou pacote, ou seja lá como chamam um projeto em Lisp, daí é só rodar alguma função que inicia o meu programa, como `(start)`, ou alguma outra função individual pra testar ela separada das outras; gosto desse estilo de desenvolvimento.

A única coisa que não entendo é o que fazer depois que terminei a minha aplicação, supondo que seja uma aplicação web. Eu devo usar um compilador pra gerar um binário estático? Ou devo só subir o app do mesmo jeito que fiz localmente com o SBCL? A linguagem é tão extensível que não duvido que não haja uma solução definitiva, deve valer até transpilar o código pra Javascript e usar esse Javascript em produção. Depois eu pesquiso com detalhes sobre isso, vou tentar focar mais na parte de desenvolvimento.

> Retirado de: [[common-lisp-com-sbcl]] 

### Instalando E Utilizando O Quicklisp

O Quicklisp é só o gerenciador de pacotes da linguagem, não se existem outros, mas parece ser o mais popular. A instalação é super simples, basta clonar o [instalador](https://beta.quicklisp.org/quicklisp.lisp) – um script em Common Lisp – com `(load "caminho/pro/quicklisp.lisp")` e carregar ele no SBCL, daí, já que ele é meio que um pacote por si só, é questão de rodar a função `(quicklisp-quickstart:install)`. Realmente não é nada complicado, achei super intuitivo, mesmo sabendo um total de zero (0) coisas sobre lisp.

Essa função de instalação vai baixar outro script, mas vai ser um global, em `~/quicklisp/setup.lisp`. Mas eu preferi fazer a instalação do Quicklisp em `~/.quicklisp` com `(quicklisp-quickstart:install :path "~/.quicklisp")`, só pra não sujar a minha *home*. Daí, pra usar o Quicklisp apropriadamente, teria que carregar esse arquivo de setup toda vez que abrir o REPL do SBCL. Felizmente, o Quicklisp também têm uma função pra configurar esse *auto load* assim que eu abro o SBCL, é só rodar `(ql:add-to-init-file)` depois de ter carregado uma vez, ai as próximas não vai precisar mais.

E como faz pra instalar algum sistema? Mais uma vez, super simples: `(ql:quickload "nome-do-sistema")`, ou `(ql:quickload '("nome" "de" "vários" "sistemas"))`. Esse *quickload* vai carregar todas as funções desse sistema, se ele já não existir em algum lugar dentro de `~/.quicklisp`, o *quickload* vai baixar o sistema antes de carregar. E pra usar as funções do sistema? A notação pra isso é `(nome-do-sistema:nome-do-simbolo "argumentos")`, mas dá pra usar também a função `(in-package :nome-do-sistema)` pra expandir o *namespace* e conseguir acessar as funções do sistema normalmente.

### Criando Um Projeto Novo

Mais uma vez, extremamente simples de começar, a [página](https://lispcookbook.github.io/cl-cookbook/getting-started.html) que eu estava seguindo recomendava usar o sistema *Cl-Project*, daí eu o baixei e rodei a função que cria o template de um projeto em Common Lisp. É super legal, já vem incluso até dois README's (um em *Org* e outro em Markdown) e um arquivo `meu-projeto.asd` – que é parecido com um `package.json`, com nome, versão, descrição do projeto e lista de dependências. E, claro, já vem com uma suite de testes com o *Rove*, não sei se têm outros sistemas de unit testing melhores, mas essa foi super simples de usar.

```lisp
(ql:quickload "cl-project")
;; Instala (se já não tinha sido) e carrega o sistema

(cl-project:make-project #P"./nome-do-projeto")
;; Cria um projeto novo no diretório atual com essa estrutura:
;; nome-do-projeto/
;; ├── nome-do-projeto.asd
;; ├── README.markdown
;; ├── README.org
;; ├── src/
;; │   └── main.lisp
;; └── tests/
;;     └── main.lisp
```

> Eu não sei exatamente o que é esse `#P`, eu imagino que seja algo como *path*, porque essa função simplesmente não consegue usar uma *string* simples.

Um adendo importante, como em Lisp a idea é você carregar o projeto num REPL e ir testando uma função por vez, vai ficar mais fácil carregar o projeto se ele estiver em alguns dos diretórios abaixo. Isso porque o Quicklisp, e o ASDF também (não faço ideia do que significa, mas ele também consegue carregar sistemas, mas ele não baixa e nem baixa as dependencias do sistema automaticamente igual o Quicklisp), automaticamente procuram por sistemas dentro desses diretórios também. Aí é só carregar com `(ql:quickload "nome-do-projeto")`, sem precisar especificar o path de onde o projeto está.
+ `~/.quicklisp/local-projects`;
+ `~/common-lisp` (esse aqui nem fez muito sentido pra mim, mas ok);
+ `~/.local/share/common-lisp/source`.

#### Rodando Um Projeto Local

No meu caso, eu queria colocar meu novo sistema na minha pasta de projetos do Github, então pra carregar, eu tive que usar um comando bem longo em ASDF. O motivo disso é que, pra carregar um sistema fora desses diretórios de projeto padrão da linguagem, o ASDF precisa saber o caminho completo do arquivo `.asd`, daí o sistema fica acessível pra ser carregado com o *load-system* do ASDF ou com o *quickload* do Quicklisp. Tentei fazer isso só com o *quickload* do Quicklisp, mas não deu muito certo, então fiquei com o ASDF + Quicklisp mesmo. Não sei se é a melhor solução.

```lisp
(asdf:load-asd (merge-pathnames "nome-do-projeto.asd" (uiop:getcwd)))
;; Usa o path do diretório atual e junta com o arquivo .asd do meu projeto.

(ql:quickload :nome-do-projeto)
;; Instala as dependencias e carrega as funções do projeto.
```

E mesmo com todas as conveniências do *quickload*, eu preferi usar o *load-system* do ASDF no meu projeto porque eu estava tendo alguns problemas com a conexão com o banco SQLite3. Não era exatamente um problema, passei horas achando que fosse, na verdade era o debugger do SBCL reclamando que uma variável estava sendo redefinida, no caso, a variável de conexão com o banco, que eu não tenho acesso direito por estar usando uma ORM.

> O que estranhei é que esse aviso só acontecia na segunda vez que eu rodava o programa no mesmo terminal, se eu fechasse o terminal e abrisse de novo, tudo funcionava perfeitamente, ao menos até a segunda vez que rodasse o meu código. Enfim, não tenho muita certeza, mas acho que isso é algo relacionado ao jeito que o compilador – pelo visto, os sistemas passam por alguma faze de compilação quando são carregados, não são 100% interpretados; mas nenhuma linguagem é – *cacheia* certas informações, daí ele dava esse erro.

Pra solucionar isso, usei a opção de forçar o recompilamento do sistema que o *load-system* oferece. Daí passei a usar o *quickload* só pra baixar as dependencias. Lógico que joguei tudo num [Makefile](https://github.com/kevinmarquesp/lisp-person-register/blob/main/Makefile). A partir desse ponto, essa minha solução já estava fedendo a gambiarra, mas eu só queria terminar o projeto logo, então fiquei satisfeito com isso.

```lisp
(asdf:load-asd (merge-pathnames "nome-do-projeto.asd" (uiop:getcwd)))
;; Carrega as informações do .asd do meu projeto.

(ql:quickload "nome-do-projeto")
;; Instala as dependencias e roda o projeto (só executo isso uma vez).

(asdf:load-system "nome-do-projeto" :force t)
;; Usso isso aqui pra recompilar o sistema todo e carregá-lo novamente.

(in-package :nome-do-projeto)
;; Pra eu não precisar ficar escrevendo (nome-do-projeto:funcao) toda hora.

(start)
;; Ai essa é a função que criei pra iniciar o meu sisteminha.
```

#### Concertando O Erro Do Package Locked

Eu estava tentando rodar os testes que vieram no template de projeto, mas quando eu tentava instalar o *Rove*, ficava dando um erro super esquisito e não informativo. Perguntei pro Chat-GPT e ele respondeu que é um problema de *lock* dos pacotes.

Pela a explicação dele, o Rove precisava fazer mudanças no `:sb-di` – não sei exatamente o que é, mas têm haver com o gerenciador de pacotes –, mas não conseguia por conta dessa camada de segurança. Então rodei `(sb-ext:unlock-package 'sb-di)` pra destravar essa biblioteca. Consegui baixar o Rove tranquilamente depois, e consegui integrá-lo no meu ambiente de desenvolvimento. Mas que foi dor de cabeça foi.

Não faço ideia se isso é uma boa prática ou não, depois eu preciso pesquisar com mais calma. Espero que isso não me dê problema no futuro, em outros projetos.



#### Testes Não São Tão Difíceis

Não entendi exatamente porque é o ASDF que roda os testes, mas é só usar o comando `(asdf:test-system :nome-do-projeto)` no REPL que dá certo. Não sei também se isso só funciona com o *Rove*, preciso pesquisar mais depois.

A única coisa que achei estranha é que ele não parece contar a quantidade de testes que passaram, ele conta quantas *suites* passaram com sucesso. Se algum teste falhar, ele vai mostrar o erro e vai até explicar o que a função está retornando e etc., mas isso não acontece com os testes que passam, ele só ignora. Entendo que realmente não têm necessidade porque se tudo funciona como você espera então não há razão pra dar atenção, mas sinto uma falta da descarga de dopamina quando vejo uma listinha testes passando, tudo verdinho.

E um detalhe, no arquivo de teste eu não importo as funções que eu preciso testar, parece que a filosofia é testar pacotes inteiros por vez. Ou seja, ao invés de importar com a diretiva `:import-from` (detalhe da sintaxe linguagem) eu coloquei direto no `:use` o pacote que estou testando, aí meus testes ficam no mesmo *namespace* (ou *escopo*, se fizer mais sentido pra você) que o tal pacote.



#### Concertando O Erro Do Defconstant

Outro probleminha que tive enquanto trabalhava nesse projeto. Eu estava querendo definir uma constante com o caminho do arquivo em SQLite3 no código, tudo deu certo na primeira vez que rodei o código, escrevi mais algumas coisas e o código deu erro na segunda vez que rodei. Perdi um tempinho desfazendo as mudanças que fiz pra ver se o código continuava funcionando, mas não.

Parece que a macro `defconstant` funciona tanto em tempo de compilação quanto na hora de carregar o sistema, então a primeira vez funciona porque ele precisa compilar parte do código na primeira vez pra executar, mas na segunda vez o SBCL chama essa macro de novo, só que na hora do load.

Eu que dei um pouco de azar de começar com o SBCL, mas outras implementações do Lisp concertam esse comportamento estranho e fazem o código se comportar do jeito que espera. Mas têm uma saída pro meu caso, é só deixar explicito pro SBCL pra ele só carregar essa constante em tempo de compilação, no load não precisa:

```lisp
(eval-when (:compile-toplevel)
	(defconstant DATABASE "dev/database.sqlite3"
		"Path to the SQLite3 database file [...]."))
```



## Conclusão Do Projeto E O Que Aprendi

Eu finalmente conclui o projeto que queria, uma aplicação simples que registra nomes de usuários e a idade de cada um num banco de dados SQLite3. Nessa brincadeira aprendi muito sobre a sintaxe, os paradigmas e até alguns patterns bem básicos, mas nada muito avançado. Fiz sem ter lido as documentações direito, só com o que me aparecia no Duck Duck Go quando pesquisava – o Chat GPT mais atrapalhou do que ajudou.

Sobre o pouco das documentações que li até agora, são super bem escritas, completas e, principalmente, atualizadas. Têm até vídeos no youtube explicando como fazer uma página web dinâmica com HTMX – quando que HTMX foi lançado ano retrasado, coisa assim. O fato de eu ter chegado tão longe sem saber nada só mostra o quão simples e intuitiva a linguagem é, não é pra menos também, a linguagem só têm uma sintaxe que usa pra tudo.

Também curti com foi super intuitivo a lógica pra construir uma função. Lembro que estava querendo uma função que pegasse o input do usuário, mas que mostrasse um prompt antes, não deu 30 segundos de pesquisa – só batendo olho em código de Stack Overflow rapidamente – que cheguei a minha própria solução:

```lisp
(defun prompt (message)
  "Reads the user input as a string, it also allows to provide a custom prompt."
  (format t "~a" message)
  (finish-output)
  (read-line nil 'eof nil))
```

Só é triste que a linguagem não é tão popular.



### Outros Detalhes Da Sintaxe

Achei isso aqui relativamente interessante. Tudo na linguagem são funções, até os operadores você trata como se fossem funções, e isso se repete pra algumas coisas básicas que fazemos sem pensar muito em outras linguagem. Então, pra definir uma variável você vai precisar da macro `defvar`, e por ser uma macro eu conclui que o escopo dessa nova variável deve ser global, já que não faz diferença nenhuma eu chamar essa macro dentro ou fora de uma função, a macro é a mesma.

E aconteceu o que eu esperava, a variável se torna global, parece que a ideia de escopo nessa linguagem só se aplica à pacotes, e só. O que é interessante, porque também explica porque os snippets de Lisp que vejo por ai é composto por funções pequenas, mas muitas delas – que é um estilo de escrita que acho legal.

```lisp
(defun define-fulano (name)
  (defvar fulano name))

(defun display-fulano ()
  (format t fulano))

(define-fulano "Fulano de Tal") ; O inverso daria erro.
(display-fulano)
```



Enquanto estava escrevendo o código, eu estava com dificuldade em usar uma biblioteca que me dava uma ORM pra acessar o meu banco de dados – estava usando o Mito, e ele têm suporte a Postgres e MySQL também –, e essa biblioteca têm uma macro pra ler todas as colunas de uma tabela no banco e retornar um objeto. Imagine minha surpresa ao saber que Lisp também pode ser orientado à objetos.

Enfim, estava com dificuldade de acessar os valores dos atributos da instância que essa macro retornava, dei uma lida nas documentações e descobri que toda classe têm um negócio chamado *accessor*. Pra todos os efeitos e propósitos, é um *getter*, mas todo atributo precisa ter um, parece que todos eles são privados por padrão.

Mas consigo entender porque esses accessors são obrigatórios. Toda variável é global dentro de Lisp, só os parâmetros das funções que têm um escopo local, e tudo em Lisp é uma função, até as classes. Demorou pra fazer sentido pra mim, mas deu pra entender e continuar com o projeto sabendo desse básico.



E outro detalhe, não relacionado com os outros, é que a linguagem de formatação de *strings* da linguagem é super completa, tão completa quanto as *f-strings* de Python. Por exemplo, eu usei `~:(~24a~)` capitalizar o nome (esse `~:(~)`) dos usuários e alinhá-los à esquerda ocupando 24 caracteres (com esse `~24a`), e também fiz a mesma coisa com a idade, alinhei eles à esquerda ocupando 3 caracteres com `~3a`. Sei que não é nada demais, mas achei legal mencionar isso.


## Saiba Mais

Documento que utilizei pra fazer *speedrun* de Lisp sem saber nada:
+ [The Common Lisp Cookbook -- Getting started with Common Lisp](https://lispcookbook.github.io/cl-cookbook/getting-started.html)

Código fonte do projeto que cosntrui:
+ [Lisp-Person-Register](https://github.com/kevinmarquesp/lisp-person-register)
