terminal 에서 npm init -y 를 입력해 package.json을 생성  
package.json은 라이브러리 기록용 파일  
= 어떤게 설치되어 있는지

termical 에서 npm install express 를 입력하면 라이브러리 설치  
= express 는 서버는 쉽게 할 수 있게 해주는 라이브러리


```
npm install -g nodemon
```
= devtool같은 변경사항을 바로바로 적용해주는 친구

이후 서버구동을 ```node server.js```가 아닌
```nodemon server.js```로 구동하면 됨

(참고) 실제 운영시엔 이상한 버그로 인해서 멈추는 경우가 있어, pm2로 구동하는 경우가 많음

# Dockerfile
도커를 실행하기 위한 파일  
+ 어떤 OS쓸건지  
+ 어떤 프로그램 설치할지
+ 어떤 터미널 명령어 실행할지
+ etc...   

다 적어둘 수 있음  
작성하고 dockerbuild 명령어 실행하면 내 image 생성 끝 

<br><br>

# FROM
제일 먼저 어떤 OS환경에서 내 프로그램을 실행할지부터 정해야함   
-> FROM 으로 정함  
그래서 Dockerfile은 항상 FROM 부터 시작함  
FROM 뒤에 어떤 OS를 설치해서 시작할 건지 정해야하는데 보통 Docker hub에서 찾아옴  
    ex) 윈도우 설치하고 싶으면 windows 검색해서 기재,
   리눅스 os는 (ubuntu, devian, redhat, alpine)  

   보통은 리눅스가 서버비가 덜 들기 때문에 리눅스를 사용  

검색을 하면 어떠한 버전들이 있다고 뜨는데
```
FROM ubuntu:25.04
``` 
-> ubuntu 25.04버전 설치
```
FROM node:22-alpine
```
-> Node.js 22 버전 + alpine 리눅스 os 설치  
\+ slim 은 devian 리눅스에서 필요없는 거 지운거고 alpine은 용량이 가장 작은 리눅스라 이런 게 보통 선호됨  
\+ 바이너리로 컴파일한 파일만 돌리면 되는 경우엔 os설치가 딱히 필요없을 수 있는데 그럴 땐 빈 도화지에서 시작하라고  
```
FROM scratch
``` 
같은걸 쓰기도 함

# RUN
실행하라는 명령어

```
RUN npm install express
```
RUN은 여러번 써도 된다.   
근데 이러면 설치할 라이브러리가 100개 있으면 100줄 써야하고 또 최신 버전 라이브러리를 설치해주기 떄문에 귀찮아 짐  

-> 내가 쓰던 package.json 파일을 먼저 똑같이 복사해오고 그 다음에 npm install만 입력하면

   package.json에 기록되어 있는 라이브러리를 그대로 설치해주는 기능이 있음  

-> 코드 100줄 안써도 됨, 사용한 버전으로 알아서 다운해줌  

# COPY
내 pc에 있던 파일을 이미지로 복사

```
COPY 내pc파일경로 이미지내부파일경로
```
왼쪽에는 내 PC폴더 경로, 오른쪽은 이미지 어디로 옮길건지

```
COPY . .
```
마침표는 현재 경로라는 뜻
-> Dockfile 현재경로 옆에 있던 모든 파일과 폴더들을 가상컴퓨터 현재경로로 복사

근데 이러면 node_modules같은 라이브러리 소스코드도 복사해줄텐데 굳이 복사할 필요가 없는 것이니까  

복사하기 싫은 파일이 있으면 .dockerignore 파일 만들어서 파일이나 폴더경로 기재해두면 됨 (.gitignore같은)

# WORKDIR
폴더 이동
이미지 기본 경로에 옮기면 파일이 많을 때 더러울 수 있기 때문에

```
WORKDIR /app
```
현재 작업경로를 /app 폴더로 바꿔주고 /app폴더가 없으면 하나 만들어줌
터미널 명령어 cd와 비슷한 역할  


# CMD
보통 도커의 마지막 명령어는 RUN이 아닌 CMD를 씀
CMD 대신에 ENTRYPOINT라고 적을 수도 있음  

+ ## CMD vs ENTRYPOINT
내 이미지를 실행할 때 터미널에서 실행하고 싶으면
```
docker run 이미지명
```
입력하면 되는 데 근데 뒤에 몰래 명령어를 추가할 수 있음

```
docker run 이미지면 node server1.js
```
그러면 Dockerfile 내의 CMD 부분이  
node server1.js 로 **덮어쓰기** 가 되어서 실행됨  
그래서 매번 다른 명령어로 실행하고 싶으면 CMD 사용하면 덮어쓰기 편리  

CMD 말고 ENTRYPOINT를 쓰면 기능은 비슷하지만 덮어쓰기가 살짝 어려워짐  
이상한 멸영어를 써야 덮어쓰기가 되기 때문에  
어떻게 보면 ENTRYPOINT를 쓰면 좀 더 안정적이라고 보면 됨  

-> 변경원하지 않는 부분은 ENTRYPOINT에 넣고  
-> 변경원하는 부분은 CMD 넣고 그래도 됨  

```
ENTRYPOINT ["node"]
CMD ["server.js"]
```
이런 식으로 적어두면  
앞으로 이미지 실행할 때 **docker run 이미지명 server1.js** 이렇게 실행하면   
**node server1.js** 라는 커맨드가 마지막에 실행됨  
그래서 docker run 할 때마다 일부 명령어만 가변적으로 덮어쓰기 하고 싶을 때 이런 식으로 써도 됨  

# EXPOSE 
EXPOSE 명령어 뒤에 8080 과 같이 포트번호를 기재할 수 있음  
``` 포트번호 : 컴퓨터에 뚫린 구멍```  
편의를 위해 쓰는 메모같은 개념 없어도 상관은 없음  

# DOCKER BUILD
```
docker build -t 이미지이름:태그 .
```
Dockerfile 작성했으면 이걸 바탕으로 이미지를 하나 만들어달라고 명령  
작업 폴더에서 터미널 열어서 입력  

\- 이미지 이름은 맘대로 작명
\- 태그도 맘대로 작명, 태그는 버전이랑 비숫하게 취급
\- 마침표 자리에는 Dockerfile 경로 입력하면 됨
\- (참고) docker desktop 또는 docker engin이 실행되고 있어야 이 명령어가 사용가능  

입력하면 커스텀 이미지가 생성됨  
이미지 확인은 docker desktop 들어가거나 터미널에 ```docker images```입력  

# 이미지 실행하기
재생버튼 누르거나 docker run 명령어 입력하면 됨  
근데 포트 부분에 포트번호 기입해서 실행  
터미널 사용할 것이면 ```docker run -p 포트번호:8080``` 이미지명:태그명 입력하면 됨  


**(참고) 도커 파일 세팅은 터미널에 docker init 명령어 써도 자동으로 채워줌**