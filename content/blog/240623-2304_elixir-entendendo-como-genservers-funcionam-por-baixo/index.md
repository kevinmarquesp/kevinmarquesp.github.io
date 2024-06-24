---
title: "Elixir | Entendendo Como GenServers Funcionam por Baixo"
date: "2024-06-23T23:04:14-03:00"

draft: false
comments: true
math: false
toc: true

author: "Kevin Marques"
tags: ["programming", "learning"]
---

Já que eu achei meio complicado entender o que são esses GenServers de Elixir 
que tanto falam, estou aqui pra tentar explicar o que entendi deles – já que 
não dá pra ser funcional (piada não intencional) na linguagem sem ter essa 
base.

O público alvo desse artigo é eu mesmo no futuro, quando estiver precisando 
de alguma referência sobre o assunto, e o pessoal que também está começando 
a explorar essa linguagem. Será um compilado de vários conceitos super 
básicos e *code snippets*, recomendo tente executar eles enquanto lê. Enfim, 
*let's go*.

## Conceitos Básicos Sobre a Linguagem

Antes de tentar dar um passo maior que a perna, acho bom entender antes essa 
dinâmica de processos do Elixir, já que meio que a linguagem foi vendida pra 
mim com essa promessa dela ser muito boa no assunto. Daí, de *snippet* em 
*snippet*, alguns conceitos e *features* da linguagem serão esclarecidos a um 
nível que fique até óbvio entender o problema que os *GenServers* resolve 
– ao menos foi pra mim, espero que seja fácil pra você também.

