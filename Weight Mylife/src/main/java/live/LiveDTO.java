// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   LiveDTO.java

package live;


public class LiveDTO
{

    public LiveDTO()
    {
    }

    public String getBoardType()
    {
        return boardType;
    }

    public void setBoardType(String boardType)
    {
        this.boardType = boardType;
    }

    public int getBidx()
    {
        return bidx;
    }

    public void setBidx(int bidx)
    {
        this.bidx = bidx;
    }

    public String getSubject()
    {
        return subject;
    }

    public void setSubject(String subject)
    {
        this.subject = subject;
    }

    private int bidx;
    private String subject;
    private String boardType;
}
