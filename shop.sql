-- 상품테이블
create table goods(
	gid char(8) not null primary key, -- 상품코드
    title varchar(300) not null,  -- 상품제목
    price int default 0, -- 가격
    maker varchar(200), -- 제조사
    image varchar(300), -- 이미지
    regDate datetime default now() -- 날짜
    
);
desc goods;
select * from goods;
select count(*)  from goods;

-- delete from goods where price >= 0;

-- SET sql_safe_updates = 0;


delete from goods where gid="87494d09";

-- 사용자테이블
create table users(
uid varchar(20) not null primary key, -- 사용자 아이디
upass varchar(200) not null, -- 사용자 비번
uname varchar(20) not null, -- 사용자 이름
phone varchar(20),          -- 전화번호
address1 varchar(300),    -- 주소
address2 varchar(300),   
regDate datetime default now(),   -- 가입일자 
photo varchar(200)     -- 사진
);
select * from users;


insert into users(uid, upass,uname, phone,address1,address2) 
values('blue','pass','최블루','010-3333-4444', '인천 서구 청라3동','자이아파트 101호');
insert into users(uid, upass,uname, phone,address1,address2) 
values('red','p1234','김레드','010-3333-5555', '인천 중구서 신흥동','삼익아파트 102호');


-- 구매자테이블
create table purchase(
pid char(13) not null primary key,   -- 주문자(구매자)아이디
uid varchar(20) not null,  -- 사용자 아이디
raddress1 varchar(300),  -- 주문 주소
raddress2 varchar(300),
rphone varchar(20),    -- 주문 전화
purDate datetime default now(),   -- 주문일
status int default 0, -- 주문 상태 
pursum int default 0,  -- 주문총액 
foreign key(uid) references users(uid)  -- 외래키 : 사용자아이디와 주문자 아이디
);

select * from purchase;
select count(*) from purchase;


-- 주문상품 테이블
create table orders(
oid int auto_increment primary key,  -- 주문상품아이디 (자동생성)
pid char(13) not null,  -- 주문자 아이디
gid char(8) not null,    -- 상품코드
price int default 0,   -- 가격
qnt int default 0,     -- 수량
foreign key(pid) references purchase(pid), -- 외래키: 주문자아이디(구매자/상품주문)
foreign key(gid)  references goods(gid)  -- 외래키 :  상품코드
);

select * from orders;
select count(*) from orders;

-- DROP TABLE ORDERS;
create view view_purchase as
select p.*, uname
from purchase p, users u
where p.uid=u.uid;

select * from view_purchase where unmae='이블루';


select * from orders where pid='44b221b4-1f71';

create view view_orders as
select o.*,title, image
from orders o, goods g
where o.gid=g.gid;

select * from  view_orders;

alter table users add role int default 2;
select * from users;
 

insert into users(uid, upass,uname,role) 
values('manager','pass','관리자',1);

create table reviews(
rid int auto_increment primary key, -- 리뷰번호
uid varchar(20) not null, -- 사용자 아이디
gid char(8) not null, -- 상품코드
revdate datetime default now(), -- 리뷰일자
content text, -- 리뷰내용
foreign key(uid) references users(uid),
foreign key(gid)  references goods(gid)  

);
select * from reviews;

create view view_reviews as
select r.*,uname,photo
from reviews r, users u
where r.uid=u.uid;



-- drop table reviews;

create table favorite(
gid char(8) not null, -- 상품코드
uid varchar(20) not null,  -- 사용자 아이디
regDate datetime default now(), -- 좋아요 클릭일자
primary key(gid,uid),
foreign key(uid) references users(uid),
foreign key(gid)  references goods(gid)  
);


insert into favorite(gid,uid) values('112dfb88','blue');

select count(*) ucnt from favorite where gid='112dfb88' and uid='blue';

select count(*) fcnt, (select  count(*) where gid='112dfb88' and uid='blue') ucnt
from favorite where gid='112dfb88';



create view view_goods as
select *,
(select count(*) from reviews where gid=g.gid) rcnt,
(select count(*) from favorite where gid=g.gid) fcnt
from goods g
order by regDate desc;


select * from purchase where uid='blue';

