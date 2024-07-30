---
title: "Explicando O Pattern De Repositórios/Serviços"
date: "2024-07-29T21:17:15-03:00"

draft: false
comments: true
math: false
toc: true

author: "Kevin Marques"
tags: ["programming", "learning", "design_pattern", "design", "golang", "typescript", "example", "code_example"]
---

Nesse tempo que fique fora, estive praticando minhas *skills* de desenvolvedor em algumas aplicações web *full stack* mais sérias, uma das principais é o meu [Go Postr](https://github.com/kevinmarquesp/go-postr). Tal projeto que não foi criado, exatamente, com o intuito de finalizar e tornar público, é apenas um repositório onde escrevo e rescrevo coisas repetidamente, adicionando e testando ideias novas, a medida que me dá na telha; simplesmente.

E é nessa brincadeira que me deparei com alguns problemas clássicos do desenvolvimento web (e desenvolvimento em geral): uma parada quebra, e eu não sei onde foi; daí invento de mudar de banco, e tenho q reescrever o código todo de novo, ou penso em usar uma estratégia diferente pra regra de negócio e acabo precisando mudar o *schema* do banco.

Enfim, nesse artigo, tentarei explicar um pouco sobre a importância de escrever testes e porque você, provavelmente, não gosta de escrevê-los, daí abordarei a solução que mais funciona pra mim, mesmo em projetos pessoais e pequenos.

## Testes? Mas Isso É Perda De Tempo

Esse é o argumento mais velho dos *haters* de testes. Você não consegue escrever testes pra uma coisa sequer existe, então TDD não vale a pena, e depois que o código foi escrito você não quer ficar quebrando a cabeça em **como** testar componentes do código sem precisar subir uma instância do banco de dados junto – clássico "não temos tempo pra escrever testes pros *bugs* porque estamos muito ocupados resolvendo eles", apesar desses bugs surgirem pela falta de testes. Então, qual é a solução?

Já considerou que você simplesmente não sabe programar direito? Considere o seguinte, e péssimo, exemplo[^codigo]:

[^codigo]: Um pequeno adendo apenas. Nenhum *snippet* de código desse arquivo é feito pra ser usado em uma aplicação real, é apenas uma pequena referência pra melhorar a explicação. No entanto, não deixe de me avisar caso algum erro de sintaxe ou de lógica muito óbvio surgir.

```typescript
import { conn } from "@/database.ts";

export default async function createNewAppointment(req: Request,
                                                   res: Response) {
  const props = z.object({
    name: z.string().min(1),
    guests: z.number().min(1).max(4),
    date: z.time(),
  }).parse(req.body);

  if (props.date() < new Date()) {
    throw new Error("Essa data não é válida!");
  }

  const clientNames = conn.query(
    "SELECT name FROM Clients WHERE name = ?1", props.name);

  if (clientNames.contains([props.name])) {
    const insertionResult = conn.query(
      "INSERT INTO Appointments (name, guests, date) VALUES (?1, ?2, ?3)",
      props.name, props.guests, props.date);

    res.write(insertionResult);
    
  } else {
    throw new Error("Esse client não está registrado.");
  }
}
```

Acho que dá pra perceber o que esse código faz, mas vou explicá-lo de qualquer maneira: Essa função é um *controller* de um *endpoint* de alguma API, digamos `POST /appointment`, e ela checa se os dados enviados são válidos, checa se a data não é anterior a atual, checa se o usuário já foi registrado em algum momento anterior e, finalmente, insere essas informações no banco, daí ele só devolve os dados inseridos pro cliente não precisar confiar cegamente nessa operação de inserção.

Apesar de funcionar (em teoria, ao menos) esse controller simplesmente não é testável. Pode se tornar um problema se algum dia no futuro descobrirmos que há um bug escondido no meio desse emaranhado de código. Não adianta nem tentar, se conseguir, vai acabar com testes super complexos e difíceis de ler – sem falar que os testes dependeriam de uma conexão com o banco, o que é um problema super chato de se resolver. A única solução é a mais óbvia, refatorar!

Dependendo da linguagem e do *framework*, testar um *controller* pode ser uma tarefa meio complicada, visto que tu tem que dar um jeito de mandar um `req` e `res` de mentirinha (o termo certo pra isso é *mock*, aliás). Então, vamos tentar não testar o controller em si, já que ele não faz nada mesmo, só processa os dados, registra e devolve pro cliente – consegue entender aonde eu quero chegar só com essa frase?

E se a parte do processamento, que é a única parte da aplicação que importa de fato, ficar em uma função separada?

```typescript
import { conn } from "@/database.ts";

function validatePropperties(body: unknown) {
  const props = z.object({
    name: z.string().min(1),
    guests: z.number().min(1).max(4),
    date: z.time(),
  }).parse(body);

  if (props.date() < new Date()) {
    throw new Error("Essa data não é válida!");
  }
}

export default async function createNewAppointment(req: Request,
                                                   res: Response) {
  const props = validatePropperties(req.body);

  const clientNames = conn.query(
    "SELECT name FROM Clients WHERE name = ?1", props.name);

  if (clientNames.contains([props.name])) {
    const insertionResult = conn.query(
      "INSERT INTO Appointments (name, guests, date) VALUES (?1, ?2, ?3)",
      props.name, props.guests, props.date);

    res.write(insertionResult);
    
  } else {
    throw new Error("Esse client não está registrado.");
  }
}
```

E pronto, agora o *controller* está livre de toda aquela carga. Separamos a lógica principal, que eu posso chamar de **regra de negócio**, da aplicação em uma função separada, que eu posso chamar de **unidade**, e agora eu posso testar essa regra de negócio com vários casos que os usuários podem dar – E se o `body` não for um JSON válido? E se a data for de um futuro extremamente distante? O que acontece se o número de convidados for maior/menor que o limite? Etc.

Daí, se você for um maniaco, você pode fazer o mesmo pra lógica que conversa com o banco de dados, mas ai eu acho que já é exagero, pessoalmente. Não problema meu saber se a biblioteca funciona ou não, os desenvolvedores que fizeram a biblioteca precisam garantir isso pra mim com os próprios testes deles.

### Nenhum Código É Eterno

Agora eu quero que você imagine que eu apliquei esses conselhos pra uma aplicação web maior e mais complexa, segui escrevendo tudo desse jeitinho. Todos os meus controllers só pedem pra outras funções tratarem os dados que recebem e devolve o resultado disso.

Ai eu te pergunto: E se eu decidir mudar, drasticamente, o *schema* do banco? E se eu quiser só mudar o nome das tabelas? Ou pior, e seu eu quiser mudar as regras de negócios? Digo, seria até mais fácil, já que está em funções separadas agora, mas aí todos os testes iriam quebrar e a dor de cabeça inicial de não ter tempo pra escrever novos testes se repetem. Como resolvo isso? Como você resolveria isso?

E é agora que entra a parte mais complicada do artigo…

## Separado O Código Em Camadas

Enquanto eu estava pedindo por opiniões num servidor do Discord sobre Go – estava perguntando se era normal a variável de conexão com o banco (o `conn`, nos exemplos anteriores) deveria ser global –, um cara super especial que acabei esquecendo de anotar o *nick* me enviou um blog chamado [Go Beyond](https://www.gobeyond.dev/) e mencionou sobre um projeto [WTF Dial](https://www.gobeyond.dev/wtf-dial/). Naturalmente, fui dar uma olhada e várias chavinhas na minha mente começaram a fazer click.

Enfim, acho que o artigo que mais me marcou foi o [Real-World SQL in Go: Part I](https://www.gobeyond.dev/real-world-sql-part-one/), mas dei uma pesquisada mais sobre esse *pattern* de **serviços** e **repositórios** e a minha conclusão é que é meio complicado mesmo porque a terminologia muda dependendo do contexto – tentarei não usar um vocabulario muito confuso aqui. Já vi vários vídeos de gente usando esse pattern em algum tutorial, mas nunca entendi direito o motivo deles organizarem o código dessa forma. Agora vou tentar explicar pra você também não ficar muito confuso.

A ideia principal é separar o código em conjuntos de objetos, e não se preocupe se você tem medo de *OOP*, esses objetos são apenas pra agrupar funções. Daí eu posso ter um grupo com as regras de negócio e outro grupo que só conversa com o banco. Antes que fique muito complicado de explicar, vou começar logo com um exemplo mais prático.

Vou criar uma **interface** que vai dizer quais funções um grupo pode ter. Elas não guardam nenhuma lógica em si, apenas dizem o que esse grupo vai fazer – tente entender isso como um contrato de comportamento.

```typescript
// Arquivo: src/repositories/index.ts

export interface AppoitmentRepository {
  registerNewClient(name: string, email: string, address: string)
  findClientByName(name: string)
  registerNewAppointment(clientName: string, guests: number, date: Date)
}
```

Vou fazer a mesma coisa pras regras de negócio, que vou chamar de **serviços** a partir de agora. Criar uma interface que vai ditar o que um serviço pra agendamentos deve fazer. Mas eu preciso lembrar que aqui eu também preciso interagir com o banco de certa forma – pra verificar se o nome do cliente já foi registrado, por exemplo:

```typescript
// Arquivo: src/services/index.ts

import { AppointmentRepo } from "src/repositories/index.ts";

export interface AppointmentService {
  appointmentRepo: AppointmentRepo

  createNewAppointment(clientName: string, guests: number, date: Date);
  cancelAppointment(appointmentId: string)
  updateAppointmentDate(appointmentId: string, newDate: Date)
}
```

Tá, mas e como usa esses "contratos", já que só nome de função não faz nada funcionar de fato? E, bem, eu não quero ter que escrever um pedaço de uma aplicação inteira só pra isso, mas vou tentar mostrar as implicações dessa estratégia.

Eu posso criar um objeto que **implementa** a interface de `AppoitmentRepository` (o que significa criar um objeto com o mesmo nome das funções que essa interface pede) e fazer a lógica interna dessas funções se comunicar com um banco em SQLite3, ou criar um outro objeto que usa essa mesma interface mas que se comunica com um banco PostgreSQL. Ou ainda! Eu posso criar um objeto de mentirinha e usar esse objeto pra testar os **serviços** da minha aplicação.

```typescript
// Arquivo: src/repositories/index.ts

export interface AppoitmentRepo {
 // [...]
}

export class SqliteAppointmentRepo implements AppointmentRepo {
  registerNewClient(name: string, email: string, address: string) {
    // [...]
  }
  findClientByName(name: string) {
    // [...]
  }
  registerNewAppointment(clientName: string, guests: number, date: Date) {
    // [...]
  }
}

export class PostgresAppointmentRepo implements AppointmentRepo {
  // [...]
}

export class MockAppointmentRepo implements AppointmentRepo {
  // [...]
}
```

E o mesmo se repete pros controllers, eu posso criar um conjunto de serviços e ir aplicando na minha aplicação a medida que os *beta testers* vão aprovando, sem correr o risco de quebrar o resto. Só que, mais uma vez, preciso lembrar de uma coisinha: Os meus objetos precisam listar as dependências no `constructor()`.

```typescript
// Arquivo: src/services/index.ts

import { AppointmentRepo } from "src/repositories/index.ts";

export interface AppointmentService {
  // [...]
}

export class MainAppointmentService implements AppointmentService {
  constructor(appointmentRepo: AppointmentRepo) {
    this.appointmentRepo = appointmentRepo;
  }

  // [...]
}

export class UpdatedAppointmentService implements AppointmentService {
  // [...]
}
```

E como fica o *controller*?

```typescript
import { PostgresAppointmentRepo } from "src/repositories/index.ts";
import { MainAppointmentService } from "src/services/index.ts";
import { parseJSONRequestBody } from "src/utils/index.ts"

export default async function createNewAppointment(req: Request,
                                                   res: Response) {
  const appointmentRepo = new PostgresAppointmentRepo();
  const appointmentService = new MainAppointmentService(appointmentRepo);

  const props = parseJSONRquestBody(req.body);

  appointmentService.createNewAppointment(props.name, props.guests, props.date);
}
```

*Simple as that*. Agora dá pra entender que se você quiser trocar o PostgreSQL pra SQLite3 é só editar a sétima linha e tudo deve funcionar, já que o `MainAppointmentService` não sabe que classe está sendo **injetada** nele, ele só sabe que tem as funções de um `AppointmentRepo`, e isso já é o suficiente pra ele.

Pra fazer os testes das regras de negócio, os **serviços** agora, também fica mais fácil. Basta passar um banco de dados de mentirinha, desde que também implemente as funções que o repositório dependente do serviço em questão utiliza.

No caso de Go, dá pra ir até mais longe e criar uma terceira camada pros *controllers*, aí eles dependeriam de uma lista de serviços pra funcionar. Aumenta um pouco a complexidade do projeto mas acho legal poder ter só uma lista de serviços, repositórios e controllers que minha aplicação usa. Daí é só questão de trocar o repositório novo pelo antigo caso esteja dando algum problema – o mesmo se repete pras outras camadas.

### TL;DR

Minha maior dica pra escrever um código testável e escalável ao mesmo tempo é separar o código em, ao menos, dois grandes grupos.

+ **Repositórios**: Onde a sua aplicação só vai se comunicar com o banco, sem nenhuma, ou pouca, lógica extra pra essa interação.
  + Imagina um `UserRepo` que pode deixar você criar, editar e deletar um usuário no banco. Daí você pode crivar várias classes que implementam essas funções como `SqliteUserRepo` ou `PostgresUserRepo`, por exemplo.
+ **Serviços**: Onde ficará a lógica principal da sua aplicação. Ela não deve interagir com o banco diretamente, ela precisa que você passe uma dependência (um objeto) pra ela realizar essas ações.
  + Imagina um `AuthService`, essa classe poderia depender de um `UserRepo` pra registrar um novo usuário no banco – independente se isso é um `SqliteUserRepo` ou um `PostgresUserRepo`, o `AuthService` deve ser agnóstico à isso.

Tente entender esses dois como duas camadas desacopladas entre si da sua aplicação, te permitindo trocar de serviço/repositório apenas editando uma linha, igual trocar uma peça de lego 2x2 azul por uma outra vermelha que também é 2x2.
