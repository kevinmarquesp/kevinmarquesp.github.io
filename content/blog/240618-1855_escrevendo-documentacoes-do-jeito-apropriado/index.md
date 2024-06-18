---
title: "Escrevendo Documentações do Jeito Apropriado"
date: "2024-06-18T18:55:57-03:00"

draft: false
comments: true
math: false
toc: true

author: "Kevin Marques"
tags: ["markdown", "documentation", "philosophy", "pro_tip", "studying"]
---

Já faz algum tempo que estudei esse assunto a fundo e estou me beneficiando com o que aprendi. Mas ainda acho super válido comentar sobre documentações porque não vejo muita gente falando sobre por ai, parece que não consideram tão importante, assim como o fazem com testes unitários – não é importante até começar a fazer diferença.

Então, cá estou eu pra contribuir com minha colher de chá no assunto. A pesquisa que fiz foi bem superficial, mas ela abrange todos os problemas que tinha quando precisava escrever/ler a documentação de alguma coisa, e imagino que esse conhecimento será útil pra ti também.

## Escrevendo Documentações Efetivas

É importante que os mantenedores do projeto atualizem as documentações com o mesmo zelo que o código é atualizado, esse preconceito de que documentar é perder tempo é tão prejudicial quanto o de fazer testes é perca de tempo – essas atualizações, por exemplo, devem vir no mesmo *pull request* do código fonte, e devem ser revisadas (obviamente).

Pra atingir esse nível de escalabilidade das documentações é preciso torná-las diretas e precisas, o mais curto que poder. Vá removendo o que não é necessário e adicione o que falta, mas faça isso aos poucos e com cuidado; evite longas reuniões só pra atualizar as documentações se estiver trabalhando em equipe, esse processo precisa ser natural.

Uma boa documentação deve ficar pronta em pouco tempo, todos no time **devem** sugerir mudanças caso necessário. Assim como o código fonte, as documentações devem ser escritas pensando num futuro leitor – se o esperado que o objetivo desse leitor seja contribuir, então é bom apontar os arquivos/diretórios principais; uma API deve ter uma descrição do que cada rota deve retornar ou fazer; uma ferramenta deve instruir o usuário a usá-la de forma básica e dar instruções de como avançar; etc.

### Mantenha a Linguagem Neutra

Isso é um conceito que boa parte das organizações adotam puramente por conforto, suas documentações devem ser fáceis de entender e causar o mínimo de distrações pra todos, independente do gênero, etnia ou religião. Então, o mínimo que se espera é se esforçar pra usar uma **linguagem neutra** em tudo o que escreve – como usar mais "você" do que "ele" ou "ela" –, a única exceção é quando você está se referindo à alguém que se identifica pelo pronome certo, e não vale usar nenhum tipo de pontuação como "dele(a)" ou coisa do tipo.

Não só isso, quando usar qualquer tipo de pronome, tente especificar melhor à quem você está se referindo na oração. Por exemplo:
+ Se *você* escrever um texto no campo X, *o texto* não irá mudar.
+ \[…] se *ele* escrever um texto no campo X, *ele* não irá mudar.

O "ele" no começo se refere ao usuário? O do final se refere ao "texto" ou ao "campo"?

O ideal é usar inglês pra evitar esses tipos de erros, mas ainda assim não é desculpa pra não prestar atenção no jeito que se escreve.

Mas e em português? Felizmente, a língua portuguesa têm recursos mais do que suficientes pra atingir esse objetivo sem precisar inventar regras ridículas – \*cof \*cof. O objetivo não é simplesmente só evitar de ofender alguém, e sim manter o conteúdo técnico longe de problemáticas sociais que podem gerar alguma distração no leitor, além de manter o respeito pra todas as pessoas e, claro, com o idioma que você está usando pra escrever.

### Documentação do Código Fonte

O código do projeto precisa estar bem documentado e bem organizado, ele não pode depender de uma documentação separada propriamente dita, ele deve servir de documentação também – o resto é detalhe que facilita mais o pessoal que vai participar da equipe e contribuir com o projeto. Mas acredito que essa ideia possa se extender pra tudo, literalmente.

