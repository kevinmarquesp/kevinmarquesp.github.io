---
title: "Código Orientado À Gambiarra É Bom No Final Do Dia"
date: "2024-01-28T20:57:09-03:00"

draft: false
comments: true
math: false

author: "Kevin Marques"
tags: ["programming", "gambiarra", "python", "csv", "sql", "learning", "script", "project"]
---

Eu amo o termo *gambiarra* porque, na minha percepção ao menos, não significa algo necessariamente mal feito, gambiarra é uma solução prática, rápida e não permanente (essa última é opcional) pra resolver um problema, de qualquer natureza, usando os recursos disponíveis no momento. No mundo da engenharia isso tem de monte – que atire a primeira pedra quem nunca consertou um chinelo com um pedaço de clipe –, mas hoje eu quero trazer esse conceito pro mundo do desenvolvimento de *software*, e como código "orientado à gambiarra" eventualmente será útil pra ti, ou pra sua equipe.

Com esse post, eu também quero compartilhar uma ferramenta idiota que criei pra solucionar um problema idiota. Em resumo, é um *script* escrito em Python (você pode acessar o código fonte do projeto [aqui](https://github.com/kevinmarquesp/csv_to_sql)) que foi escrito na base da *speed-run* porque eu tava querendo experimentar umas ideias que tive e queria colocá-las em prática. Aprendi uma coisa ou outra nessa brincadeira, mas irei deixar isso pra depois, irei começar justificando o *statement* do título.
### O Motivo Óbvio
Tá, eu não tenho muita experiência profissional na área ainda, mas consigo reconhecer que numa sexta de noite, fazer um famoso *hot-fix* rapidão pode salvar o fim de semana de muita gente, mas sempre têm um(ns) porem(ns).

Escrever código com a mera mentalidade de resolver um problema do modo mais rápido possível consegue ser útil nessas situação, mas no longo prazo isso terá consequências desastrosas. A *code base* de um projeto ativo sempre está mudando, passando por manutenção, adicionando novas *features*, ou o que for, portanto, é de suma importância que essa tarefa seja fácil de ser executada por parte dos programadores da equipe, e essa tarefa só se tornará fácil se os programadores desenvolverem as coisas pensando nos seus colegas e no pessoal que vai ter que lidar com o que está sendo escrito agora no futuro.

E eu não tô falando de *clean code* necessariamente não, acho que clean code pode até piorar as coisas dependendo do contexto. O meu take é que você e eu, como programadores, temos a obrigação de compreender que escrevemos código para outros desenvolvedores também – e o detalhe, é que esses "outros" também pode ser você mesmo no dia seguinte, no mês seguinte ou no ano que vêm. Apenas peço um pouco de empatia na hora de fazer suas gambiarras e que garanta que esses hot-fixes não existam por tanto tempo.
### O Motivo Não Tão Óbvio
Esse é o ponto alto desse pequeno artigo. Tenho essa visão que tem muita coisa no mundo de software que nasce a partir de alguma ideia maluca, e é legal tu ver suas ideias malucas realmente são tão malucas quanto você imagina; e o oposto também vale, talvez uma ideia promissora se prova um lixo depois que tu faz um experimento de leve num projeto privado.

Assim, software é grátis e abre muitas oportunidades de criação, existem varios conselhos, *patterns* e truques pra criar determinado tipo de aplicação ou resolver determinado tipo de problema, mas nada disso é uma solução *de facto* pro que você está passando – contextos variam, problemas são ímpares, pessoas são diferentes $\therefore$ **não existe bala de prata** (em outras palavras: O problema é seu, e só seu).

Sempre vai valer a pena criar um projeto pra fazer alguma parada sem sentido, no mínimo tu vai criar memória muscular na tecnologia que você está usando para desenvolver. Além do que, descobrir que sua ideia é ruim é um avanço, tanto quanto descobrir que sua ideia é boa.
### Explicando O Tal Do Projeto
Então, isso que me motivou a escrever o artigo de hoje. Pra variar, me ocorreu aquele episódio de "acabei de aprender X, já sei Y, talvez eu consiga usar Y pra fazer tal coisa no X". O que aconteceu dessa vez foi que, finalmente, SQL deixou de ser uma *skill issue* pra mim, mas eu ainda preciso de um pouco de prática e queria praticar com uma tabela local, na minha máquina.

Então me ocorreu, pesquisei umas duas tabelas aleatórias de qualquer coisa – uma delas é de pacientes de hospital e outra de usuário de alguma serviço que não me recordo direito –, como era uma página web, fiz um script rapidinho com JavaScript, pelo console do navegador mesmo, que selecionava cada elemento e transformava numa string no formato CSV.

Depois disso, salvei essa string num arquivo e parti fazer o projeto que eu tava em mente: um script que lesse um, ou mais, arquivos CSV e *printasse* uma string que é compatível com a sintaxe de SQL, a qual eu poderia copiar e executar no meu banco de dados para criar essa tabela a adicionar as linhas pra mim (isso tudo me durou um dia e eu tava com tempo livre + entediado, não me julgue).
#### Detalhes Do Projeto & Objetivos
A grande parada desse projeto, apesar de bobo, é que eu queria que ele fosse completinho, no sentido de ser bem documentado e ter testes, não só isso, mas queria também que ele fosse simples de escrever, instalar e testar, usando o mínimo de dependências possível – por isso escolhi fazer em Python.

Tudo que expliquei, ou vou explicar ainda, nesse post eu dei mais detalhes no *readme* do projeto lá no GitHub, então, se você também tiver um tempo livre disponível e se interessar, vale a pena dar uma checada lá, críticas sempre são bem vindas.

Enfim, eu consegui o que queria:
+ O projeto possuí apenas um arquivo, o que significa que a instalação consiste em copiar esse único arquivo para algum lugar do `$PATH` do usuário;
+ O código todo, em si, não depende de nenhuma biblioteca externa, é tudo *plug and play*;
	+ Inclusive, mesma coisa pra suite de testes, apenas um executando um comandinho e os testes rodam, usando a biblioteca *builtin* do Python que lida com testes unitários.
+ E ele têm um script que converte a documentação que escrevi pra funções, usando as *docstrings* do Python, para um arquivo em Markdown e *appenda* esse resultado no próprio readme do projeto
	+ Esse script usa um pacote do PyPi, mas é a única dependencia do projeto todo…
+ E, acho que a melhor parte, foi muito rápido de fazer tudo isso, terminei esse setup todo em algumas horinhas, se eu soubesse o que estava fazendo e não tivesse "perdendo" tempo com documentação e testes, duraria minutos.
#### O Que Eu Aprendi Com Tudo Isso
Acho que depois disso tudo, o maior problema acaba sendo o fato que, se o usuário quiser que o script abra uma conexão com o banco de dados de preferencia dele e execute a *query* que ele gerou, ele terá que abrir o código fonte e implementar isso manualmente. O que, pra mim, está longe de ser um problema, só é inconveniente mesmo.

Além disso, me incomoda ter que atualizar as documentações desse jeito, depois que terminei, pesquisei um pouco e descobri que o que eu estava fazendo com as docstrings não era tão absurdo, mas o ideal é deixar essas documentações em `docs/build` ou coisa assim.

Os testes, não ironicamente, me salvaram um bom tempo, porque a parte de converter os *fields* nulos, ou números decimais/inteiros foi um saco, além de *escapar* os caracteres inválidos do SQL – clássico meme do usuário chamado `"Bob");DROP TABLE users;--"`. Testes são o tipo de coisa que me divirto fazendo mas eu tenho que me esforçar muito pra pegar no tranco, e isso é uma informação importante.

E a principal coisa que aprendi disso tudo, **é uma merda lidar com arquivos CSV**! Sério, se você poder, evita o máximo possível, não é tão simples de trabalhar quanto só meter um `file.split(",").forEach(...)` da vida. CSV é um formato de arquivo todo torto, tem que fazer umas gambiarra estranha pra pegar o cabeçalho, ou detectar se tem um, fazer a conversão dos tipos, separar o que é string do que não é, tudo muito demorado.

Depois que finalizei esse script pesquisei um pouco e caí nesse vídeo aqui: [Stop Using CSV!](https://www.youtube.com/watch?v=mGUlW6YgHjE) – esse cara explica porquê que CSV não é um bom formato pra armazenar dados e dá algumas alternativas pra esse problema, é um bom vídeo e bem editado, certamente vale o seu tempo.
