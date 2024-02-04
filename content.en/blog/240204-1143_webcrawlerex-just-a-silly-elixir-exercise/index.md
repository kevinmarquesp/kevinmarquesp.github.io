---
title: "WebCrawlerEx, Just A Silly Elixir Exercise"
date: "2024-02-04T11:43:27-03:00"

draft: false
comments: true
math: false

author: "Kevin Marques"
tags: ["programming", "learning", "elixir", "experiment", "first_time", "sql", "sqlite3", "project"]
---

Recently I started to study the Elixir programming language – Actually, I've already played with that language in the past, but a friend of mine[^1] inspired me to create a project like this, and I grabbed the opportunity –, but I think I've learned enough to conclude that Elixir is my favorite programming language of all time. I love the syntax, the functional way to do things, the huge amount of features related to multitasking and its performance on all of that.

[^1]: He is known as [KitsuneSemCalda](https://github.com/KitsuneSemCalda), and I think you should check his articles too on the [Fox in the Tech World](http://foxtechworld.github.io/)

My "silly" project is just a web crawler collection of helper modules, which means that's a program that fetches the body of an HTTP URL and extract all inner URL links inside that response body, saves those URLs in a SQLite database and repeats that same process for each URL that was found on the first acquisition, of course, running that in multiple process to increase performance. Just that. I think that simplicity is good to get used to the Elixir syntax, projects structure, and so on – I think I could do the same project in 35 min in other languages.
### Creating A New Project
Let's start with that, I'll assume that you already know a little bit of the Elixir's lore – also, I don't know too much, I only know that it was created by a Brazilian guy called José Vallm and that's really good handling a ton of process at the same time.

Like Rust and Go, you can run a single `.exs` (this *s* means that's a *script*) file with `iex my_script.exs`, this command will open the `iex` prompt and run that script, so if it has a module inside of it, the `iex` will have access to that module. This is a thing that I see everywhere, looks like every Elixir's project is created to run that shell, maybe it's more than just a shell. When you code in other languages, your goal is to create a module/script that you can execute with a simple command, a `python3 __main__.py`, a `npm run start` or just a compiled binary file that some compiled language has generated.

But I don't want a simple script for that project, I want a well structured project, with dependency management, unit tests and a easy structure to organize my shitty code. And `mix` solves that problem for me. It's a tool that is integrated to the Elixir package when you install the language, and is similar to `npm` in some senses, so, nothing to comment on that. The other stuff that I liked is Elixir's features related, `mix` looks like a wrapper to handle that features. Here's the base structure of a project created with `mix new hello_world` command (it is not a git repository right away, which can be a little annoying sometimes):
```
hello_world/
├── lib/
│   └── hello_world.ex
├── test/
│   ├── hello_world_test.exs
│   └── test_helper.exs
├── .formatter.exs
├── .gitignore
├── mix.exs
└── README.md
```
I have no idea what that `test_helpers.exs` file is, it will be there until I find some use to that. Speaking of tests, I love how tests is just better in Elixir, *plug n play* in the way I like. You just need to create a module that have some functions created with the test notation and run everything with `mix test` – or, if you're using a script created by hand, you'll need to start the test suite with `ExUnit.start()` before creating the module, and after creating your module, you'll need to run everything with `ExUnix.run()`.

Ok, that's enough of structure blah blah blah, let's get into the code.
### Writing My First Module(s)
On my first attempt, I was trying to write everything *quick and dirty*. So, my code became problematic in no time. I'll use this first code to list my mistakes and comment a thing or another about the syntax.

The first thing that I notice on this *speed run* is that I put everything inside a single file, I separated it into different modules, but everything was clustered in a single massive file. Result: It became difficult to locate some parts in the code. Also, I was thinking too much to solve my little puzzle with a procedural mindset – classical solving a Python problem with a C# solution meme, or something like that.

My process of thought was: I need to get the URLs in the body content of an URL address, **then** save it to my database and **then** do that operation again for each result. There is nothing wrong with having this process of thought, but in Elixir it can became very problematic quickly.
### Extracting Inner URLs
Here's my solution for getting the inner URLs from a base URL address:
```elixir
defmodule WebCrawlerEx.HandleHttpRequests do
  def get_inner_links(base_url) do
    {:ok, page_html} = fetch(base_url)  #todo: handle error
    href_values = get_href_values(page_html)  #todo: handle error

    filter_valid_links(href_values)
  end

  defp filter_valid_links(href_values), do:
    Enum.filter(href_values, &valid_http_url?/1)

  defp valid_http_url?(url_str), do:
    ~r/^http(s)?:\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/
    |> Regex.match?(url_str)

  defp get_href_values(page_html) do
    {:ok, parsed_html} = Floki.parse_document(page_html)  #todo: handle error
    a_tags = Floki.find(parsed_html, "body a")

    Enum.map(a_tags, &(Floki.attribute(&1, "href")))
    |> Enum.filter(&(&1 != []))
    |> Enum.map(&hd/1)
    |> Enum.uniq()
  end

  defp fetch(url) do
    headers = [{"User-agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"}]

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{body: page_html}} ->
        {:ok, page_html}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
```
As you can see, this code fetches the inner links by doing each step at a time. The only thing that annoys me a little bit about on Elixir, is that it has no `return` keyword, the final result that the function computes will be the return of your function, no early returns are allowed. This means that, if you want your function to be readable, you'll need to break it into smaller functions – normally, private ones, because it's related to a function that has a complex logic.

This `case ... do ... end` match statement **is just perfect**, it's a feature that I certainly would love if more languages had that – I think JavaScript will implement a similar syntax on the future. Here, I pass a result as a case, where I can specify what I'm expecting and what I want to handle in variable names (like the `page_html` or `reason` variables on the `fetch/1` function), then I can return a custom type based on the match placeholder (or variables, if you will).

Some other comments, I liked how Regex is a built-in feature on the `valid_http_url?/1`[^2] function. Also, I don't know why so many people who are starting with Elixir are so impressed by the pipe operator (`|>`) – this means that the return of the function before that pipe will be the first argument of the function after that operator –, it is really useful and I think more languages should have a similar feature, but that's nothing knew, for at least twenty year, because Bash and PowerShell does that really well too with the `|` operator.

[^2]: If you don't know, that `function_name/some_number` is a notation that represents a function and its arity (how many arguments it accepts), here was talking about the function called `valid_http_url?()` that accepts one argument, that's more cooler than you think. Also, function names that ends with a question mark just means that this functions returns a boolean value, it's a naming convention.
### Database Helper
This entire project I built with a little help from Bing's AI Copilot – no copy and paste, trust me, that's gross – and, for some reason, when I asked for doing a SQLite database connection, the code, libraries and solutions that it gave me weren't working very well, so I searched for some library that has an easy to understand front-end and picked the first one that appeared – now I know I should be using Ecto in some way.
```elixir
defmodule WebCrawlerEx.HandleDatabase do
  def insert_link(db_conn, db_table, link), do:
    Exqlite.Basic.exec(db_conn, "INSERT OR IGNORE INTO #{db_table} (url) VALUES ('#{link}')")

  def get_db_connection(db_file, db_table) do
    {:ok, conn} = Exqlite.Basic.open(db_file)  #todo: handle error

    Exqlite.Basic.exec(conn, "CREATE TABLE IF NOT EXISTS #{db_table} (
      id INTEGER PRIMARY KEY,
      url TEXT UNIQUE
    );")

    conn
  end
end
```
### Main Function
This is really bad practice, do not do anything like that in Elixir, I'm sorry:
```elixir
defmodule WebCrawlerEx do
  @db_file "results.sqlite3"
  @db_table "links_list"
  @max_concurrency System.schedulers_online() * 2
  @timeout :infinity

  def main(argv) do
    WebCrawlerEx.HandleDatabase.get_db_connection(@db_file, @db_table)
    |> run_and_write(argv)
  end

  defp run_and_write(db_conn, user_urls_list) do
    Task.async_stream(user_urls_list, fn user_url ->
      WebCrawlerEx.HandleHttpRequests.get_inner_links(user_url)
      |> execute_for_each_inner_link(db_conn)
    end, max_concurrency: @max_concurrency, timeout: @timeout)
    |> Enum.each(&(&1))
  end

  defp execute_for_each_inner_link([], _db_conn), do:
    IO.puts("Warning!: Cannot handle an empty list, ignoring...")

  defp execute_for_each_inner_link(inner_links, db_conn) do
    Task.async_stream(inner_links, fn inner_link ->
      IO.inspect(inner_link)
      WebCrawlerEx.HandleDatabase.insert_link(db_conn, @db_table, inner_link)
    end, max_concurrency: @max_concurrency, timeout: @timeout)
    |> Enum.each(&(&1))
    
    run_and_write(db_conn, inner_links)
  end
end
```
Here, I try to put everything together and make the `main/1` function do everything for me. That's a bad practice because the user will only have access to the main function, they can't execute the `run_and_write/2` function with a custom database connection. Also, this code just looks awful.

As you can see, the real main function here is the `run_and_write/2` one, because it creates a task that runs in the background to fetch the URLs, and it's a recursive function, which means that this task will create other children tasks. The `execute_for_each_inner_link/2` also does something similar, but does that for each URL that was given to.

I like the way that Elixir uses that `Task.async_stream/4` function, it has a default timeout span that can throw an error, but it can easily fixed setting the `timeout:` setting. In theory, every task should be trying to use 100% of my CPU, but even with setting up the `max_concurrency:` setting it runs smoothly for some reason.
### Final Thoughts
I'm really a newbie at Elixir. But I think that I'm starting to really get used to the language, this syntax is perfect and easy to understand, before creating this project I thought that I would need some Ruby background to understand it well, but I was wrong about that. Error handling is a little confusing with a dynamic typed language, but I can see that it's possible.

This project is compiling, but it doesn't work for a long time, because some URLs can throw a timeout error or other part of my code can't handle binary files, resulting in a crash in the middle of the execution. I'll continue working on this project, but I'll refactor the code and break everything into smaller modules.

I'll post my results and solutions on the next part of this series (yeah, it will be a series), hope you'll enjoy my discoveries. ❤️
#### Some Articles That I Should Read To Proceed On This Project
+ [What is Elixir's IEX and how to utilize it](https://marketsplash.com/tutorials/elixir/elixir-iex/)
+ [What Is Error Handling In Elixir: Strategies And Best Practices](https://marketsplash.com/tutorials/elixir/elixir-error-handling/)
+ [The Many uses of Elixir's Task Module](https://learn-elixir.dev/blogs/uses-of-elixir-task-module)
+ [Demystifying Processes In Elixir](https://blog.appsignal.com/2017/05/18/elixir-alchemy-demystifying-processes-in-elixir.html)
