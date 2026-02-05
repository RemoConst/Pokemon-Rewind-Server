package user

import (
	"Pokemon/common"
	"Pokemon/common/database/server"
	"database/sql"
	"errors"
	"time"

	"github.com/google/uuid"
)

type User struct {
	Uuid      string `json:"uuid"`
	Nickname  string `json:"nickname"`
	Id        string `json:"id"`
	Password  string
	Salt      string
	CreatedAt int64      `json:"created_at"`
	UpdatedAt int64      `json:"updated_at"`
	DeletedAt int64      `json:"deleted_at"`
	X         int64      `json:"X"`
	Y         int64      `json:"Y"`
	Gender    int32      `json:"gender"`
	Map       server.Map `json:"map"`
	Direction int32      `json:"direction"`
}

func FindOneByUuid(db *sql.DB, uuid string) (*User, error) {
	query := `
		SELECT 
			u.user_uuid,
			u.user_nickname,
			u.user_id,
			u.user_password,
			u.user_salt,
			EXTRACT(EPOCH FROM u.created_at)::bigint,
			COALESCE(EXTRACT(EPOCH FROM u.updated_at)::bigint, 0),
			COALESCE(EXTRACT(EPOCH FROM u.deleted_at)::bigint, 0),
			COALESCE(u.x, 0),
			COALESCE(u.y, 0),
			COALESCE(u.gender, 0),
			COALESCE(u.direction, 0),
			COALESCE(m.map_uuid, ''),
			COALESCE(l.language_uuid, ''),
			COALESCE(l.kor, ''),
			COALESCE(l.en, ''),
			COALESCE(l.cn, ''),
			COALESCE(l.jp, '')
		FROM tb_user u
		LEFT JOIN tb_map m ON u.map_uuid = m.map_uuid
		LEFT JOIN tb_language l ON m.map_name = l.language_uuid
		WHERE u.user_uuid = $1 AND u.deleted_at IS NULL
	`

	row := db.QueryRow(query, uuid)

	user := &User{}
	var mapUuid, langUuid, kor, en, cn, jp string

	err := row.Scan(
		&user.Uuid,
		&user.Nickname,
		&user.Id,
		&user.Password,
		&user.Salt,
		&user.CreatedAt,
		&user.UpdatedAt,
		&user.DeletedAt,
		&user.X,
		&user.Y,
		&user.Gender,
		&user.Direction,
		&mapUuid,
		&langUuid,
		&kor,
		&en,
		&cn,
		&jp,
	)

	if err != nil {
		if err == sql.ErrNoRows {
			return nil, errors.New("user not found")
		}
		return nil, err
	}

	// Map 정보 설정
	if mapUuid != "" {
		user.Map = server.Map{
			Uuid: mapUuid,
			Name: server.Language{
				Uuid: langUuid,
				Kor:  kor,
				En:   en,
				Cn:   cn,
				Jp:   jp,
			},
		}
	}

	return user, nil
}

func FindOneById(db *sql.DB, id string) (*User, error) {
	query := `
		SELECT 
			u.user_uuid,
			u.user_nickname,
			u.user_id,
			u.user_password,
			u.user_salt,
			EXTRACT(EPOCH FROM u.created_at)::bigint,
			COALESCE(EXTRACT(EPOCH FROM u.updated_at)::bigint, 0),
			COALESCE(EXTRACT(EPOCH FROM u.deleted_at)::bigint, 0),
			COALESCE(u.x, 0),
			COALESCE(u.y, 0),
			COALESCE(u.gender, 0),
			COALESCE(u.direction, 0),
			COALESCE(m.map_uuid, ''),
			COALESCE(l.language_uuid, ''),
			COALESCE(l.kor, ''),
			COALESCE(l.en, ''),
			COALESCE(l.cn, ''),
			COALESCE(l.jp, '')
		FROM tb_user u
		LEFT JOIN tb_map m ON u.map_uuid = m.map_uuid
		LEFT JOIN tb_language l ON m.map_name = l.language_uuid
		WHERE u.user_id = $1 AND u.deleted_at IS NULL
	`

	row := db.QueryRow(query, id)

	user := &User{}
	var mapUuid, langUuid, kor, en, cn, jp string

	err := row.Scan(
		&user.Uuid,
		&user.Nickname,
		&user.Id,
		&user.Password,
		&user.Salt,
		&user.CreatedAt,
		&user.UpdatedAt,
		&user.DeletedAt,
		&user.X,
		&user.Y,
		&user.Gender,
		&user.Direction,
		&mapUuid,
		&langUuid,
		&kor,
		&en,
		&cn,
		&jp,
	)

	if err != nil {
		if err == sql.ErrNoRows {
			return nil, errors.New("user not found")
		}
		return nil, err
	}

	// Map 정보 설정
	if mapUuid != "" {
		user.Map = server.Map{
			Uuid: mapUuid,
			Name: server.Language{
				Uuid: langUuid,
				Kor:  kor,
				En:   en,
				Cn:   cn,
				Jp:   jp,
			},
		}
	}

	return user, nil
}

// InsertWithNullableMap Map이 없을 수도 있는 경우
func Insert(db *sql.DB, user *User) error {
	user.Uuid = uuid.New().String()
	user.CreatedAt = time.Now().Unix()

	query := `
		INSERT INTO tb_user (
			user_uuid,
			user_nickname,
			user_id,
			user_password,
			user_salt,
			created_at,
			x,
			y,
			gender,
			map_uuid,
			direction
		) VALUES (
			$1, $2, $3, $4, $5,
			to_timestamp($6),
			$7, $8, $9,
			NULLIF($10, ''),
			$11
		)
	`

	var mapUuid string
	if user.Map.Uuid != "" {
		mapUuid = user.Map.Uuid
	}

	_, err := db.Exec(
		query,
		user.Uuid,
		user.Nickname,
		user.Id,
		common.Sha512Hex(user.Password+user.Salt),
		user.Salt,
		user.CreatedAt,
		user.X,
		user.Y,
		user.Gender,
		mapUuid,
		user.Direction,
	)

	if err != nil {
		return err
	}

	return nil
}
