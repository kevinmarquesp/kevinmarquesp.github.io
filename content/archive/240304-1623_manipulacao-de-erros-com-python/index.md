---
title: "Manipulação de erros com Python"
date: "2023-01-26T17:05:27-03:00"

draft: false
comments: true
math: false

author: "Kevin Marques"
tags: ["programming", "python", "idea", "personal"]
---

> Tecnica inspirada em Go para manipular erros em Python (ou em qualquer outra
> linguagem de sua preferência) que "desenvolvi".

Antes de mais nada, preciso deixar claro que sou apenas um hobbysta e tenho 0
experiência proficional no mercado, portanto, não tenho certeza se isso é uma
boa prática ou não, se vale a pena usar esse método ou não. Mas mesmo assim,
achei essa ideia interessante e gostaria de compartilhá-la neste artigo, porquê
acredito que essa solução pra esse problema seja bem limpa e legível.

Irei explicar em JavaScript, no geral, não vai fazer tanta diferença porquê as
features do Python estão presentes em outras linguagens, mas tem um detalhe que
gostaria de comentar no final a respeito dessa minha solução em Python.


## Introdução do meu problema

Recentemente me deparei com o seguinte problema: minha fução não funciona as
vezes. Lógico que não foi só isso, manipular erros é comum no universo de
software. No entanto, eu fico um tanto incomodado com syntaxes similares à do
`try` `catch` do Javascript. Na minha opinão, a parte do `catch` deveria ser
abstraída em uma outra função, separada do código que tenta executar a função
de caráter duvidoso, que pode dar erro a qualquer momento.

Na hora lembrei de Go, onde `error` é um tipo da linguagem e as funções podem
retornar um valor desse tipo, indicando que ela deu errado. Ai você teria que
lidar com isso manualmente (que, na minha opinião, é válido de crítica, mas
isso está muito fora do escopo deste artigo).

```go
func main() {
  foo, err := foo.Connect("id")
  if err != nil {
    log.Fatal(err)
  }
}
```

Mas isso não é totalmente ruim, nada me impede de simplesmente ignorar que esse
erro existe trocando o `err` por um `_` e pronto! Essa liberdade que é
interessante. Mas não vejo necessidade disso em uma linguagem que tenha o `try`
`catch`.


## Exemplo de solução com Javascript

Ok, agora vamos para o Javascript. E se na nessa função hipotética
`Foo.connect()` podesse tratar do sucesso, mas dar a responsabilidade do erro
para outra função? E que função? Acredito que o usuário -- que pra todos os
efeitos e propósitos, também será um desenvolvedor -- queira fazer isso do jeito
dele, portanto, a função que pode manipular o erro pode ser passada atravéz de
um dos parâmetros.

Antes disso, um conceito muito importante que fez diferença nesse assunto: todas
as funções em Javascript retornam o tipo `undefined` por padrão (e no caso do
Python, é `None`). Isso tudo talvez faça mais sentido com um exemplo prático:

```javascript
Foo = {
  connect(id, handler) {
    try {
      /* corpo principal da função (que pode dar errado) */
    } catch (err) {
      handler(err);
    }
  },
};

Foo.connect("id", (err) => {
  throw err;
});
```

Acontece que ainda tem um problema, e se o usuário não quiser lidar com o erro?
Então, o título dessa sessão não se refere à função anônima na chamada da
função, e sim em sua definição.

Note que no exemplo abaixo, o usuário escolhe se vai querer tratar o erro ou
não, se não ele retorna `undefined` -- que é justamente o que função normalmente
faria --, mas se ele quiser tratar, a função vai retornar o que a função que
está tratando do erro quiser retornar.

```javascript
Handler = {
  fooCouldNotConnect(err) {
    throw err;
  },
};

Foo = {
  connect(id, handler = () => undefined) {
    try {
      /* corpo principal da função (que pode dar errado) */
    } catch (err) {
      return handler(err);
    }
  },
};

// manipulando o erro manualmente
Foo.connect("id", Handler.fooCouldNotConnect);

// "não há problema se ele não existir"
Foo.connect("id");
```

