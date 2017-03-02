drop database if exists 医药销售管理系统;
create database 医药销售管理系统;
use 医药销售管理系统;

create table `会员`(
		客户编号      int auto_increment,
        客户姓名      varchar(50),
        联系方式      varchar(100),
	primary key(客户编号));


insert into `会员`(客户姓名,联系方式)values("小华","13380026307");
insert into `会员`(客户姓名,联系方式)values("龙叔","15323397607");
insert into `会员`(客户姓名,联系方式)values("翠花","15361752370");
insert into `会员`(客户姓名,联系方式)values("阿豹","17727760587");

create table `供应商`(
		供应商编号     int auto_increment,
        供应商名称     varchar(50),
        联系人         varchar(50),
        联系方式       varchar(50),
        所在城市       varchar(50),
	primary key(供应商编号));


insert into `供应商`(供应商名称,联系人,联系方式,所在城市)values("易方达医药厂","马小姐","13711158028","广东");
insert into `供应商`(供应商名称,联系人,联系方式,所在城市)values("国裕医药厂",  "陈先生","13682255772","浙江");
insert into `供应商`(供应商名称,联系人,联系方式,所在城市)values("天马大药房",  "王先生","15220000531","安徽");
insert into `供应商`(供应商名称,联系人,联系方式,所在城市)values("春天100",     "杨女士","15800016108","湖北");

