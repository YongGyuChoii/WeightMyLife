// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   ElikeyDAO.java

package likeys;

import boardWeb.util.DBManager;
import java.sql.*;

public class ElikeyDAO
{

    public ElikeyDAO()
    {
    }

    public int like(int midx, int ebidx, String userIP)
    {
        String sql;
        Connection conn;
        PreparedStatement psmt;
        ResultSet rs;
        sql = "insert into elikey values(?,?,?)";
        conn = null;
        psmt = null;
        rs = null;
        try {
        	conn = DBManager.getConnection();
            psmt = conn.prepareStatement(sql);
            psmt.setInt(1, midx);
            psmt.setInt(2, ebidx);
            psmt.setString(3, userIP);
            return psmt.executeUpdate();
        }catch(Exception e){
			e.printStackTrace();
		}finally{
			DBManager.close(psmt,conn,rs);
		}
		return -1; // 추천 중복 오류
    }
}
