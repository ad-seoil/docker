# 이미지를 가져오기 dockerhub
FROM node:20-slim
# WORKDIR 은 cd같은 명령어. 지정 폴더로 이동함. 없으면 생성도 해줌
WORKDIR /app
# 파일을 복사 내 PC경로에서 도커 경로로
# . = 현재 작업 경로
COPY . .
# /bin/sh-c npm install 실행됨
# -> os에 기본적으로 설치되어있는 shell에서 실행하라는 뜻
# 호환성 문제가 생길 수 있으니 비추
RUN npm install 
# 기본적으로 추천하는 방식
RUN ["npm", "install"]
# 어떤 포트로 열지 설정
# 나중에 이미지 적을 때 힌트용(진짜 메모용) 
EXPOSE 8083
# 도커의 마지막 명령어는 CMD로 적음 아니면 ENTRYPOINT
CMD ["node", "server.js"]