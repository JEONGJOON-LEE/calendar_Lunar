<%@page import="com.koreait.myCalendar.LunarDate"%>
<%@page import="com.koreait.myCalendar.SolaToLunar"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.koreait.myCalendar.MyCalendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>만년달력</title>
<link rel="icon" href="./calendar.png">

<link rel="stylesheet" href="calendar.css">

</head>
<body>
	<%
	Calendar calendar = Calendar.getInstance();
	int year = calendar.get(Calendar.YEAR);
	int month = calendar.get(Calendar.MONTH) + 1;
	
	try{
		year = Integer.parseInt(request.getParameter("year"));
		month = Integer.parseInt(request.getParameter("month"));
		
	if(month >= 13){
		year++;
		month = 1;
	} else if(month <= 0){
		year--;
		month = 12;
	}
	 
	} catch(NumberFormatException e){}
	
//	달력을 출력할 달의 양력 음력 대응 결과를 얻어온다.
	ArrayList<LunarDate> lunarDate = SolaToLunar.solaToLunar(year, month);

%>

	<!-- 달력을 만든다. -->
	<table width="700" align="center" border="1" cellpadding="5"
		cellspacing="2">
		<tr>
			<th><input class="select" type="button" value="이전달"
				onclick="location.href='?year=<%=year%>&month=<%=month - 1%>'">
			</th>
			<th id="title" colspan="5"><%=year%>년 <%=month%>월</th>
			<th>
				<button class="select type="
					button" onclick="location.href='?year=<%=year%>&month=<%=month + 1%>'">다음달</button>
			</th>
		</tr>

		<tr>
			<td id="sunday">일</td>
			<td class="etcday">월</td>
			<td class="etcday">화</td>
			<td class="etcday">수</td>
			<td class="etcday">목</td>
			<td class="etcday">금</td>
			<td id="saturday">토</td>
		</tr>

		<tr>
			<%

	int week = MyCalendar.weekDay(year, month, 1);
	int start = 0;
	if (month == 1) {
		start = 31 - week;		
	} else {
		start = MyCalendar.lastDay(year, month-1) - week;		
	}

	for (int i = 0; i < week; i++){
		if (i == 0) {
			out.println("<td class='lastSun'>" + (month == 1 ? 12 : month -1) + "/" +  ++start + "</td>");
		} else {
			out.println("<td class='lastMon'>" + (month == 1 ? 12 : month -1) + "/" +  ++start + "</td>");
		}
	}

	for (int i = 1; i <= MyCalendar.lastDay(year, month); i++){
		
//		공휴일인가 판단해서 class 속성을 다르게 지정한 다음 날짜를 출력한다.		
		if (lunarDate.get(i - 1).getLunar().length() == 0) {
			switch(MyCalendar.weekDay(year, month, i)) {
				case 0:
					out.println("<td class='sun'>" + i + "</td>");
					break;
				case 6:
					out.println("<td class='sat'>" + i + "</td>");
					break;
				default :
					out.println("<td class='etc'>" + i + "</td>");
					break;
			}
		} else {
			out.println("<td class='holiday'>" + i + lunarDate.get(i - 1).getLunar() + "</td>");
		}

		if(MyCalendar.weekDay(year, month, i) == 6 && i != MyCalendar.lastDay(year, month)){
			out.println("</tr><tr>");
		}
	}

	if (month == 12) {
		week = MyCalendar.weekDay(year + 1, 1, 1);
	} else {
		week = MyCalendar.weekDay(year, (month + 1), 1);
	}
	
	if (week != 0) {
		start = 0;
	 	for(int i = week; i <= 6; i++){
	 		if (i == 6) {
	 			out.println("<td class='nextSat'>" + (month == 12 ? 1 : month + 1) + "/" + ++start);
	 		} else {
	 			out.println("<td class='nextMon'>" + (month == 12 ? 1 : month + 1) + "/" + ++start);
	 		}
	 	}
	}


%>
		</tr>

		<tr>
			<td colspan="7">
				<form action="?" method="post">
					<select class="select" name="year">
						<%
	for(int i = 1900; i <= 3000; i++){
		if (i == calendar.get(Calendar.YEAR)) {
			out.println("<option selected='selected'>" + i + "</option>");		
		} else {
			out.println("<option>" + i + "</option>");		
		}
	}
%>
					</select>년&nbsp;&nbsp;&nbsp; <select class="select" name="month">
						<%
	for (int i = 1; i <= 12; i++) {
		if (i == calendar.get(Calendar.MONTH) + 1){
			out.println("<option selected='selected'>" + i + "</option>");		
		} else {
			out.println("<option>" + i + "</option>");
		}
	}
%>
					</select>월&nbsp;&nbsp;&nbsp; <input class="select" type="submit" value="보기">
				</form>
			</td>
		</tr>


	</table>

</body>
</html>









