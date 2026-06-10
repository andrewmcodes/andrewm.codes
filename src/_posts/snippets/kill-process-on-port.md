---
title: Kill Process Running on a Specific Port
description: "I often have to kill processes that weren't stopped correctly on different ports and can never remember the command."
tags:
  - unix
date: 2023-01-01 20:23:33.000000000 -07:00
last_modified_at: 2023-01-01 20:23:33.000000000 -07:00
---

I often have to kill processes that weren't stopped correctly on different ports and can never remember the command.

## Snippet

```sh
kill -9 $(lsof -ti tcp:4000)
```

## Usage

1. Replace `4000` in the script above with the port you want to kill the process on.
2. Run the script in your terminal.

## Extending

We can extract this into a function to make it easier to use.

```sh
terminate() {
  local port=$1
  local pid=$(lsof -ti tcp:$port)
  if [ -n "$pid" ]; then
    kill $pid
    echo "Killed process $pid on port $port"
  else
    echo "No process found on port $port"
  fi
}
```

Then we can use it like this:

```sh
terminate 4000
```
