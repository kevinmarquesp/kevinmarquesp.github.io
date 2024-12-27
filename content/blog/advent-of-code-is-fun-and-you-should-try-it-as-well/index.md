---
title: "Advent Of Code Is Fun And You Should Try It As Well"
date: "2024-12-27T19:13:34-03:00"

draft: false
comments: true
math: false
toc: true

author: "Kevin Marques"
tags: ["programming", "learning", "elixir", "project", "story"]
---

Okay, I don't want to finish this month without writing something on this blog,
this website of mine is pretty much that, which is lame. I created this blog by
myself for myself, so if I'm not putting the effort to register my researches
and discoveries here, it means that I'm not putting much effort on myself.

Well, but it doesn't necessarily mean that I'm just addicted to games and
series (even though I am) -- Which is worth mentioning, to be honest, because I
noticed that the last two series that I watched (*Elementary* and *Welcome to
NHK*)[^1] reflects a lot about what I'm feeling right now. In the second day of
this month, Youtube remembered me that the *Advent of Code* exists, so I tried
to solve each puzzle more seriously.

[^1]: I could even dedicate an entire article for each of those series;
      Elementary brings the most humane and realistic Sherlock adaptation (and
      also the best Watson; Lucy Liu is beautiful) and Welcome to NHK tells
      a lot about the situation some teenagers of my age are in, including me.
      As you can see, my geek ass really wants to talk about it, but today
      isn't the day. I just needed to write down this feeling and use it as a
      mental note of things that I need to cover on my personal webspace.

And I learned a lot in this process, I would love to share a little bit of this
wisdom that I acquired.


## What And Why

In a nutshell, Advent of Code is a collection of 25 algorithm challenges that
you need to solve to save Christmas (yeah, it has a lore). The answer for each
puzzle is a number, and you should calculate this number based on the puzzle it
self and an input, which is a text file with a lot of data. This input file is
different for every user and every challenge.

Each challenge has 2 parts; the second part uses the same input file as the
first one, but the result should be different. If you succeed, both of the two
parts, you'll get 2 starts, which means you need 50 starts to win. It starts
easy and the difficulty increases for each level.

You can solve the puzzles using any programming language you want. Which is
neat, I see a lot of people who aren't particularly attracted by the competitive
programming part of those challenges that uses *AoC* to learn new programming
languages. And that's a valid point of view, but I think I like another thing.

I really don't care about the competitive part either, so I use it to train my
design muscles to write readable and documented code. And it's pretty convenient
that each puzzle has two parts, because I can see how well I designed the first
part of the puzzle, based on how much I had to change it to solve the second
part.


## My Adventure

I already knew about AoC last year (2023), but I was able to solve only
4 puzzles. This year I wanted to compensate that and put a realistic goal of
getting 25 starts, half of the total, and I made it this time. I didn't want to
get all the 50 stars because I knew I would just burn out, some of the puzzles
just isn't suited for my level of programming **yet**.

When I was solving each puzzle, I got curious about other people's solutions,
because I'd like to know if my solution was not a crime in some country, I don't
know, and that's when I discovered new Discord servers, met new Twitch streamers
and found out the Advent of Code thread on [lainchan.org](https://lainchan.org)
-- they were solving the puzzles using Haskel and Lisp, my beloved Lisp.

It was a lot of fun, and I'm happy to say that my code has the "readable" badge.
I think I should be proud.


### What I Learned

I documented all my solutions in a
[repository](https://github.com/kevinmarquesp/advent-of-code/tree/main) on
Github. The `main` branch stores my 2023 attempt some of my 2024 solutions --
I started with Python (the easiest for this kind of challenge), then I jumped to
C++, then JavaScript and finally stuck with Elixir, my favorite language of
all time.

I used *C++23* for some of the challenges, and I loved it. I mean, it still
smells like an old procedural language, but the `std::ranges` library helped
a lot, and I also liked that C++ now has *pipe operators* like Bash or Elixir.
But nothing beats Elixir, this language was designed to solve this kind of
problem.

Elixir has a really strong standard library and a strong community as well, the
pattern matching syntax is perfect, this month I officially love the functional
pattern -- now every problem to me is an *array-ish* problem. It even was easy to
run Elixir as a standalone script; look, the code below plays all *.mp3*
songs from the music board of lainchan.org using MPV:

```elixir
#!/usr/bin/env elixir

Mix.install([
  {:floki, "~> 0.37.0"},
  {:req, "~> 0.5.5"}
])

songs =
  Req.get!("https://lainchan.org/music/")
  |> Map.get(:body)
  |> Floki.parse()
  |> Floki.find("a")
  |> Floki.attribute("href")
  |> Enum.filter(&String.contains?(&1, "/music/src"))
  |> Enum.filter(&String.contains?(&1, ".mp3"))
  |> Enum.uniq()
  |> Enum.map(&("https://lainchan.org" <> &1))

songs
|> length()
|> dbg()

System.cmd(
    "alacritty",
    ["-e", "mpv", "--no-video", "--shuffle", "--log-file=uomagaa.log" | songs]
)
```

I wish Python had a simple dependency manager for those kinds of standalone
scripts, that would help me a lot.

But still about the repository, the `better` branch stores my last solutions,
those were all written in Elixir, and, this time, I didn't use a simple script
file to solve, I tried to build an entire Mix project with tests included for
each day. Which paid off, but I still need to improve my unit testing workflow.

And speaking of improving, I discovered that my weaknesses was code optimization
and, the most critical one, linear algebra. Besides that, I also figured that my
strengths are recursion -- the other languages annoyed me because of that, they
don't have tail recursion like Elixir -- and arrays -- like, spamming
`.split()`, `.map()`, `.filter()`, `.reduce()`, etc. in JavaScript; and Both of
those of my strengths was the influence of Elixir, because That's basically how
you code everything in Elixir.


### The Real AoC Was The Friends We Made Along The Way

Yeah, I know that's sounds cliché, but I can't help it, it was a lot of fun
interacting with those passionate people. Like, we're both selfish nerds who
really love the art of creating and hacking stuff, it's quite poetical how this
selfish curiosity in highly specific interests can bring us together. Just
saying.


## Happy New Year!

That's it for today, I didn't do any research for that. As I said in the note,
I want to put more effort into myself to post more today. This adventure of
mine, mainly in lainchan.org -- I love this place, as you can see --, inspired
me to abandon an old project idea and start it again with a clearer goal in
mind. I'll write about it later; I just need to sketch some stuff and see what I
really want, and I plan to create a simple social media focused on group
discussion.

Besides that, I also want to learn more about Lisp and document my backup
strategy, about my Arch Linux setup, etc. I had a lot in mind, I need to stop
wasting these thoughts.

Happy new year! And thanks for your attention.
