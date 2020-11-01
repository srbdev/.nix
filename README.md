# .nix

Dotfiles and setup for my *nix systems


### tmux

- tpm: https://github.com/tmux-plugins/tpm
- Nord tmux: https://github.com/arcticicestudio/nord-tmux

### ALE Python packages

```zsh
% pip install pylint
% pip install bandit
% pip install flake8
```

### ALE JavaScript packages

```zsh
% npm install -g jshint
% npm install -g prettier
```

### ALE Elixir package

Include `credo` in project: [https://github.com/rrrene/credo](https://github.com/rrrene/credo)

### ALE JSON package

Install `jq`

### JupyterLab

```zsh
% pip install jupyterlab
% python -m jupyter lab --port 8888 --no-browser --ip=127.0.0.1 --NotebookApp.token='supersafetoken'
```

### Docker

- MySQL:
```zsh
% docker run --name mysql -e MYSQL_ROOT_PASSWORD=supersafepassword -p 127.0.0.1:3306:3306 -d mysql
```

- postgres:
```zsh
% docker run --name postgres -e POSTGRES_PASSWORD=supersafepassword -p 127.0.0.1:5432:5432 -d postgres:alpine
```

- ElasticSearch:
```zsh
% docker run --name elasticsearch_246 -p 127.0.0.1:9200:9200 -p 127.0.0.1:9300:9300 -e "discovery.type=single-node" elasticsearch:2.4.6-alpine
% docker run --name elasticsearch_614 -p 127.0.0.1:9200:9200 -p 127.0.0.1:9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:6.1.4
```

- RabbitMQ:
```zsh
% docker run -d --hostname rabbitmq --name rabbitmq -p 15672:15672 -p 5672:5672 rabbitmq:3-management-alpine
% docker run -d --hostname rabbitmq --name rabbitmq -p 15672:15672 -p 5672:5672 -e RABBITMQ_DEFAULT_USER=user -e RABBITMQ_DEFAULT_PASS=supersafepassword rabbitmq:3-management-alpine

```

### Visual Studio Code

List of plugins:
- C/C++
- CMake Tools
- Nord
- Python
- Remote - SSH
- Remote - SSH: Editing Configuration Files
- Vim

Also see the user's settings file: `visual_studio_code/settings.json`.
