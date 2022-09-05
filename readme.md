# Elixer Helloworld

This repository contains some tutorial Elixer code. I am just trying to get my feet wet, so do not use any of this code!

I am following this tutorial: <https://www.tutorialspoint.com/elixir/index.htm>

## Installing Elixer

<https://elixir-lang.org/install.html#gnulinux>


    Add Erlang Solutions repository: wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb && sudo dpkg -i erlang-solutions_2.0_all.deb
    Run: sudo apt-get update
    Install the Erlang/OTP platform and all of its applications: sudo apt-get install esl-erlang
    Install Elixir: sudo apt-get install elixir

Running into issues installing on my Kali laptop. idk if it is an issue with traveling/wifi of Kali...

Or just docker it: <https://hub.docker.com/_/elixir/>

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/brandonmcclure/elixer_helloworld/blob/main/readme.md)

## Creating a Cowboy http server via Plug

run `make run_it` to enter a instance of the container so you can run `mix new projectname --sup`. This will create a supervised application in the bound volume.

add my own helloworld.ex module in the `lib` folder. And add `{:plug_cowboy, "~> 2.1"}` to the `defp deps do` in the `mix.exs`

## Creating a Pheonix http server

<https://hexdocs.pm/phoenix/installation.html#phoenix>
