# 개발 환경용 Docker 이미지  
# 1. Build Image
# golang의 1.13 버전을 베이스 이미지로 작성하고 builder라는 별명을 붙인다.  
FROM golang:1.13 AS builder

# Install dependencies
# 로컬에 있는 소스코드를 컨테이너 안으로 복사, 작업대상 디렉토리로 설정
WORKDIR /go/src/github.com/asashiho/dockertext-greet
RUN go get -d -v github.com/urfave/cli

# Build modules
# greet라는 이름의 실행 가능 바이너리 파일을 작성 
COPY main.go .
RUN GOOS=linux go build -a -o greet .

# ------------------------------
# 제품 환경용 Docker 이미지
# 2. Production Image
# busybox를 베이스 이미지로 사용 
# (busybox는 기본적인 linux 명령어들을 하나의 파일로 모아놓은 것, 최소한의 linux shell 환경 제공하는 경우 이용)
FROM busybox  
WORKDIR /opt/greet/bin

# Deploy modules
# 개발환경에서 이미지로 빌드한 greet라는 실행 가능 바이너리 파일을 제품 환경용 Docker에 복사  
COPY --from=builder /go/src/github.com/asashiho/dockertext-greet/ .
# 복사한 실행 가능 바이너리 파일을 실행하는 명령을 적음
ENTRYPOINT ["./greet"]