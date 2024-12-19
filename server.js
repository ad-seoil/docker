// express 라이브러리 사용
const express = require("express");
const app = express();

// url에 웹 서버 띄워달라는 
app.listen(8083, () => {
    console.log("서버 실행 중  http://localhost:8083");
});

// 접속하면 안녕이라는 텍스트를 보내달라
app.get("/", (req, res) => {
    res.send("Hello World!");
});