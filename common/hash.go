package common

import (
	"crypto/sha256"
	"crypto/sha512"
	"fmt"
)

func Sha256Hex(input string) string {
	hash := sha256.Sum256([]byte(input)) // SHA-512 해시 계산
	return fmt.Sprintf("%x", hash)       // 16진수 문자열로 변환 후 반환
}

func Sha512Hex(input string) string {
	hash := sha512.Sum512([]byte(input)) // SHA-512 해시 계산
	return fmt.Sprintf("%x", hash)       // 16진수 문자열로 변환 후 반환
}
