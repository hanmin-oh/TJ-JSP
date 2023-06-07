<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.tjoeun.memoList.DBUtil"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>출석 페이징</title>

    <style type="text/css">
        a {
            color: black;
            text-decoration: none;
        }
        a:hover {
            color: blue;
            text-decoration: none;
            cursor: pointer;
        }
    </style>
</head>
<body>

<!-- 입력 화면 시작 -->
<form action="memoInsert.jsp" method="post">
    <table width="1000" align="center" border="1" cellpadding="5" cellspacing="0">
        <tr>
            <th colspan="3">출석 게시판 Ver 0.1</th>
        </tr>
        <tr>
            <th width="100">이름</th>
            <th width="100">비밀번호</th>
            <th width="800">메모</th>
        </tr>
        <tr>
            <td align="center">
                <input type="text" name="name" style="width:90%; height: 25px;"/>
            </td>
            <td align="center">
                <input type="text" name="password" style="width:90%; height: 25px;"/>
            </td>
            <td align="center">
                <input type="text" name="memo" style="width:90%; height: 25px;"/>
                <input type="submit" value="저장" style="height: 28px;"/>
            </td>
        </tr>
    </table>
</form>

<br/>
<hr size="3" color="dodgerblue"/>
<br/>

<%
    int pageSize = 10; // 페이지당 표시하려는 글의 개수
    int totalCount = 0; // 테이블에 저장된 전체 글의 개수
    int totalPage = 0; // 전체 페이지 개수
    int currentPage = 1; // 현재 브라우저에 표시되는 페이지 번호
    int startNo = 0; // 현재 브라우저에 표시되는 글의 시작 인덱스 번호 => mysql은 인덱스가 0부터 시작한다.
    int endNo = 0; // 현재 브라우저에 표시되는 글의 마지막 인덱스 번호, mysql에서는 사용하지 않는다.
    int startPage = 0; // 페이지 이동 하이퍼링크 또는 버튼의 표시될 시작 페이지 번호
    int endPage = 0; // 페이지 이동 하이퍼링크 또는 버튼의 표시될 마지막 페이지 번호

    Connection conn = DBUtil.getMysqlConnection();
    String sql = "SELECT COUNT(*) FROM memolist";
    PreparedStatement pstmt = conn.prepareStatement(sql);
    pstmt = conn.prepareStatement(sql);
    ResultSet rs = pstmt.executeQuery();
    rs.next();
    totalCount = rs.getInt(1);
    totalPage = (totalCount - 1) / pageSize + 1;
    try {
        currentPage = Integer.parseInt(request.getParameter("currentPage"));
        currentPage = currentPage > totalPage ? totalPage : currentPage ;
    } catch (NumberFormatException e) {
    }
    /*startNo = (currentPage - 1) * pageSize;
    endNo = startNo + pageSize - 1;
    endNo = endNo < totalCount ? totalCount : endNo;
    sql = "SELECT * FROM memolist ORDER BY idx DESC limit ?, ?";
    pstmt = conn.prepareStatement(sql);
    rs = pstmt.executeQuery();
    pstmt.setInt(1, startNo);
    pstmt.setInt(2 , pageSize);*/
%>

<table width="1200" align="center" border="1" cellpadding="5" cellspacing="0">
    <tr>
        <th width="80">글 번호</th>
        <th width="80">이름</th>
        <th width="840">메모</th>
        <th width="120">작성일</th>
        <th width="80">ip</th>
    </tr>

    <tr>
        <td colspan="5" align="right">
            <%=totalCount%>(<%=currentPage%> / <%=totalPage%>)
        </td>
    </tr>

    <%
        if(rs.next()) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd(E)");
            do {
    %>
    <tr>
        <td align="center"><%=rs.getInt("idx") %></td>
        <td align="center"><%=rs.getString("name") %></td>
        <td><%=rs.getString("memo") %></td>
        <td align="center"><%=sdf.format(rs.getTimestamp("writeDate")) %></td>
        <td><%=rs.getString("ip") %></td>
    </tr>

    <%
        } while(rs.next());
    } else {
    %>

    <tr>
        <td colspan="5">
            테이블에 저장된 데이터가 없습니다.
        </td>

    <%
        }
    %>
    </tr>
    <%--6. 첫 페이지부터 마지막 페이지까지 이동할 수 있는 하이퍼링크 또는 버튼을 만든다.--%>
    <tr>
    <td colspan="5">
        <%-- 10 페이지 단위로 페이지 이동 버튼을 추가한다. --%>

        <%

        %>

            <%


        // 페이지 이동 버튼의 시작 페이지 번호와 마지막 페이지 번호를 계산한다.
            startPage = (currentPage -1) / 10 * 10 + 1;
            endPage = startPage + 9;
        // 페이지 이동 버튼의 마지막 페이지 번호가 전체 페이지 개수보다 커지면 존재하지 않는 페이지 번호가
        // 표시되므로 마지막 페이지 번호(endPage)를 전체 페이지 번호로 수정한다.
            endPage = endPage > totalPage ? totalPage : endPage;
        //처음으로 - currentPage가 1보다 크다면 처음으로 이동할 수 있다.
           %>
            <button type="button" title="처음으로 이동합니다." onclick="location.href='?currentPage=1'">처음으로 이동</button>
           <%
            //10페이지 앞으로
            //startPage가 1보다 크면 10페이지가 있다.
            if(startPage > 1) {
            %>
               <button type="button" title="다음 10페이지로 이동합니다." onclick="location.href='?currentPage=<%=endPage+1%>'">이전</button>
            <%
            }else {
            %>
                <button type="button" disabled="disabled" title="이미 첫 10페이지 입니다.">다음</button>
            <%
            }
            //10페이지 단위로 페이지 이동 버튼을 출력한다.
            for(int i = startPage ; i<=endPage; i++) {
                if (currentPage == i) {
                    out.println("<button type='button' disabled='disabled'>" + i + "</button>");
                } else {
                    out.println("<button type='button' onclick='location.href=\"?currentPage=" + i + "\"'>" + i + "</button>");
                }
            }
        //10페이지 뒤로
        // endpage가 totalpage보다 작으면 다음 10페이지가 있다.
            if(endPage < totalPage) {
        %>
            <button type="button" title="다음 10페이지로 이동합니다." onclick="location.href='?currentPage=<%=endPage+1%>'">다음</button>
        <%
            }  else {
        %>
            <button type="button" disabled="disabled" title="이미 마지막 10페이지 입니다.">다음</button>
        <%
            }

        //마지막으로
        //cuurentPage가 totalPage보다 작으면 마지막 페이지로 이동할 수 있다.
            if(currentPage < totalPage) {
        %>
            <button type="button" title="마지막으로 이동합니다." onclick="location.href='?currentPage=<%= totalPage %>'">마지막</button>
        <%
            } else  {
        %>
            <button type="button" disabled="disabled" title="이미 마지막 페이지입니다.">마지막</button>
        <%
            }
        %>

        </td>
    </tr>
</table>
</body>
</html>