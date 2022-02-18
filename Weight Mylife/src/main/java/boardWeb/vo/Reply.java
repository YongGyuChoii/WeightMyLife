// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   Reply.java

package boardWeb.vo;


public class Reply
{

    public Reply()
    {
    }

    public String getMemberName()
    {
        return memberName;
    }

    public void setMemberName(String memberName)
    {
        this.memberName = memberName;
    }

    public int getRidx()
    {
        return ridx;
    }

    public void setRidx(int ridx)
    {
        this.ridx = ridx;
    }

    public int getMidx()
    {
        return midx;
    }

    public void setMidx(int midx)
    {
        this.midx = midx;
    }

    public int getBidx()
    {
        return bidx;
    }

    public void setBidx(int bidx)
    {
        this.bidx = bidx;
    }

    public String getRcontent()
    {
        return rcontent;
    }

    public void setRcontent(String rcontent)
    {
        this.rcontent = rcontent;
    }

    public String getRdate()
    {
        return rdate;
    }

    public void setRdate(String rdate)
    {
        this.rdate = rdate;
    }

    private int ridx;
    private int midx;
    private int bidx;
    private String rcontent;
    private String rdate;
    private String memberName;
}
