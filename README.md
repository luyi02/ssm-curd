# ssm-curd

## 1.程序的基本功能

 - 对员工数据的增删改查
 - 数据合法性的校验

## 2.项目实现

 - 这个项目整合了SSM框架，通过SSM框架进行对员工数据的增删改查；
 - 通过maven管理我们的依赖包；
 - 通过逆向工程生成了我们的bean，mapper层接口，SQL映射文件等；
 - 通过Ajax发起请求，获取json数据；
 - 通过前端校验和后端校验（JSR303校验）对数据的合法性进行校验；

## 3.运行环境

 - maven的目录结构（搭建的是一个maven项目）
 - Dynamic Web2.5版本
 - jdk8版本
 - MySQL8.0.17版本
 - tomcat8.0.17版本
 - eclipse4.4.2版本

## 4.环境搭建--数据库环境的搭建

创建数据库：

	create database myssm;

创建数据表：

	# employee员工表
	CREATE table employee(
		nid int auto_increment PRIMARY KEY,
		name VARCHAR(20),
		d_id int
		)

	# department部门表
	CREATE table department(
		nid int auto_increment PRIMARY KEY,
		name VARCHAR(20)
		)

	#建外键
	alter table employee add constraint dp_epml_fn foreign key
	
	employee(d_id) references department(nid);

## 5.代码目录

	/ssm-crud
	
	|--.settings
	
	|--WebContent
	
	   |--META-INF
	
	   |--WEB-INF
	
	      |--views
	
	      |--web.xml
	
	   |--static
	
	      |--css
	
	      |--fonts
	
	      |--js
	
	   |--index.jsp
	
	   |--indexAjax.jsp
	
	|--src/main
	
	   |--java/com/luyi
	
	      |--bean
	      
	      |--controller
	
	      |--dao
	
	      |--service
	
	      |--test
	
	   |--resources
	
	      |--mapper
	
	         |--DepartmentMapper.xml
	
	         |--EmployeeMapper.xml
	
	      |--applicationContext.xml
	
	      |--dbconfig.properties
	
	      |--mybatis-config.xml
	
	      |--springMvc.xml
	
	
	|--target
	
	|--mbg.xml
	
	|--pom.xml


