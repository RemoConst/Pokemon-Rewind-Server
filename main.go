package main

import (
	"Pokemon/common"
	"Pokemon/grpc"
	pokemon "Pokemon/proto_go"
	"net"

	grpcs "google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

func main() {
	config := common.GetConfig()
	lis, err := net.Listen("tcp", ":"+config.Port)

	if err != nil {
		panic(err)
	}

	srv := grpcs.NewServer()

	pokemon.RegisterPokemonServer(srv, &grpc.Server{})
	reflection.Register(srv)

	if err := srv.Serve(lis); err != nil {
		panic(err)
	}
}
