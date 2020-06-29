# Miner

This is a quick and dirty implementation. There's some hardcoded choices in there until I go back and update it or someone makes a PR.

```
# build container image of xmrig (mining software)
docker build -t miner .

# run simple wow miner
docker run --rm -d --name miner miner <your wow address>

# run big monero miner
docker run --rm -d --name miner miner <your xmr address> xmr 8
```

See [start_mining](./start_mining) for details of inputs.
