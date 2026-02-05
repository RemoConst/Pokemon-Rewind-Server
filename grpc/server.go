package grpc

import pokemon "Pokemon/proto_go"

type Server struct {
	pokemon.UnimplementedPokemonServer
}