create table `药品`(
		药品编号    int auto_increment,
        药品名称    varchar(50) not null,
        供应商编号  int not null,
        生产批号    varchar(100),
        产地        varchar(50),
        所属类别    varchar(50),
        进价        decimal(10,2) not null,
        单价        decimal(10,2) not null,
        会员折扣    decimal(3,2),
        库存        int not null,
        包装规格    varchar(50),
        生产日期    varchar(50),
        有效期      varchar(50),
	primary key(药品编号),
	INDEX `供应商编号_idx` (`供应商编号` ASC),
	CONSTRAINT `供应商编号`
    FOREIGN KEY (`供应商编号`)
    REFERENCES `医药销售管理系统`.`供应商` (`供应商编号`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

create table `登录用户`(
		用户编号         int auto_increment,
        用户名			 varchar(40) not null unique,
        密码			 varchar(40) not null,
        类别             int not null,
	primary key(用户编号));

insert into `登录用户`(用户名,密码,类别)values("经理1","123",2);
insert into `登录用户`(用户名,密码,类别)values("张三","123",1);
insert into `登录用户`(用户名,密码,类别)values("李四","123",1);
insert into `登录用户`(用户名,密码,类别)values("王五","123",1);
insert into `登录用户`(用户名,密码,类别)values("赵六","123",1);

create table `经理`(
		经理编号      int auto_increment,
        用户编号      int not null,
	primary key(经理编号),
	INDEX `经理编号_idx` (`用户编号` ASC),
	CONSTRAINT `经理登陆编号`
    FOREIGN KEY (`用户编号`)
    REFERENCES `医药销售管理系统`.`登录用户` (`用户编号`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);


insert into `经理`(用户编号)values(1);

create table `员工`(
		员工编号      int auto_increment,
        员工姓名      varchar(50),
        联系电话      varchar(100),
        用户编号      int not null,
	primary key(员工编号),
	INDEX `员工编号_idx` (`用户编号` ASC),
	CONSTRAINT `员工登陆编号`
    FOREIGN KEY (`用户编号`)
    REFERENCES `医药销售管理系统`.`登录用户` (`用户编号`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);


insert into `员工`(员工姓名,联系电话,用户编号)values("张三","13302210781",2);
insert into `员工`(员工姓名,联系电话,用户编号)values("李四","13302399267",3);
insert into `员工`(员工姓名,联系电话,用户编号)values("王五","13312853782",4);
insert into `员工`(员工姓名,联系电话,用户编号)values("赵六","13316219253",5);

CREATE TABLE `财政收支` (
	`收支编号` int auto_increment,
	`药品编号` int,
	`员工编号` int not null,
	`数量` int,
	`日期` datetime NOT NULL,
	`总额` decimal(10,2) NOT NULL,
    `类型` VARCHAR(20)  NOT NULL,
	PRIMARY KEY (`收支编号`),
	INDEX `药品编号_idx` (`药品编号` ASC),
	CONSTRAINT `药品编号`
    FOREIGN KEY (`药品编号`)
    REFERENCES `医药销售管理系统`.`药品` (`药品编号`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
	INDEX `员工编号_idx` (`员工编号` ASC),
	CONSTRAINT `负责员工编号`
    FOREIGN KEY (`员工编号`)
    REFERENCES `医药销售管理系统`.`员工` (`员工编号`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

create table `入库记录`(
		入库记录编号   int auto_increment,
        供应商编号     int not null,
        收支编号       int not null,
	primary key(入库记录编号),
	INDEX `供应商编号_idx` (`供应商编号` ASC),
	INDEX `收支编号_idx` (`收支编号` ASC),
	CONSTRAINT `入货供应商编号`
    FOREIGN KEY (`供应商编号`)
    REFERENCES `医药销售管理系统`.`供应商` (`供应商编号`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
	CONSTRAINT `入库收支编号`
    FOREIGN KEY (`收支编号`)
    REFERENCES `医药销售管理系统`.`财政收支` (`收支编号`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

CREATE TABLE `销售管理`(
	`销售编号` int auto_increment,
	`客户编号` int,
	`收支编号` int not null,
	PRIMARY KEY (`销售编号`),
	INDEX `客户编号_idx` (`客户编号` ASC),
	INDEX `收支编号_idx` (`收支编号` ASC),
	CONSTRAINT `销售客户编号`
    FOREIGN KEY (`客户编号`)
    REFERENCES `医药销售管理系统`.`会员` (`客户编号`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
	CONSTRAINT `销售收支编号`
    FOREIGN KEY (`收支编号`)
    REFERENCES `医药销售管理系统`.`财政收支` (`收支编号`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

CREATE TABLE `退货管理` (
	`退货编号` int auto_increment,
	`销售编号` int NOT NULL,
	`收支编号` int NOT NULL,
	PRIMARY KEY (`退货编号`),
	INDEX `销售编号_idx` (`销售编号` ASC),
	INDEX `收支编号_idx` (`收支编号` ASC),
	CONSTRAINT `退货销售编号`
    FOREIGN KEY (`销售编号`)
    REFERENCES `医药销售管理系统`.`销售管理` (`销售编号`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
	CONSTRAINT `退货收支编号`
    FOREIGN KEY (`收支编号`)
    REFERENCES `医药销售管理系统`.`财政收支` (`收支编号`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

drop view if exists warehouse;
create view warehouse as
select 药品编号,药品名称,供应商名称,生产批号,产地,所属类别,进价,单价,会员折扣,库存,包装规格,生产日期,有效期
from 药品,供应商 where 药品.供应商编号=供应商.供应商编号; 

drop view if exists InDrug_records;
create view InDrug_records as
select 入库记录编号,药品名称,供应商名称,员工姓名,数量,日期,总额 
from 入库记录,供应商,财政收支,员工,药品
where 入库记录.供应商编号=供应商.供应商编号 and 入库记录.收支编号=财政收支.收支编号 and
财政收支.员工编号=员工.员工编号 and 财政收支.药品编号=药品.药品编号;

drop view if exists sales_records;
create view sales_records as
select 销售编号,药品.药品编号,药品名称,单价,会员折扣,库存,客户姓名,员工姓名,数量,日期,总额
from 销售管理,会员,财政收支,员工,药品
where 销售管理.客户编号=会员.客户编号 and 销售管理.收支编号=财政收支.收支编号
and 财政收支.员工编号=员工.员工编号 and 财政收支.药品编号=药品.药品编号;

drop view if exists reject_records;
create view reject_records as
select 退货编号,退货管理.销售编号,药品名称,客户姓名,员工姓名,数量,日期,总额
from 退货管理,销售管理,会员,财政收支,员工,药品
where 退货管理.销售编号=销售管理.销售编号 and 销售管理.客户编号=会员.客户编号 
and 退货管理.收支编号=财政收支.收支编号 and 财政收支.员工编号=员工.员工编号 
and 财政收支.药品编号=药品.药品编号;

drop view if exists employee_info;
create view employee_info as
select 员工编号,员工姓名,联系电话,员工.用户编号,用户名 from `员工` natural join `登录用户`;

drop view if exists financial_records;
create view financial_records as
select 类型,药品名称,数量,日期,总额 
from `财政收支` left join `药品` on `财政收支`.药品编号=`药品`.`药品编号`;

drop procedure if exists payments_statistics;
delimiter //
create procedure payments_statistics(in date_limit varchar(20))
begin
	select count(*) as 数目,sum(`总额`) as 盈亏, 
    (select sum(`总额`) from `财政收支` where `总额` < 0 and `日期` like date_limit) as '支出', 
    (select sum(`总额`) from `财政收支` where `总额` >= 0 and `日期` like date_limit) as '收入' 
    from `财政收支` where `日期` like date_limit;
end//

drop trigger if exists stock_update;
delimiter //
create trigger stock_update before update on 药品
for each row
begin
	if new.库存 < 0
	then delete from 药品 where 药品编号=new.药品编号;
    end if;
end //
update 药品 set 库存=-2 where 药品编号=1;

drop trigger if exists drugs_insert;
delimiter //
create trigger drugs_insert before insert on 药品
for each row
begin
	if new.库存 < 0 or new.单价 < 0 or new.进价 < 0 or new.会员折扣 > 1 or new.会员折扣 < 0
	then delete from 药品 where 药品编号=new.药品编号;
    end if;
end //

drop trigger if exists refunds_insert;
delimiter //
create trigger refunds_insert after insert on 退货管理
for each row
begin
	if (select 数量 from sales_records where 销售编号 = new.销售编号) < (select 数量 from reject_records where 退货编号 = new.退货编号)
	then delete from 退货管理 where 退货编号=new.退货编号;
    end if;
end //

select * from reject_records;