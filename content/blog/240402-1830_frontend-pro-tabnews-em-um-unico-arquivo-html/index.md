---
title: "Frontend pro Tabnews #1 | Consumindo uma API no Lado do Cliente"
date: "2024-04-02T18:30:37-03:00"

draft: false
comments: true
math: false

author: "Kevin Marques"
tags: ["programming", "learning", "htmx", "html", "series", "tabnews", "frontend"]
---

No final do mês passado eu decidi dar uma pequena pausa numa *web app*[^1] que
eu estava fazendo pra aprender um pouco mais de SQL, Go e HTMX -- e pra me
divertir, principalmente --, então decidi voltar a minha atenção pro frontend
mais uma vez, dediquei boa parte do meu tempo nesses últimos anos melhorando
minhas *skills* no backend e em ferramentais pra Linux e coisas assim (Regex,
AWK, Bash... você sabe, as paradas divertidas *underhated* do mundo Linux).

[^1]: O projeto está longe de estar completo, mas se tiver curiosidade ta [aqui](https://github.com/kevinmarquesp/go-postr)
o link para o repositório. Não tem nenhuma documentação, mas acho que da pra
deduzir como rodar e experimentar essa aplicação passando o olho no
`docker-compose.yml` e rodando `./insert_dummy.py --help` pra entender o que
esse script faz (você vai precisar baixar as dependências dele antes, lógico).

O que me motivou a voltar às minhas origens foi o fato de eu ter decido usar,
justamente, HTMX pra fazer a comunicação entre o frontend da minha aplicação e
o backend. E realmente funcionou super bem, tudo pareceu idiomático e natural,
me economizou um bom tempo que gastaria escrevendo Javascript + AJAX, super
recomendo dar uma chance pra essa biblioteca. Agora que entendi o *hype* em
volta dessa nova ferramenta, fui explorar seu potencial e me atualizar um pouco
no front pra não ficar tão pra trás -- Bem, pelo visto eu tinha realmente
perdido muita coisa, agora o CSS finalmente tem regras pra animar elementos
durante o *scroll* da página ou pra quando eles ficam visíveis pro usuário, e
também suporta a sintaxe de *nesting*, similar a um SASS ou um Less da vida
(nos próximos posts da série eu vou comentar mais sobre).

Coincidentemente, um amigo meio me apresentou o fórum Tabnews do Filipe
Deschamps. Não conhecia direito essa plataforma, então criei uma conta,
participei em algumas threads e fiz uma pequena [publicaçãozinha](https://www.tabnews.com.br/kevinmarquesp/fiz-um-scriptzinho-pra-me-ajudar-a-escrever-commits-com-emojis)
pra engajar, depois caí num vídeo que o Filipe dá mais detalhes, e lá descobri
que ela tem uma API que me dá acesso a todos os posts, comentários e dados de
usuário registrados no banco da aplicação, o que é dahora da parte deles
(*btw*, a plataforma toda é [*open source*](https://github.com/filipedeschamps/tabnews.com.br)).

Daí pintou a ideia que tu leu no título já: dado o, relativamente, grande
ecossistema de bibliotecas em Javascript e CSS que estão disponíveis pra serem
consumidas no frontend de uma aplicação via CDN, o quão longe é possível ir só
com um único arquivo `.html`? Com certeza dá pra ir muito mais longe do que
imaginei quando comecei e é provável que dê pra ir mais ainda, considerando o
meme de ter mais bibliotecas em Javascript do que pessoas na Índia, mas mesmo
assim, quero compartilhar umas coisas que aprendi nessa brincadeira -- no final
do dia eu sou só mais um cara curioso que também tá começando nessa área de
desenvolvimento.

## Puxando Informações de uma API com Javascript Puro

O primeiro, e mais importante, problema que preciso resolver pra começar esse
projeto é dar um jeito de, justamente, puxar as informações da API do Tabnews.
Mas esse é o mais fácil, é possível pedir coisa pra um servidor usando só o
Javascript no frontend sem problema nenhum com **AJAX**. O jeito que se usa as
ferramentas pra isso é meio complicado, mas nada impossível; E vale a pena
brincar um pouco com isso, eu vou abrir a página `about:blank` do Firefox aqui
e digitar o seguinte no console:

```js
//nota: Esse trecho cria uma tag <main id="app"> e coloca no <body>

const $app = document.createElement("main");

$app.setAttribute("id", "app");
$app.setAttribute("style", "background:black; color:lime;");

document.body.appendChild($app);


//nota: É aqui que a parte que importa começa

const API_ADDR = "https://qlrcfuxdfgwxkqe.free.beeceptor.com";
const xhr = new XMLHttpRequest();

xhr.onload = () => {
  const res = xhr.response;
  const $target = document.querySelector("#app");

  $target.innerHTML = res;
};

xhr.open("GET", API_ADDR);
xhr.send();
```

Essa URL, em `API_ADDR`, é uma pequena API de teste que eu fiz rapidinho no
site [Beecepter](https://beeceptor.com/)[^2], que achei por ai. Pode ser útil pra
ti que quer fazer alguns testes desse mesmo tipo, só recomendo que use 
letras geradas aleatoriamente por algum gerador de senha, ou coisa assim, pros
nomes das suas APIs no plano gratuito. Enfim...

[^2]: Não sei exatamente por quanto tempo ela vai ficar de pé, mas sinta-se
livre pra usar ela nos seus experimentos caso esteja curioso.

O detalhe sobre esse código é que, por eu estar em `about:blank`, eu decidi
criar um elemento `<main id="app">` e inserir ele na página com Javascript por
um ou dois motivos. O primeiro é que mais ou menos assim que bibliotecas como o
React funcionam por baixo -- por isso as páginas quebram quando o Javascript
está desativado --, então achei que seria legal comentar sobre aqui, já que
isso vai ser relevante mais pra frente. E o segundo motivo é que eu posso
aproveitar isso pra mudar o CSS dessa tag pra ficar mais visível pra mim que
usa a extensão Dark Reader pra ter o tema escuro na maioria dos sites.

### HTMX e suas Conveniências

Ok, mas essa minha solução com AJAX só vai me dar problema, vou ter muito
Javascript num arquivo `.html`, não me parece certo. Felizmente a biblioteca
HTMX faz justamente isso pra mim, e também no frontend como eu estou fazendo
agora. Se você já ouviu falar de HTMX e não sabia o que ele era exatamente,
agora você sabe: um conjunto de funções e scripts que facilita puxar
informações de alguma API via AJAX e inserir na sua página. Só.

Dessa vez, eu vou criar um arquivo em HTML, digamos... `htmx-demo.html`, e vou
abrir esse arquivo com o Firefox como você faria com qualquer documento em
HTML. Dentro desse arquivo, eu vou importar a biblioteca em Javascript do HTMX
via **CDN**, depois eu vou criar o meu `<main id="app">` do jeito que
mandei o Javascript criar no código anterior, mas eu vou adicionar alguns
atributos diferentes, atributos esses que o HTMX vai ler e interpretar pra
fazer o que eu quero:

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <script src="https://unpkg.com/htmx.org"></script>
  </head>
  <body>

    <main
      hx-get="https://qlrcfuxdfgwxkqe.free.beeceptor.com"
      hx-target="this"
      hx-trigger="load"
      id="app"
      style="background:black; color:lime;"
    ></main>

  </body>
</html>
```

Quando eu atualizar essa página no navegador, eu devo esperar o mesmo resultado
que tive com script que rodei na `about:blank`. E eu acho que só esse código já
é bem direto ao ponto, esse elemento `main#app` vai fazer uma aquisição `GET`
pra aquela API lá que eu tinha feito, e essa aquisição só será feita quando ele
for carregado no meu navegador -- se liga no `hx-trigger`. E esse `hx-target`
será o elemento que o HTMX vai usar pra colocar o que a API respondeu, no caso,
o `this` vai apontar para o próprio elemento que tá fazendo a aquisição.

Mas assim, isso é o *hello world* do HTMX, dá pra você ir bem mais longe que
isso. É possível usar um *query selector* pra apontar pra outro elemento, como
`#ola-mundo` no *target*, ou até selecionar o elemento mais próximo com
`next .ola-mundo`; ainda dá pra especificar como ele deve inserir a resposta na
página, como dizer se a resposta deve substituir o *target*, se deve ser
inserida depois/antes, ou no final/começo dentro dele, se ele deve ser
substituído pela resposta, e assim vai. Existem dúzias de eventos, opções e
funções que você deve usar e abusar na sua aplicação, e é assim que você
consegue o mesmo nível de reatividade que o React proporciona sem depender
dessa biblioteca! Enfim, leia as documentações pra saber mais, não é tão
complicado entender como ela funciona.

Se você der uma passada de olho nas documentações, não fica difícil de sair de
lá já com algumas ideias de como implementar *features* como o scroll infinito
com o evento `intersects` que dispara quando o elemento aparece na *view
port*[^3], atualização de estado com eventos customizados[^4] ou update de
informações em tempo real[^5].

[^3]: Esse evento pode ser disparado sempre que o usuário *scrollar* a tela o
suficiente pra exibir um elemento vazio que faz essa aquisição, dá pra usar o 
`hx-indicator` pra ter uma animaçãozinha de carregamento e você pode usar
variáveis globais do próprio Javascript pra por na aquisição -- por exemplo, 
"puxe a página 2 do banco", depois de scrollar até o final mais uma vez, "puxe
a página 3 do banco" e assim vai.

[^4]: O usuário pode clicar em um produto na UI pra por no carrinho, então esse
clique pode disparar múltiplos eventos que podem atualizar o estado do card em
que o usuário clicou, mudar o ícone de carrinho vazio na barra de tarefas pra
um ícone de carrinho cheio ou atualizar a lista de carrinhos no menu do
usuário, por exemplo.

[^5]: Isso talvez seja útil em uma aplicação de chat, ou num clone de e-mail,
onde a página precisa ficar de tempos em tempos puxando dados do seu backend
pra manter o usuário a par do que está sendo enviado/recebido.

Sei que pareço um fanático a essa altura, mas fazer o que se a biblioteca é
boa, né? Além disso, entender como ela funciona vai ser importante pra entender
a lógica de templates que usei pro projeto, então presta atenção pra não se
perder.

## Concluindo

Ok, acho que esse post vai ficar longo demais então vou dividir ele em posts
menores em uma série mais fácil de consumir. Ainda quero falar um pouco sobre
CSS, Bootstrap, Tailwind e SASS, depois quero abordar alguns problemas que
passei durante o desenvolvimento e, finalmente, se eu tivesse a paciência pra
fazer esse projeto de novo como eu faria usando uma *stack* mais "séria".

No mais, é isso. Espero que esse post tenha, ao menos, te atualizado um pouco
na área do frontend, saber que o HTMX existe pode ser uma mão na roda,
principalmente pra projetos pequenos que você precisa de uma interface meia
boca e não quer perder muito tempo com AJAX pra puxar ou inserir dados no seu
banco.

É até legal escrever um artigo sobre isso sabendo que eu odiava a ideia do
HTMX antes de experimentar. No próximo post eu vou falar sobre o único
"problema" que torna o HTMX alvo de crítica -- vou falar sobre essa crítica
também -- e como dar uma volta nesse problema com plugins (sim, HTMX tem
suporte a plugins também).

Se tiver alguma dúvida com os exemplos anteriores, não deixe de comentar
abaixo e compartilhe com seus amigos se tu achou esse post relevante. Obrigado
pela leitura! ❤️

<!--TODO: Escrever sobre o servidor responder em HTML-->
<!--TODO: Comentar sobre semântica e tags vazias no código-->
<!--TODO: Escrever um post sobre inline styles/scripts (bootstrap & css)-->
