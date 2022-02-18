// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   FlikeyDAO.java

package likeys;

import boardWeb.util.DBManager;
import java.sql.*;

public class FlikeyDAO
{

    public FlikeyDAO()
    {
    }

    public int like(int midx, int bidx, String userIP)
    {
        String sql;
        Connection conn;
        PreparedStatement psmt;
        ResultSet rs;
        sql = "insert into likey values(?,?,?)";
        conn = null;
        psmt = null;
        rs = null;
        
        try {
        	conn = DBManager.getConnection();
            psmt = conn.prepareStatement(sql);
            psmt.setInt(1, midx);
            psmt.setInt(2, bidx);
            psmt.setString(3, userIP);
            
            return psmt.executeUpdate();
        }catch(Exception e) {
        	e.printStackTrace();
        }finally {
        	DBManager.close(psmt, conn, rs);
        }
        return -1;
    }
}