Mensagens de commits padronizadas e descritivas ajudam a entender o estado atual do projeto e como chegou até aqui, um bom nome de arquivos e estruturação de módulos ajuda a entender o *flow de execução*. E, saindo do mundo do desenvolvimento de software, organizar suas coisas na vida real também diz muito sobre o jeito que você pensa. Diferentes métodos de organização, estudo, separação, ou o que for, podem ser usados pra passar uma mensagem à outra pessoa de forma indireta.

É simplesmente educado entender que você não é a única pessoa no mundo e que alguém vai acabar desfrutando do que você produz – mesmo sendo você de alguns dias ou anos no futuro –, e eu acho super importante pensar nessa pessoa.

#### Comentários e Docstrings

Acho importante primeiro saber que existe comentários que são realmente comentários – normalmente feitos dentro de algum bloco de uma função, numa linha só mesmo – e comentários de documentações – em cima ou em baixo do nome de uma função, classe, variável, etc. usada pra descrever o que ela faz.

Os comentários na linhas não devem ser muito frequentes, eles devem dar detalhes do **porquê** as linhas abaixo foram escritas, o **como** o próprio código deve dizer isso pro desenvolvedor. Isso é fácil até.

Agora os comentários em classes devem descrever como seu código **vai se comportar**, é quase um contrato que você asina com a função/classe, que vai ditar o jeito que você irá mexer no código dela. O foco sempre vai ser nos programadores, então é bom ser descritivo pra não se preocuparem como o *como* essa função foi implementada. Também é importante que as funções tenham testes que cubram a descrição delas, e as classes ou arquivos podem ter listas de exemplos de como usá-las em seus comentários de documentação.

## Markdown, Boas Práticas

Sem entrar em detalhes da história da linguagem, é bom ter em mente que o Markdown foi criado com a única intenção de ser um "HTML melhorado", com uma sintaxe bem mais amigável, e que no final do dia pode ser convertido pra um documento em HTML. Mas esse "melhor" – ao menos pra documentos mais focados em conteúdo textual, como artigos de blogs, *essays* e relatórios – não se trata somente de performance/produtividade durante a escrita, a principal *feature* do Markdown é a sua **legibilidade do código fonte**.

Muitas vezes, os desenvolvedores irão precisar fazer algum tipo de manutenção nas documentações de algum projeto, ou só conferir uma coisa rápido pelo o editor de código. De qualquer forma, não é incomum lidar com o código fonte (não formatado) de um documento em Markdown, portanto, o autor do documento precisa ter isso em mente e tomar algumas medidas práticas pra que o documento fique legível mesmo sem ter sido formatado pra HTML, ou similar.

### Escrevendo Markdown Semântico

De forma geral, a ideia é usar de espaços e alinhamento pra tornar as coisas legíveis. Abaixo vou deixar as convenções que eu costumo seguir quando preciso escrever alguma documentação no Github – não são regras –, cheque os README's [dessa ferramenta](https://github.com/kevinmarquesp/html2pdf_pyscript/blob/main/README.md?plain=1) que fiz pra uma amiga e [desse projeto](https://github.com/kevinmarquesp/go-postr/blob/main/README.md?plain=1) pra ver essa lista sendo usada na prática.

+ **Tente limitar as linhas pra ter, no máximo, 80 caracteres**. Linhas muito compridas são difíceis de ler; a única coisa que incomoda nisso são os links, tente deixar eles na mesma linha do texto e só passe pra próxima se não couber mais nada depois do link.
+ **É bom que parágrafos e títulos sejam separados por uma linha vazia**. Não deixe os títulos grudados no parágrafo, pule uma linha depois do título; imagens devem estar em seu próprio parágrafo e listas podem ser agrupadas por parágrafo também, se fizer sentido.
+ **Evite tabelas ao máximo**. São super irritantes de se lidar, principalmente quando o editor não ajuda. Em quase todo senário dá pra usar hierarquia de listas no lugar de tabelas.
+ **Minimize dependências (imagens e links)**. Um documento bem escrito deve fazer sentido só com o conteúdo textual nele, imagens devem ser um apoio adicional, não uma obrigatoriedade.
+ **Priorize texto puro**. Ou seja, tente escrever em inglês (já que esse idioma não têm palavras com acentos) e não use emojis, esses caracteres estranhos podem causar problemas no editor de alguém de outro país, inglês é meio que o padrão.

