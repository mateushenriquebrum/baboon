# Baboon

**Datomic like database for Elixir**

[Overview] (https://app.diagrams.net/#G1LgdWlDnpRt_GkUryrM5kp5xJTq0rAiyx#%7B%22pageId%22%3A%22CI6LQ-vuCawdnCSOjeR5%22%7D)

## TODO
[] connection to memory
[] transactor in memory
[] live index in memory
[] indexer in momory
[] query using datalog
[] actor connection
[] transactor dump logs on file system
[] indexer make indexes on file system
[] indexer provide cache from file system
[] tcp connection

## Definition
# Connection
It defines the location of a Transactor and Indexer, it can be done locally, clustered by actors or tcp behind actors. Transact, Index and Cache rely on it as it becomes the source of truth for transaction id and current facts on system.

# Transact
It defines the interface between library and Transactor, it accepts the facts and convert it in datoms, storing and indexing it. It also prodives the transaction id to datoms.

# Transactor
Deal with file system and then it is keept behind an actor for failure torelance and scalability reasons.

# Indexer
Act as a background process indexing files from logs, cleaning up logs and removing stale live indexes, it is keept behind an actor for failure and scalability reasons.

# Live Index
Provide in memory latest datoms already indexed in memory, it is cleaned after indexer index related datoms.

# Query
Datalog query

# Cache
It defines the interface between library and Indexer, fetching and caching datoms from media. 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `baboon` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:baboon, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/baboon>.

