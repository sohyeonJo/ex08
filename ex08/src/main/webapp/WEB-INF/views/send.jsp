<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Send</title>
<style>
      .read{color:blue; font-size:18px;}
      .unread{color:red; font-size:18px;}
   </style>
<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.1/handlebars.js"></script>
</head>
<body>
	<h1>Send Message</h1>
	<table border=1>
		<tr>
			<td width=100>Send User</td>
			<td width=500>${vo.uname}
			 >point:<b><span id="point">${vo.point }</b></span>
			 </td>
		</tr>
		<tr>
			<td width=100>Receive User</td>
			<td><select id="receiver">
					<c:forEach items="${list }" var="v">
						<c:if test="${vo.uid !=v.uid}">
							<option value="${v.uid }">${v.uname}</option>
						</c:if>
					</c:forEach>
			</select></td>
		</tr>
		<tr>
			<td>Content</td>
			<td><input type="text" size=80 id="txtMessage"></td>
		</tr>
	</table>
	<button id="btnSend">Send</button>
    <h1>Sent Message</h1>
    <table id="tbl" border=1></table>
    <script id="temp" type="text/x-handlebars-template">
<tr>
<td width=100>receiver</td>
<td width=300>Message</td>
<td width=200>Send Date</td>
<td width=150>check</td>
</tr>     
{{#each .}}
<tr class="row">
<td>{{receiver}}<br>{{uname}}</td>
<td>{{message}}</td>
<td>{{sendDate}}</td>
<td>{{{confirm readDate}}}&nbsp;&nbsp;<a href="{{mid}}">delete</a></td>
</tr> 

{{/each}}
 </script>
 <script>
 Handlebars.registerHelper("confirm",function(readDate){
	 if(!readDate) return "<span class=unread>unread</span>" ;
	 else return "<span class=read>read</span>" ;
 });
 </script>
</body>
<script>
	var sender = "${vo.uid}";
	
	$("#tbl").on("click",".row a",function(e){
		e.preventDefault();
		var mid=$(this).attr("href");
		if(!confirm(mid+"do you delete?")) return;
		$.ajax({
			type:"post",
			url:"delete",
			data:{"mid":mid},
			success:function(data){
				alert("delete success");
				getList();

			}
		});
	});
	getList();
	function getList(){
		$.ajax({
			type:"get",
			url:"sendList",
			data:{"sender":sender},
			success:function(data){
				var temp=Handlebars.compile($("#temp").html());
		         $("#tbl").html(temp(data));

			}
		});
	}
	
	$("#btnSend").on("click", function() {
		var receiver = $("#receiver").val();
		var message = $("#txtMessage").val();
		if (message == "") {
			alert("insert message");
			return;
		}
		if (!confirm("do you send?"))
			return;
		$.ajax({
			type : "post",
			url : "insert",
			data : {
				"sender" : sender,
				"receiver" : receiver,
				"message" : message
			},
			success : function() {
				alert("goood");
				$("#txtMessage").val();
				getList();
				getUser();
			}

		});
	});
	
	function getUser(){
		$.ajax({
			type : "get",
			url : "read",
			data : {
				"uid" : sender,			
			},
			success : function(data) {
				$("#point").html(data.point);
			}
			
		});
	}
</script>
</html>
