Vamos tentar brincar um pouquinho com isso, e se eu quiser que uma função, que
possa dar errado e foi construída com essa estrutura do `try` `catch`, persista
em ficar executando ela denovo e denovo, até finalmente ela funcionar? *I don't
know man, let's try it!*

```javascript
Handler = {
  fooCouldNotConnect(err) {
    console.log(err)
    return true;
  },
};

Foo = {
  connect(id, handler = () => undefined) {
    try {
      /* corpo principal da função (que pode dar errado) */
    } catch (err) {
      return handler(err);
    }
  },
};

while (Foo.connect("id", Handler.fooCouldNotConnect)) {
  /* nesse bloco o programa não fazer nada,
  esperar um tempinho, ou fazer outra coisa
  enquanto a a Foo.connect() tá de birra */
}
```


### O que torna Python especial

Isso pode ser facilmente adptado para funcionar em Python, já que ele têm uma
syntaxe parecida. Mas uma feature legal que o Python têm é os *decorators*, e
é justamente essa feature que vou explorar pra tornar isso tudo mais legível.

Em resumo, bem resumido, um decorator é só uma função que é executada antes da
função que está sendo "decorada" (se me permite falar assim). Então dá pra
abstrair mais ainda o código. Veja o exemplo baixo:

```python
class Decorators:
  @staticmethod
  def handle_func(handler=lambda: None):
    # handler é a função que vai tratar o erro
    def decorator(func):
      # func é a função decorada
      def wrapper(*args):
        # e *args é os argumentos da função decorada
        try:
          func()
        except Exception as err:
          return handler(err)
    return wrapper
  return decorator

class Handler:
  @staticmethod
  def foo_could_not_connect(err):
    raise err

class Foo:
  @staticmethod
  @Decorators.handle_func(Handler.foo_could_not_connect)
  def connect(id):
    # corpo da função
```

Você pode argumentar que o decorator não está bonito, e serei obrigado a
concordar. A função responsável por testar, e executar o handler que o usuário
quer, tá um horror -- talvez usar classes pra criar decorators seja o ideal.
Mas o importante é que esse horror tá separado do código principal, que seria
as duas classes de baixo nesse exemplo.

Vamos ver o nosso resultado com aquele exemplo da função persistente que mostrei
com Javascript e comparar com essa minha soulão em Python fazendo o uso dos
decorators:

```python
class Handler:
  @staticmethod
  def foo_could_not_connect(err):
    print(err)
    return True

class Foo:
  @staticmethod
  @Decorators.handle_func(Handler.foo_could_not_connect)
  def connect(id):
    # corpo da função, sem blocos estranhos aqui

while Foo.connect("id"):
    pass
```

Exelente! Agora se você quiser executar a função `Handler.foo_could_not_connect`
caso a função `Foo.connect` não funcione, é questão de adicionar uma linha a
mais, indicando qual função rodar se a outra falhar.

Mas lógico, isso não é totalmente igual aos outros exemplos, porquê o usuário
não terá a mesma liberdade de passar uma outra função como parâmetro, caso ele
não tenha acesso ou definido a função `Foo.connect` ele mesmo. Mas mesmo assim,
não deixa de ser uma solução elegante e eficiênte, talvez não tão perfomática do
ponto de vista computacional, mas ainda assim, eficiênte.


## Conclusão

Com essa brincadiera, percebi como Python é uma linguagem poderosa pro
desenvolvedor, não só por ser fácil de entender e a syntaxe ser simplificada,
mas também por ter esse tipo de feature que permite ser "preguiçoso", no sentido
de se esforçar agora pra depois ser mais produtivo no futuro. Apesar disso,
Python tem seus defeitos (vários, cá entre nós), mas é inegável que ela foi
desenhada pra tornar os desenvolvedores mais eficiêntes e ela faz isso muito
bem.