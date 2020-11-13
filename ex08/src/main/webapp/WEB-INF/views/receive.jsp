<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style>
      .read{color:blue; font-size:18px;}
      .unread{color:red; font-size:18px;}
      #divRead{margin-top:30px;}
   </style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>receive</title>
<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.1/handlebars.js"></script>
</head>
<body>
	<h1>Receive Message</h1>
	<table border=1>
		<tr>
			<td width=110>Receiver</td>
			<td width=200>${vo.uname}</td>
			<td width=145 >Point</td>
			<td width=200 ><span id="point">${vo.point}</span></td>
		</tr>
	</table>	
	<br>
	<table border=1 id="tbl"></table>
	<script id="temp" type="text/x-handlebars-template">
<tr >
<td width=150>sender</td>
<td width=300>content</td>
<td width=150>sendDate</td>
<td width=50>read</td>
</tr>
{{#each .}}
<tr class="row">
<td width=150>{{sender}}-{{uname}}</td>
<td width=200>{{message}}</td>
<td width=150>{{sendDate}}</td>
<td><button class="{{confirm readDate}}" mid="{{mid}}">read</button></td>
</tr>
{{/each}}
</script>
	<script>
	Handlebars.registerHelper("confirm",function(readDate){
		 if(!readDate) return "unread" ;
		 else return "read" ;
	 });
	</script>
	<div id="divRead" style="width:660px;background:pink;color:gray;padding:10px;">
	sender:<span id="sender" style="padding:10px;"></span><br>
	content:<span id="message" style="padding:10px;"></span><br>
	sendDate:<span id="sendDate" style="padding:10px;"></span><br>
	readDate:<span id="readDate" style="padding:10px;"></span>
	</div>
</body>
<script>
var receiver="${vo.uid}"
getList();

$("#divRead").hide();
$("#tbl").on("click",".row button",function(){
	var mid=$(this).attr("mid");
	$("#divRead").show();
	$.ajax({
		type:"get",
		url:"readMessage",
		data:{"mid":mid},
		success:function(data){
	         $("#sender").html(data.uname);
	         $("#message").html(data.message);
	         $("#sendDate").html(data.sendDate);
	         $("#readDate").html(data.readDate);
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
			"uid" : receiver,			
		},
		success : function(data) {
			$("#point").html(data.point);
		}
		
	});
}

function getList(){
	$.ajax({
		type:"get",
		url:"receiveList",
		data:{"receiver":receiver},
		success:function(data){
			var temp=Handlebars.compile($("#temp").html());
	         $("#tbl").html(temp(data));

		}
	});
}
</script>
</html>


