Esse conteúdo não é total de autoria minha, a 
[palestra](https://youtu.be/8Ng6TfAj7Sk) do Fábio Akita também explica as 
coisas nessa ordem, mas eu achei meio confuso por ter muita informação 
condensada em uma hora só. O artigo que me ajudou muito a entender esse 
conceito foi o [Elixir: Understanding 
GenServers](https://manzanit0.github.io/elixir/2019/05/21/understanding-genserve
rs.html), escrito por Javier García em 2019.

### Como Novos Processo são Criados

Tudo começa com a capacidade do Elixir de criar processos que rodam em 
background de um jeito muito fácil. A função `spawn/1` precisa só de um 
argumento, uma função anônima que vai rodar em um processo separado, e ela 
vai retornar o PID desse processo. Uma vez com o PID em mãos, é possível 
monitorar o que está acontecendo com esse processo.

```elixir
pid = spawn(fn ->
  IO.puts("Hello world!")

  # Esse processo vai esperar 15 segundos antes de morrer.
  :timer.sleep(15_000)
  
  IO.puts("Bye world.")
end)

Process.alive?(pid)
Process.info(pid)
```

Eu gosto muito desse `Process.info/1`, ele mostra o poder que o Elixir têm pra 
lidar processo rodando em background, dá pra ver qual função esse processo 
está rodando e até informações sobre o *garbage colector* – caso não 
saiba, cada processo em Elixir tem seu próprio garbage collector. Mas tá, 
apesar desses detalhes, isso não é muito diferente do que se dá pra fazer em 
outras linguagens, como as *go routines* em Go. Onde isso fica interessante?

### Enviando e Recebendo Mensagens

Dá pra fazer muito mais que monitorar um processo pelo PID dele, também 
existe uma função que envia dados pra esse processo. Mas irei dar um passo 
pra trás aqui, vou fazer o processo atual enviar uma mensagem pra ele mesmo 
pra facilitar a compreensão.

Pra enviar mensagens pra um processo, basta passar o PID de quem deve receber a 
mensagem e a mensagem, que pode ser qualquer *data type* da linguagem, pra 
função `send/2`; ou `Process.send_after/3` se precisar esperar algum tempo 
(em milissegundos) antes de enviar a mensagem. Isso é fácil.

Agora, pra receber uma mensagem enviada, a linguagem usa uma estrutura chamada 
*receive block*. Quando o *runtime* (a execução do código) cair nesse bloco, 
ele vai parar e esperar por uma mensagem. É complicado de explicar sem 
exemplos práticos, então vamos lá:

```elixir
pid = self()

send(pid, "Hello, I'm myself!")

 Ou, use o Process.send_after/3 pra ver como o receive impede
 o usuário de fazer qualquer coisa no IEX.
Process.send_after(pid, "Hello, I'm myself!", 5_000)

receive do
  data ->
    data
end
```

Nesse exemplo, o IEX deve retornar – e não imprimir, como a função 
`IO.puts/1` faz – a string `"Hello, I'm myself!"`. Isso acontece porque o 
receive block funciona como o *case* e como as funções da linguagem, a 
última informação dela será o retorno do bloco todo. O receive block 
também usa *pattern matching*[^1] pra executar os diversos blocos de código 
que você quiser definir.

[^1]: Se ficou confuso, pesquise mais sobre a sintaxe das funções e, 
principalmente, do *case do*. Essa última estrutura é uma das, se não a, 
mais importante da linguagem; felizmente, não é tão complicado de entender.

E essa ideia de pattern matching é importante, eu posso fazer o receive block 
responder, ou fazer, algo diferente dependendo do que eu envio pra ele usando o 
`send/2`.

```elixir
pid = self()

 Dependendo do que estiver comentado, o receive vai imprimir
 uma mensagem diferente na tela.
send(pid, :tobey)
send(pid, :andrew)
send(pid, :tom)

receive do
  :tobey ->
    IO.puts("I'm the best Peter Parker!")

  :andrew ->
    IO.puts("I'm the best Spider-Man!")

  :tom ->
    IO.puts("I miss you, Mr. Stark...")
end
```

#### Entendendo a Inbox de Mensagens

Se as três linhas forem descomentadas do exemplo anterior, o case block vai 
dar match no primeiro `send/2` que foi executado, o restante vai permanecer 
acumulado na inbox. *Let me explain*.

Cada processo tem a sua própria *inbox*, e lá que as mensagens recebidas são 
acumuladas. Isso é um detalhe importante por que essa dinâmica de enviar e 
receber mensagens pode causar alguma confusão se esse conceito não estiver 
claro. Por exemplo, se eu enviar várias mensagens, uma depois da outra, o 
receive vai lidar só com uma de cada vez:

```elixir
pid = self()

send(pid, :steve)
send(pid, :thor)
send(pid, :tony)

 Eu preciso copiar esse trecho 3 vezes pra esvaziar a inbox.
receive do
  :steve ->
    IO.puts("I can do that the whole day.")

  :thor ->
    IO.puts("I'm the strongest avanger!")

  :tony ->
    IO.puts("And I am... The Iron-Man...")
end
```

É só um pequeno adendo, mas que vale ser mencionado.

Uma outra curiosidade legal, é saber que função `flush/0` existe. Essa 
função limpa a inbox do processo atual, e retorna tudo o que nela tem. Por 
exemplo, se o objetivo era só listar o que está acumulado na inbox até 
agora, daria pra fazer isso:

```elixir
pid = self()

send(pid, :steve)
send(pid, :thor)
send(pid, :tony)

flush()
```

## As Raízes de um Servidor em Elixir

Ok, agora com o conceito de PIDs, `send/2` e receive blocks, acho que dá pra 
dar um passo pra frente e começar a montar um *servidor* bem simples só com 
isso – e não, não estou falando de servidores web.

Um servidor em Elixir é, basicamente, uma função que fica rodando em loop 
recursivamente em outro processo, esperando receber alguma mensagem que vai 
ditar o que esse servidor deve fazer. E… Ta começando a se parecer com 
alguma coisa… Mas vamos por partes:

```elixir
defmodule Counter do
  def new(initial_state) do
    # Essa função, spawn/3, permite eu passar um módulo,
    # função do módulo e a lista de argumentos pra essa função.
    spawn(Counter, :listen, [initial_state])
  end

  def listen(state) do
    state =
      receive do
        :count ->
          state + 1

        :show ->
          IO.puts("Current counter value: #{state}")
          
          state
      end

    # A última operação vai chamar o loop recursivo com o
    # valor já atualizado.
    listen(state)
  end
end

 Como o usuário interagiria com o sistema desse servidor?
 Assim.

counter = Counter.new(0)

send(counter, :count)
send(counter, :count)
send(counter, :count)

send(counter, :show)
```

Nesse exemplo, o servidor `Counter` tem a função `new/1` que só serve pra 
não ficar escrevendo `send(fn -> blah blah blah end)` o tempo todo, só pra 
isso que ela serve. O que importa mesmo é esse tal de `loop/1`.

O `loop/1` vai ficar executando infinitamente, num processo em background, esse 
*receive block* que vai esperar por alguma mensagem, mensagem essa que vai 
atualizar (ou não) o estado do servidor – esse parâmetro que chamei de 
`state`[^state]. E o processo atual que o IEX está rodando pode enviar coisa 
pra esse processo, ou seja, pode fazer esse processo atualizar o seu estado 
atual.

[^state]: Se você é mais de programação funcional, esse `state` serve como 
uma espécie de *accumulator*.

No caso, esse servidor só aceita a mensagem `:count`, que soma +1 no contador 
(o estado do servidor), e a mensagem `:show`, que não faz nada com o estado, 
mas mostra o valor dele na tela.

E, cara, é meio que isso só. Um *genserver*, ou *generic server*, é só um 
módulo que diversas funções que te ajudam a escrever esses servidores. Eu 
só implementei a função `new/1` ali em cima pra ajudar, mas um `GenServer` 
de verdade têm diversas outras funções pra até evitar de ficar enviando 
mensagens com o `send/2` + o PID do servidor.

### Semelhanças com a Orientação à Objetos

Estudando o comportamento dos *generic servers* em Elixir, posso concluir que, 
na prática mesmo, eles não são muitos diferentes de objetos. Veja bem, você 
pode subir inúmeros processos com o mesmo módulo de GenServer, similar a uma 
classe criando várias instancias de objetos, é possível manter o estado 
inicial e ir atualizado a medida que necessário, se o estado for algo como um 
*hash map* então isso não difere muito das propriedades/atributos que um 
objeto pode ter.

E os métodos? Eles são as instruções que o processo executa baseado no que 
ele recebe no `receive`, no caso de Elixir esses "métodos" são chamados de 
**callbacks** – e o detalhe é que eles são diferentes de funções, eles 
são escolhidos pra executar via *pattern matching*, normalmente com um 
**átomo** que serve de nome pro método. O constructor seria o `init/1` (ou 
`new/1` no exemplo anterior), você passa o estado inicial antes de iniciar o 
event loop do processo, assim como você passa valores *default* pras 
propriedades quando se cria um novo objeto com `new MyClass()` em Javascript, 
por exemplo.

O *destructor* eu não cheguei a implementar nos meus estudos, mas sei que o 
`GenServer` do Elixir já oferece pra você definir o que fazer quando o *event 
loop* – não sei se posso chamar assim – morrer na função `stop/1`, se 
não estou enganado. Parece que no final do dia, generic servers são apenas 
classes usadas pra criar objetos que ficam funcionando em background ao invés 
de ser no mesmo processo como a maioria das outras linguagens.

## Saiba Mais

Fontes de pesquisa:
+ [Elixir: Understanding Genservers](https://manzanit0.github.io/elixir/2019/05/21/understanding-genservers.html)
+ [A Brief Guide to OTP in Elixir](https://serokell.io/blog/elixir-otp-guide)

Snippets de código mais completinhos, pra complementar o conteúdo do artigo --
lembre-se de rodá-los no IEX e ir testando devagar.
+ [kevinmarquesp/homemade_genserver.ex](https://gist.github.com/kevinmarquesp/309f403f4c6ac858dd7d61bb65d8df87)
+ [kevinmarquesp/genserver_explaination.ex](https://gist.github.com/kevinmarquesp/41a8a690d784b8a808450ec6e57edd08)