E outra – talvez até o mais importante –, **evite HTML em um documento escrito em Markdown**! A única rasão pra você querer usar HTML dentro de um arquivo `.md` é puramente por estilo, e estilo não deve ser uma preocupação ao escrever um documento dessa natureza. Além de ser um desrespeito com a linguagem em si, dificulta bastante a leitura.

Mas entenda, nada disso são regras que devem ser seguidas estritamente, são apenas recomendações. Se alguma dessas regras prejudica a legibilidade, é obrigação sua pôr o peso das decisões na balança e escolher a que é mais vantajosa pra ti. Apenas tenha em mente que todo documento serve pra um propósito diferente.

### Como Organizar as Informações

Algo que é universal pra todo tipo documento é o fato de que ele precisa ser direto ao ponto, não necessariamente curto, mas simples e só com as informações necessárias pra resolver o tipo de problema que esse documento quer resolver. É bom que o título de nível 1 – famoso `<h1>` – tenha um nome similar ao nome do arquivo, seguido de uma breve descrição *TL;DR*[^tldr] e, se conveniente, uma árvore de tópicos (TOC[^toc]) pra facilitar a navegação; daí que vem o conteúdo do documento, começando com um título de nível 2.

[^tldr]: Do inglês *too long, didn't read* (muito longo, não li), um pequeno resumo do documento.
[^toc]: Do inglês *table of contents* (tabela de conteúdos).

E é de boa educação também colocar um tópico no final com o título "*See also*" ou "*References*", pra ter um lugar onde listar as referências de pesquisas e guiar o leitor pra outras fontes de conteúdo caso ele queira se aprofundar.

#### README.md

No caso de um README.md de um projeto de software é bom levar em conta que o README, provavelmente, será o primeiro contato do usuário, ou de um novo membro do time, com o projeto em particular. Então é importante que esse arquivo sirva como um guia inicial e traga as informações mais importantes logo de cara.

O ideal é que ele seja curto mesmo, amigável à leitura dinâmica, com exemplos descritivos de como rodar o projeto ou contribuir. Mas se ficar muito detalhado é comum separar em arquivos menores e mais específicos como um `STYLE_GUIDE.md` pra definir estilos de código e boas práticas ou um `CONTRIBUITING.md` com instruções de como rodar o projeto em ambiente de desenvolvimento.

Eu só trabalhei em projeto pequeno, então um README curtinho na raíz do projeto já serve, mas a ideia tradicional de um arquivo README é ser uma descrição do diretório em que ele está situado, então acredito que seja bom ter um documento desse tipo nos diretórios de módulos, testes, etc., caso seja necessário.

#### Essas Regras não Devem ser a Solução

É importante minimizar as dependencias do documento, como links externos, imagens, diagramas, etc., mas é importante fazer isso com cuidado, em muitos casos é inevitável referenciar algum outro artigo ou site (é a base da internet esses links), ou colocar algum diagrama/imagem pra explicar melhor um conceito; essas decisões devem ser tomadas pensando na legibilidade do texto puro acima de tudo. Portanto, é só saber o momento certo de quebrar essa regra do texto puro, o que pode ser uma coisa frequente, e não tem nada de errado nisso.

## Referências

Todas essas informações eu tirei de um único repositório do Github, o de estilos
e dicas pra documentações de projetos da Google. Segue os documentos individuais
que me ajudaram:
+ [Philosophy](https://github.com/google/styleguide/blob/gh-pages/docguide/philosophy.md)
+ [Markdown style guide](https://github.com/google/styleguide/blob/gh-pages/docguide/style.md)
+ [Documentation Best Practices](https://github.com/google/styleguide/blob/gh-pages/docguide/best_practices.md)
+ [README.md files](https://github.com/google/styleguide/blob/gh-pages/docguide/READMEs.md)

Antes de escrever essse artigo, eu tinha feito um post no TabNews pra adicionar
algumas ideias, os comentários de lá foram super úteis!
+ [Boas Práticas pra Documentos em Markdown](https://www.tabnews.com.br/kht/41bfa0e0-7b88-4085-b9b7-ee3608021a0c)

Se você têm alguma dica a mais, ou correção de algo que escrevi, não deixe de
comtar sobre na sessão de comentários abaixo. Sua contribuição não ajuda somente
a mim, que estou estudando, mas também futuros leitores! ❤️
