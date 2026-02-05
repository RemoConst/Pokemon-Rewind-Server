package grpc

import (
	"Pokemon/common"
	"Pokemon/common/database"
	dbUser "Pokemon/common/database/user"
	"Pokemon/proto_go/user"
	"context"
	"errors"
)

func (s *Server) Login(_ context.Context, request *user.LoginRequestMsg) (*user.LoginResponseMsg, error) {
	db := database.InitDatabase()
	defer db.Close()

	db_user, err := dbUser.FindOneById(db, request.Id)

	if err != nil {
		return nil, err
	}

	if db_user.Password != common.Sha512Hex(request.Password+db_user.Salt) {
		return nil, errors.New("wrong Password")
	}

	token, err := common.CreateToken(db_user.Uuid)

	if err != nil {
		return nil, err
	}

	return &user.LoginResponseMsg{
		Token: token,
	}, nil
}

// func (s *Server) Register(_ context.Context, request *user.RegisterRequestMsg) (*pokemon.NilResponseMsg, error) {
// 	db := database.InitDatabase()
// 	defer db.Close()

// 	db_user, err := dbUser.FindOneById(db, request.Id)

// 	if err != nil {
// 		return nil, err
// 	}

// }
