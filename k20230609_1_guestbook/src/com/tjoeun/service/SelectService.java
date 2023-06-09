package com.tjoeun.service;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.tjoeun.dao.GuestbookDAO;
import com.tjoeun.ibatis.MyAppSqlConfig;
import com.tjoeun.vo.GuestbookList;
import com.tjoeun.vo.GuestbookVO;

import java.sql.SQLException;

public class SelectService {

    private static SelectService instance = new SelectService();

    private SelectService() {    }

    public static SelectService getInstance () {
        return instance;
    }

   /*  list.jsp에서 호출되는 브라우저에 표시할 페이지 번호(currentPage)를 넘겨받고 mapper를 얻어온 후
     GuestbookDAO 클래스의 1페이지 분량의 글 목록을 얻어오는 select sql 명령을 실행하는 메소드를 호출하는
     메소드    */
    public GuestbookList selectList(int currentPage) throws SQLException {
        System.out.println("SelectService 클래스의 selectService() 메소드 실행");
        SqlMapClient mapper = MyAppSqlConfig.getSqlMapInstance();

        // 1페이지 분량의 글 목록과 페이징 작업에 사용할 8개의 변수를 저장해서 리턴시킬 객체를 선언한다.
        GuestbookList guestbookList = null;

        // 1페이지당 표시할 글의 개수를 정한다.
        int pageSize = 10;
        // 테이블에 저장된 전체 글의 개수를 얻어온다.
        int totalCount = GuestbookDAO.getInstance().selectCount(mapper);
        System.out.println(totalCount);
        return guestbookList;
    }


}
