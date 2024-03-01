---
title: "Amo e odeio OOP"
date: "2022-07-24T12:19:44-03:00"

draft: false
comments: true
math: false

author: "Kevin Marques"
tags: ["programming", "learning", "personal", "typescript", "oop", "rant"]
---

> Em resumo, amos os paradigmas funcional e OO podem resolver vários problemas

# Amo e odeio orientação à objetos

Acho que preciso deixar isso claro antes, adotar a programação funcional em cima de orientação a objetos não o torna um programador melhor ou mais eficiênte e vice-versa, de fato, NENHUM desses paradigmas é melhor que outro e TODOS podem melhor resolver problemas DIFERENTES. Vou reclamar a respeito de OOP neste artigo, mas não é motivo pra você, que é elitista de programação funcional, ficar com esse sorrizo no rosto.

Além disso, eu sou um desenvolvedor noob ainda, não leve a sério o que estou prestes a dizer, por favor. Só estou compartilhando minha opinião sobre o assunto e como tenho usado ambos os paradigmas pra resolver meus (e não seus) problemas.


## O que torna OOP especial

Antes de falar dos objetos em si, preciso comentar que essa ideia de separar trechos do código em classes realmente é uma boa idea e facilita muito no desenvolvimento. Tenho adotado muito essa perspectiva de deixar métodos estáticos (funções) e e atributos (variáveis/constantes) em uma classe separada pra manter o código organizado. Por exemplo, ao invez de separar várias funções por dar nomes similares --- tipo `getSystemFullUserName()` e `getSystemUserName()` ---, faz mais sentido deixar uma classe, estática mesmo, com os atributos `System.name` e um método `System.getFullName()`.

Mas, na prática, praticamente toda linguagem é orientada à objetos se você olhar somente por essa ótica, talvez você possa considerar os diferentes arquivos do seu projeto como objetos. O que diferencia a orientação à objetos é justamente os **objetos** que podem ser criados usando uma classe. Vou assumir que você já tenha uma certa noção do que é objetos e classes por já ter estudado outras linguagens como Python, C++, Java (principalmente Java), C#, JavaScript, TypeScript, Kotlin, etc.

Quando você está criando um jogo, por exemplo, faz total sentido olhar pro player e enxergar ele como um objeto, e não como um conjunto estranho e bagunçado de funções e variáveis. Quando você faz essa separação, fica mais fácil de lidar com o código por você já esperar um `Player.jump(): NULL` ou um `Player.hp: uint8`[^1]. Nesses casos, fica muito fácil de manter o código e escalar ele para novas features.

[^1]: Sei que não é muito convencional, mas essa é a minha notação que uso pra anotar lembrentes ou escrever artigos. Espero que seja legível o sulficiente, mas caso contrário, depois dos `:` segue o tipo da variável ou retorno da função (que é identificada por esses `()`), nesse exemplo, o `uint8` seria um valor inteiro positivo de 8 bits.


### O que torna OOP superior, querendo ou não

Como eu disse, isso torna o código fácil de entender e o nome dos métodos acabam ficando relativamente curtos --- o que é um bom sinal por quê você, como desenvolvedor, não precisa se esforçar muito para dar um nome descritível para um método/atributo novo.

Além disso, uma boa linguagem orientada à objetos vai permitir quais métodos/atributos você quer que outras classes, funções, outras partes do código em geral, podem usar ou não. O que permite que você crie trechos isolados do seu código com métodos que interagem entre si, sem interfirir em outros objetos. E, por fim, a herança, uma classe pode herdar todos os atributos e métodos de outra classe (ou seja, um objeto pode passar se comportar como um outro), isso realmente é meio complicado de explicar, portanto, vou tentar exemplificar com TypeScript:

```ts
export class Rect {
	public size: string[] = [ '10px', '20px' ];
}


export class Player extends Rect {
	constructor() {
		super(); // Herda tudo do que extendeu
	}

	public showInfo(): void {
		console.log(this.size);
	}
}


new Player().showInfo(); // [ '10px', '20px' ]
```


## OOP é pior do que o paradigma funcional

Então... Orientação à objetos é uma boa idea, mas apesar disso, é muito pesado. Eu não sei como os interpretadores/compiladores lidam com isso, mas definir um objeto, mesmo estático, deve custar caro. Acredito que isso seja o exemplo perfeito de como a tecnologia evoluiu pra deixar as linguagens mais perto do programador e mais longe da máquina.

O paradigma funcional sempre será uma escolha melhor se você está buscando por performance, mas OOP vai ser melhor pra organizar o seu projeto (principalmente se for um projeto grande). Além disso, se você não souber lidar com OOP vai se enrolar inteiro com a hierarquia das classes.

Hierarquia é de fato uma faca de dois gumes. Veja como é confuso: *"Vou criar um objeto `Game`, ai vai te um atributo `section` que pode ter vários objetos do tipo `Session`, ai o `MainGamePlay` vai extender isso e a quilo, e vai ter um `Player` que vai extender a classe `Sprite` dentro disso tudo"*. Ai depois de um tempo: *"Hmmmm, é meio lento criar um `Player` a cada `Session`..."*.

Mas não me entenda mal, nesse exemplo, herdar `Sprite` de `Player` faz total sentido, mas a estrutura disso tudo torna o tal jogo muito (exagero pra esse exemplo) complicado.


## Qual deles realmente é o "melhor"

Os dois, sendo curto e grosso. Se a linguagem que você costuma usar fornece esse paradigma, o use junto com as suas funções. Pra mim, herdar um classe de outra faz sentido em algumas partes pequenas do código.

Além disso, muitas linguagens que não são orientadas à objetos possuem alguma syntaxe pra emular esse comportamento. O que é o caso de C, Lua, Rust e Go. Mesmo com isso, você não tem escolha com essas linguagens, mas se você estiver com um C++, Python, Elixir, etc., que pertibe o uso de ambos os paradigmas, nada te impede de usufruir dos dois mundos.

E como tudo em software, depende muito do seu caso. O mais importante é deixar o códgio legível, fácil de dar manutenção e seguindo os estilos de código da comunidade da lingugagem, não importa se você vai usar várias funções com nomes longos ou uma árvore de objetos herdando métodos e atributos, ou os dois se preferir. No fim do dia, o computador não vai se importar tanto, a qualidade do que for escrito só vai ser valiosa pra outro programador.